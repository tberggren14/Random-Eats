//
//  MealData.swift
//  Random Eats
//
//  Created by Trevor Berggren on 8/29/22.
//

import Foundation
import CloudKit

struct Meal {
    var name: String?
    var mealImageURL: String?
}

struct Likes: Identifiable{
    var id: UUID = UUID()
    var recordId: CKRecord.ID?
    let name: String?
    let address: String?
    let imageURL: String?
    
    static func fromRecord(_ record: CKRecord) -> Likes? {
        guard let name = record.value(forKey: "Name") as? String,
              let address = record.value(forKey: "Address") as? String,
              let imageURL = record.value(forKey: "ImageURL") as? String
                
        else {
            return nil
        }
        
        return Likes(recordId: record.recordID, name: name, address: address, imageURL: imageURL )
    }
    
}








