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
final class CoreDataFeedImage: NSManagedObject {
	@NSManaged var id: UUID
	@NSManaged var imageDescription: String?
	@NSManaged var location: String?
	@NSManaged var url: URL

	@NSManaged var feed: CoreDataFeed
}

extension CoreDataFeedImage {
	static func images(feed: [LocalFeedImage], context: NSManagedObjectContext) -> NSOrderedSet {
		return NSOrderedSet(array: feed.map { localFeedImage in
			return CoreDataFeedImage.image(from: localFeedImage, context: context)
		})
	}

	private static func image(from localFeedImage: LocalFeedImage, context: NSManagedObjectContext) -> CoreDataFeedImage {
		let image = CoreDataFeedImage(context: context)
		image.id = localFeedImage.id
		image.url = localFeedImage.url
		image.location = localFeedImage.location
		image.imageDescription = localFeedImage.description
		return image
	}

	var localImage: LocalFeedImage {
		return LocalFeedImage(id: id, description: imageDescription, location: location, url: url)
	}
}
