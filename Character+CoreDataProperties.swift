//
//  Character+CoreDataProperties.swift
//  lab4
//
//  Created by Яна Павлова on 08.07.2023.
//
//

import Foundation
import CoreData


extension Model {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Model> {
        return NSFetchRequest<Model>(entityName: "Model")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String
    @NSManaged public var status: String
    @NSManaged public var species: String
    @NSManaged public var gender: String
    @NSManaged public var location: String
    @NSManaged public var image: String

}

extension Model : Identifiable {

}
