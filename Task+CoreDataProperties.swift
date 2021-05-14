//
//  Task+CoreDataProperties.swift
//  HW14CoreData
//
//  Created by Sergii Kotyk on 5/5/21.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var isComplited: Bool

}

extension Task : Identifiable {

}
