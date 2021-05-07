//
//  CoreDataFeedImage+CoreDataProperties.swift
//  FeedStoreChallenge
//
//  Created by Alex Thurston on 5/7/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CoreDataFeedImage)
public class CoreDataFeedImage: NSManagedObject, Identifiable {}

extension CoreDataFeedImage {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataFeedImage> {
		return NSFetchRequest<CoreDataFeedImage>(entityName: "CoreDataFeedImage")
	}

	@NSManaged public var id: UUID
	@NSManaged public var imageDescription: String?
	@NSManaged public var location: String?
	@NSManaged public var url: URL

	@NSManaged public var feed: CoreDataFeed
}
