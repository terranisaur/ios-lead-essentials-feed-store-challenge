//
//  CoreDataFeedStore+FeedStore.swift
//  FeedStoreChallenge
//
//  Created by Alex Thurston on 5/10/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation
import CoreData

extension CoreDataFeedStore: FeedStore {
	public func retrieve(completion: @escaping RetrievalCompletion) {
		let context = self.context
		context.perform {
			do {
				guard let feed = try CoreDataFeed.fetchCoreDataFeed(context: context) else {
					completion(.empty)
					return
				}
				let images = Array(feed.coreDataFeedImages)
				if images.isEmpty {
					completion(.empty)
					return
				}
				let localFeedImages = images.map { $0.localImage() }
				completion(.found(feed: localFeedImages, timestamp: feed.timestamp))
			} catch {
				completion(.failure(NSError(domain: "", code: 0)))
			}
		}
	}

	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		let context = self.context
		context.perform {
			let coreDataFeed = CoreDataFeed.createCoreDataFeed(context: context)
			let images = CoreDataFeedImage.coreDataImages(feed: feed, context: context)
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
