//
//  ApiEntity+CoreDataProperties.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 19/05/25.
//
//

import Foundation
import CoreData


extension ApiEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ApiEntity> {
        return NSFetchRequest<ApiEntity>(entityName: "ApiEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var data: DataClassEntity?
    @NSManaged public var container: NSSet?

}

// MARK: Generated accessors for container
extension ApiEntity {

    @objc(addContainerObject:)
    @NSManaged public func addToContainer(_ value: ApiContainerEntity)

    @objc(removeContainerObject:)
    @NSManaged public func removeFromContainer(_ value: ApiContainerEntity)

    @objc(addContainer:)
    @NSManaged public func addToContainer(_ values: NSSet)

    @objc(removeContainer:)
    @NSManaged public func removeFromContainer(_ values: NSSet)

}

extension ApiEntity : Identifiable {

}
