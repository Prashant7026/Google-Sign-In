//
//  UserDetailEntity+CoreDataProperties.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 20/05/25.
//
//

import Foundation
import CoreData


extension UserDetailEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDetailEntity> {
        return NSFetchRequest<UserDetailEntity>(entityName: "UserDetailEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var email: String?

}

extension UserDetailEntity : Identifiable {

}
