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
public class CoreDataFeed: NSManagedObject, Identifiable {}

extension CoreDataFeed {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataFeed> {
		return NSFetchRequest<CoreDataFeed>(entityName: "CoreDataFeed")
	}

	@NSManaged public var timestamp: Date
	@NSManaged public var feedImages: NSOrderedSet
}

extension CoreDataFeed {
	var coreDataFeedImages: [CoreDataFeedImage] {
		return feedImages.compactMap { $0 as? CoreDataFeedImage }
	}
}
