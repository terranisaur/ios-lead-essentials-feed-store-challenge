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
class CoreDataFeed: NSManagedObject {
	@NSManaged public var timestamp: Date
	@NSManaged public var feedImages: NSOrderedSet
}

extension CoreDataFeed {
	static func fetchCoreDataFeed(context: NSManagedObjectContext) throws -> CoreDataFeed? {
		let request = NSFetchRequest<CoreDataFeed>(entityName: "CoreDataFeed")
		return try context.fetch(request).first
	}

	static func createCoreDataFeed(context: NSManagedObjectContext) -> CoreDataFeed {
		return CoreDataFeed(context: context)
	}

	var coreDataFeedImages: [CoreDataFeedImage] {
		return feedImages.compactMap { $0 as? CoreDataFeedImage }
	}
}
