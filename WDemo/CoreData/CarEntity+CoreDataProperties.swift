//
//  CarEntity+CoreDataProperties.swift
//  
//
//  Created by wyj on 2018/9/18.
//
//

import Foundation
import CoreData


extension CarEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CarEntity> {
        return NSFetchRequest<CarEntity>(entityName: "CarEntity")
    }

    @NSManaged public var address: String?
    @NSManaged public var engineType: String?
    @NSManaged public var exterior: String?
    @NSManaged public var fuel: Int16
    @NSManaged public var interior: String?
    @NSManaged public var name: String?
    @NSManaged public var vin: String?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double

}
