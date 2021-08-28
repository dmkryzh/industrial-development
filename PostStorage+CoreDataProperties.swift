//
//  PostStorage+CoreDataProperties.swift
//  Navigation
//
//  Created by Dmitrii KRY on 29.05.2021.
//

import Foundation
import CoreData
import UIKit


extension PostStorage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostStorage> {
        return NSFetchRequest<PostStorage>(entityName: "PostStorage")
    }

    @NSManaged public var likes: String
    @NSManaged public var author: String
    @NSManaged public var views: String
    @NSManaged public var title: String
    @NSManaged public var image: String
    @NSManaged public var postDescription: String

}

extension PostStorage : Identifiable {

}
