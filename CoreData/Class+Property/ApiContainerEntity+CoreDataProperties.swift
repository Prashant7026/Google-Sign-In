//
//  ApiContainerEntity+CoreDataProperties.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 19/05/25.
//
//

import Foundation
import CoreData


extension ApiContainerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ApiContainerEntity> {
        return NSFetchRequest<ApiContainerEntity>(entityName: "ApiContainerEntity")
    }

    @NSManaged public var apiEntities: NSOrderedSet?

}

// MARK: Generated accessors for apiEntities
extension ApiContainerEntity {

    @objc(addApiEntitiesObject:)
    @NSManaged public func addToApiEntities(_ value: ApiEntity)

    @objc(removeApiEntitiesObject:)
    @NSManaged public func removeFromApiEntities(_ value: ApiEntity)

    @objc(addApiEntities:)
    @NSManaged public func addToApiEntities(_ values: NSSet)

    @objc(removeApiEntities:)
    @NSManaged public func removeFromApiEntities(_ values: NSSet)

}

extension ApiContainerEntity : Identifiable {

}
