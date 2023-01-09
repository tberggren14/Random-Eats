//
//  ContentView.swift
//  Random Eats
//
//  Created by Trevor Berggren on 8/2/22.
//

import SwiftUI
import MapKit
import SwiftfulLoadingIndicators
import CloudKit

struct ContentView: View {
    let container = CKContainer(identifier: "iCloud.ICLOUD.RANDOM-EATS")
    @State var category: String = "Restaurant"
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.red,.white,.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            
            TabView{
                MainView(mealCloudKit: MealDataCloudKit(container: container))
                    .tabItem(){
                        Image(systemName: "house")
                        Text("Home")
                    }
                RandomFastFoodView(mealCloudKit: MealDataCloudKit(container: container))
                    .tabItem(){
                        Image(systemName:"takeoutbag.and.cup.and.straw.fill")
                        Text("Fast Food")
                    }
                
                RandomRestaurantView(mealCloudKit: MealDataCloudKit(container: container),category: $category)
                    .tabItem(){
                        Image(systemName:"fork.knife")
                        Text("Restaurant")
                    }
                LikesView(mealCloudKit: MealDataCloudKit(container: container))
                    .tabItem(){
                        Image(systemName: "heart.fill")
                        Text("Likes")
                    }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
