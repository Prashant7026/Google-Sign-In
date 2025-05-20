//
//  DataClassEntity+CoreDataProperties.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 19/05/25.
//
//

import Foundation
import CoreData


extension DataClassEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataClassEntity> {
        return NSFetchRequest<DataClassEntity>(entityName: "DataClassEntity")
    }

    @NSManaged public var capacity: String?
    @NSManaged public var capacityGB: Int16
    @NSManaged public var caseSize: String?
    @NSManaged public var color: String?
    @NSManaged public var cpuModel: String?
    @NSManaged public var dataCapacity: String?
    @NSManaged public var dataColor: String?
    @NSManaged public var dataGeneration: String?
    @NSManaged public var dataPrice: Double
    @NSManaged public var desc: String?
    @NSManaged public var generation: String?
    @NSManaged public var hardDiskSize: String?
    @NSManaged public var price: String?
    @NSManaged public var screenSize: Double
    @NSManaged public var strapColour: String?
    @NSManaged public var year: Int16
    @NSManaged public var apiEntity: ApiEntity?

}

extension DataClassEntity : Identifiable {

}
