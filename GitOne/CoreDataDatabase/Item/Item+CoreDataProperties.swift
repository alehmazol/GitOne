 //
//  Item+CoreDataProperties.swift
//  GitOne
//
//  Created by Aleh Mazol on 29/03/2025.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var projectName: String?
    @NSManaged public var projectLanguage: String?
    @NSManaged public var stars: Int32
    @NSManaged public var forks: Int32
    @NSManaged public var projectID: Int32
    @NSManaged public var id: UUID?

}

extension Item : Identifiable {

}
