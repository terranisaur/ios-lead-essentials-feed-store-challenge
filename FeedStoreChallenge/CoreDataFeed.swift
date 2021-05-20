//
//  CoreDataFeed+CoreDataProperties.swift
//  FeedStoreChallenge
//
//  Created by Alex Thurston on 5/7/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CoreDataFeed)
final class CoreDataFeed: NSManagedObject {
	@NSManaged var timestamp: Date
	@NSManaged var feedImages: NSOrderedSet
}

extension CoreDataFeed {
	static func fetch(context: NSManagedObjectContext) throws -> CoreDataFeed? {
		let request = NSFetchRequest<CoreDataFeed>(entityName: "CoreDataFeed")
		return try context.fetch(request).first
	}

	static func createUniqueFeed(context: NSManagedObjectContext) throws -> CoreDataFeed {
		try deleteExistingFeed(from: context)
		return CoreDataFeed(context: context)
	}

	static func deleteExistingFeed(from context: NSManagedObjectContext) throws {
		if let existingFeed = try fetch(context: context) {
			context.delete(existingFeed)
		}
	}

	var localFeedImages: [LocalFeedImage] {
		return feedImages.compactMap { $0 as? CoreDataFeedImage }.map { $0.localImage }
	}
}
