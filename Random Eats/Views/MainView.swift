//
//  MainView.swift
//  Random Eats
//
//  Created by Trevor Berggren on 1/2/23.
//

import SwiftUI
import MapKit
import CloudKit

struct GrowingBlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct GrowingRedButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct MainView: View {
    let container = CKContainer(identifier: "iCloud.ICLOUD.RANDOM-EATS")
    @ObservedObject var locationManager = LocationManager()
    @State var restaurants: [Restaurants] = [Restaurants]()
    @State  var randomRest: String = ""
    @State  var address: String = ""
    @State var id: String = ""
    @State var randomNum: Int = 0
    @State var restaurantRating: String = ""
    @State  var restaurantPrice: String = ""
    @State  var restaurantImage: String = ""
    @State  var mealImage: String = ""
    @State  var mealName: String = ""
    @State  var mealYoutube: String = ""
    @State  var text: String = "Let's try"
    @State  var mealText: String = "Let's make"
    @State var like: [Likes] = []
    @State  var likedName: String = ""
    @State  var likedAdress: String = ""
    @State  var likedImageURL: String = ""
    @State  var likedYoutubeURL: String = ""
    @State var venues: [Venue] = []
    @State var meals: [Meal] = []
    @State var savedLikes: [Likes] = []
    @StateObject var mealCloudKit: MealDataCloudKit
    @State var category: String = "Restaurant"
    @State var showFastFoodView = false
    @State var showRestaurantView = false
    @State var showLikeView = false
    
    func findFastFoodPlaces() {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = ("fast food")
        request.region = locationManager.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response{
                let mapItems = response.mapItems
                self.restaurants = mapItems.map{
                    Restaurants(placemark: $0.placemark)
                }
            }
            let index = restaurants.count
            self.randomNum = Int.random(in: 0..<index)
            self.randomRest = restaurants[randomNum].name
            self.address = restaurants[randomNum].title
            let filteredName = randomRest.replacingOccurrences(of: " ", with: "+")
            let filteredAddress = address.replacingOccurrences(of: " ", with: "+")
            
            retrieveVenue(name: filteredName, address: filteredAddress) { (response, error) in
                if let response = response {
                    self.venues = response
                    
                }
                
                if venues.indices.contains(0){
                    let tempRating = venues[0].rating ?? 0.0
                    self.restaurantRating = String(format: "%.1f", tempRating)
                    self.restaurantPrice =  venues[0].price ??  ""
                    self.restaurantImage =  venues[0].image_url ?? ""
                    
                }
                else {
                    self.restaurantRating = "0"
                    self.restaurantPrice = "No data"
                    self.restaurantImage = "No data"
                }
                
            }
        }
        
    }
    
    func findRestaurant(category: String) {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = (category)
        request.region = locationManager.region
        
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response{
                let mapItems = response.mapItems
                self.restaurants = mapItems.map{
                    Restaurants(placemark: $0.placemark)
                }
                
            }
            let index = restaurants.count
            self.randomNum = Int.random(in: 0..<index)
            self.randomRest = restaurants[randomNum].name
            self.address = restaurants[randomNum].title
            let filteredName = randomRest.replacingOccurrences(of: " ", with: "+")
            let filteredAddress = address.replacingOccurrences(of: " ", with: "+")
            
            retrieveVenue(name: filteredName, address: filteredAddress) { (response, error) in
                if let response = response {
                    self.venues = response
                    
                }
                if venues.indices.contains(0){
                    let tempRating = venues[0].rating ?? 0.0
                    self.restaurantRating = String(format: "%.1f", tempRating)
                    self.restaurantPrice =  venues[0].price ??  ""
                    self.restaurantImage =  venues[0].image_url ?? ""
                    
                }
                else {
                    self.restaurantRating = "0"
                    self.restaurantPrice = "No data"
                    self.restaurantImage = "No data"
                }
                
            }
        }
        
        
    }
    
    
    func getDirections(address: String){
        let filteredURL = address.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: "http://maps.apple.com/?q=\(filteredURL)")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    var body: some View {
        let categories = ["Any","Burger", "Sandwich shops", "Steakhouse" ,"Seafood","Pizza","Mexican","Chinese ","BBQ","Japanese","Indian"]
        
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.red,.white,.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Random-Eats")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color.black)
                    .position(x:UIScreen.main.bounds.width/5,y: UIScreen.main.bounds.height/50)
            }
            
            VStack(spacing:30){
                
                VStack{
                    Button("Random fast food!") {
                        self.showFastFoodView = true
                    }
                    .buttonStyle(GrowingBlueButton())
                    .padding()
                }.position(x:UIScreen.main.bounds.width/2,y: UIScreen.main.bounds.height/3)
                
                VStack(spacing:50){
                    Text("Pick a category for a restaurant")
                        .font(.system(size: 25, weight: .medium))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                        
                    }
                    .pickerStyle(.menu)
                    .tint(.black)
                    .scaleEffect(1.5)
                    
                    Button("Random restaurant!") {
                        if category == "Any"{
                            category = "Restaurants"
                        }
                        self.showRestaurantView = true
                    }
                    .buttonStyle(GrowingRedButton())
                }.position(x:UIScreen.main.bounds.width/2,y: UIScreen.main.bounds.height/6)
           
    
                Text("View likes")
                    .font(.system(size: 25, weight: .medium))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                
                
                
                
                Button("View likes!") {
                    self.showLikeView = true
                    mealCloudKit.populateList()
                }
                .buttonStyle(GrowingRedButton())
                
                
            }.position(x:UIScreen.main.bounds.width/2,y: UIScreen.main.bounds.height/3)
            //.position(x:UIScreen.main.bounds.width/2)
        }.sheet(isPresented: $showFastFoodView) {
            RandomFastFoodView(mealCloudKit: MealDataCloudKit(container: container))
        }
        .sheet(isPresented: $showRestaurantView) {
            RandomRestaurantView(mealCloudKit: MealDataCloudKit(container: container),category: $category)
        }
        .sheet(isPresented: $showLikeView) {
            LikesView(mealCloudKit: MealDataCloudKit(container: container))
        }
        
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(mealCloudKit: MealDataCloudKit(container: CKContainer(identifier: "iCloud.ICLOUD.RANDOM-EATS")))
    }
}

