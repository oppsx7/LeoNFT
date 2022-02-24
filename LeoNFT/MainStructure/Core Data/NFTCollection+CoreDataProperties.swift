//
//  NFTCollection+CoreDataProperties.swift
//  LeoNFT
//
//  Created by Edis Hasanov on 24/02/2022.
//
//

import Foundation
import CoreData


extension NFTCollection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NFTCollection> {
        return NSFetchRequest<NFTCollection>(entityName: "NFTCollection")
    }

    @NSManaged public var slug: String?

}

extension NFTCollection : Identifiable {

}
