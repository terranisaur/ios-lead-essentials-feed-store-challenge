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
		perform { context in
			do {
				guard let feed = try CoreDataFeed.fetch(context: context) else {
					completion(.empty)
					return
				}
				let images = feed.localFeedImages
				if images.isEmpty {
					completion(.empty)
					return
				}
				completion(.found(feed: images, timestamp: feed.timestamp))
			} catch {
				completion(.failure(error))
			}
		}
	}

	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		perform { context in
			do {
				let coreDataFeed = try CoreDataFeed.createUniqueFeed(context: context)
				let images = CoreDataFeedImage.images(feed: feed, context: context)
				coreDataFeed.feedImages = images
				coreDataFeed.timestamp = timestamp

				try CoreDataFeedStore.save(in: context)
				completion(nil)
			} catch {
				completion(error)
			}
		}
	}

	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		perform { context in
			do {
				try CoreDataFeed.deleteExistingFeed(from: context)
				try CoreDataFeedStore.save(in: context)
				completion(nil)
			} catch {
				completion(error)
			}
		}
	}
}
