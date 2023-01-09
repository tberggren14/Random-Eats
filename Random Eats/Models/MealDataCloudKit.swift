//
//  MealDataCloudKit.swift
//  Random Eats
//
//  Created by Trevor Berggren on 10/18/22.
//

import Foundation
import CloudKit

class MealDataCloudKit: ObservableObject{
    
    private var database: CKDatabase
    private var container: CKContainer
    
    @Published var likes: [SavedLikesViewModel] = []
    
    init(container: CKContainer) {
        self.container = container
        self.database = self.container.privateCloudDatabase
    }
    
    func deleteItem(_ recordId: CKRecord.ID) {
        database.delete(withRecordID: recordId) { deletedRecordId,error in
            if let error = error {
                print(error)
            } else {
                self.populateList()
            }
        }
    }
    
    func saveItem(name: String, address: String, imageURL: String) {
        let record = CKRecord(recordType: "SavedLike")
        var savedLikes = Likes(name: name, address: address, imageURL: imageURL)
        
        record.setValuesForKeys(["Name": name, "Address": address, "ImageURL": imageURL])
        
        self.database.save(record) { newRecord, error in
            if let error = error {
                print(error)
            } else {
                if let newRecord = newRecord {
                    if let savedLikes = Likes.fromRecord(newRecord){
                        DispatchQueue.main.async {
                            self.likes.append(SavedLikesViewModel(savedLikes: savedLikes))
                        }
                        
                    }
                }
            }
        }
        
    }
    
    func populateList() {
        
        var likes: [Likes] = []
        let query = CKQuery(recordType:"SavedLike", predicate: NSPredicate(value: true))
        
        database.fetch(withQuery: query) { result in
            switch result {
            case .success(let result):
                print(result.matchResults)
                result.matchResults.compactMap { $0.1}
                    .forEach{
                        switch $0 {
                        case .success(let record):
                            if let savedLikes = Likes.fromRecord(record){
                                likes.append(savedLikes)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                DispatchQueue.main.async {
                    self.likes = likes.map(SavedLikesViewModel.init)
                }
                
            case .failure(let error ):
                print(error)
            }
            
        }
    }
    
    struct SavedLikesViewModel {
        var savedLikes: Likes
        
        var recordId: CKRecord.ID?{
            savedLikes.recordId
        }
        var name: String?{
            savedLikes.name
        }
        var address: String?{
            savedLikes.address
        }
        var imageURL: String?{
            savedLikes.imageURL
        }
    }
    
}
