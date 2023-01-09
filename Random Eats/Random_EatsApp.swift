//
//  Random_EatsApp.swift
//  Random Eats
//
//  Created by Trevor Berggren on 8/2/22.
//

import SwiftUI
import CloudKit

@main
struct Random_EatsApp: App {
    
    let container = CKContainer(identifier: "iCloud.ICLOUD.RANDOM-EATS")
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
