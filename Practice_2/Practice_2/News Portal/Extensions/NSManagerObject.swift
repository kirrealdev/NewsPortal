//
//  NSManagerObject.swift
//  Practice_2
//
//  Created by KirRealDev on 21.09.2021.
//

import Foundation
import CoreData

extension NSManagedObject {
    static func entity(in context: NSManagedObjectContext) -> NSEntityDescription? {
        NSEntityDescription.entity(forEntityName: String(describing: Self.self), in: context)
    }
}
