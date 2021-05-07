//
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
	private static let modelName = "FeedStore"
	private static let model = NSManagedObjectModel(name: modelName, in: Bundle(for: CoreDataFeedStore.self))

	private let container: NSPersistentContainer
	private let context: NSManagedObjectContext

	struct ModelNotFound: Error {
		let modelName: String
	}

	public init(storeURL: URL) throws {
		guard let model = CoreDataFeedStore.model else {
			throw ModelNotFound(modelName: CoreDataFeedStore.modelName)
		}

		container = try NSPersistentContainer.load(
			name: CoreDataFeedStore.modelName,
			model: model,
			url: storeURL
		)
		context = container.newBackgroundContext()
	}

	public func retrieve(completion: @escaping RetrievalCompletion) {
		let request: NSFetchRequest<CoreDataFeed> = CoreDataFeed.fetchRequest()
		context.perform {
			do {
				guard let feed = try self.context.fetch(request).first else {
					completion(.empty)
					return
				}
				let images = Array(feed.coreDataFeedImages)
				if images.isEmpty {
					completion(.empty)
					return
				}
				let localFeedImages = images.map { img -> LocalFeedImage in
					LocalFeedImage(id: img.id, description: img.imageDescription, location: img.location, url: img.url)
				}
				completion(.found(feed: localFeedImages, timestamp: feed.timestamp))
			} catch {
				completion(.failure(NSError(domain: "", code: 0)))
			}
		}
	}

	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		let context = self.context
		context.perform {
			let coreDataFeed = CoreDataFeed(context: context)
			let images = NSOrderedSet(array: feed.map { localFeedImage in
				let image = CoreDataFeedImage(context: context)
				image.id = localFeedImage.id
				image.url = localFeedImage.url
				image.location = localFeedImage.location
				image.imageDescription = localFeedImage.description
				return image
			})
			coreDataFeed.feedImages = images
			coreDataFeed.timestamp = timestamp
			do {
				try context.save()
				completion(nil)
			} catch {
				completion(NSError(domain: "", code: 0))
			}
		}
	}

	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		fatalError("Must be implemented")
	}
}
