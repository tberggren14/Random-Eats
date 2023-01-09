//
//  RandomFastFoodView.swift
//  Random Eats
//
//  Created by Trevor Berggren on 1/2/23.
//

import SwiftUI
import SwiftfulLoadingIndicators
import MapKit
import CloudKit


struct RandomFastFoodView: View {
    
    @ObservedObject var locationManager = LocationManager()
    @State private var restaurants: [Restaurants] = [Restaurants]()
    @State private var randomRest: String = ""
    @State private var address: String = ""
    @State private var id: String = ""
    @State private var randomNum: Int = 0
    @State private var restaurantRating: String = ""
    @State private var restaurantPrice: String = ""
    @State private var restaurantImage: String = ""
    @State private var mealImage: String = ""
    @State private var mealName: String = ""
    @State private var text: String = "Let's try"
    @State private var mealText: String = "Let's make"
    @State var like: [Likes] = []
    @State private var likedName: String = ""
    @State private var likedAdress: String = ""
    @State private var likedImageURL: String = ""
    @State var venues: [Venue] = []
    @State var meals: [Meal] = []
    @State var savedLikes: [Likes] = []
    @StateObject var mealCloudKit: MealDataCloudKit
    @State  var category: String = ""
    
    func findFastFoodPlaces() {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = ("Fast Food")
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
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.red,.white,.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Random-Eats")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color.black)
                    .position(x:UIScreen.main.bounds.width/5,y: UIScreen.main.bounds.height/50)
            }
            
            VStack{
                
                AsyncImage(url: URL(string: "\(restaurantImage)")) { phase in
                    if let image = phase.image {
                        image // Displays the loaded image.
                            .resizable()
                            .frame(width: 250, height: 250)
                        
                    }
                    else if phase.error != nil {
                        LoadingIndicator(animation: .threeBalls, color: .black, size: .large, speed: .normal) // Indicates an error.
                    } else {
                        
                        LoadingIndicator(animation: .circleTrim, color: .black, size: .large, speed: .normal) // Acts as a placeholder.
                        
                    }
                }
                if let rest = randomRest {
                    Text(rest)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                else {
                    Text("No data available")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                }
                
                if let rating = restaurantRating {
                    Text("Rating: " + rating + "/5")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                else {
                    Text("No data available")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                }
                
                if let price = restaurantPrice {
                    Text("Price: " + price)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                else {
                    Text("No data available")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                }
                
                if let address = address{
                    Text(address)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                else {
                    Text("No data available")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                }
                
                Button("Directions"){
                    getDirections(address:address)
                    
                }
                .buttonStyle(GrowingBlueButton())
                .padding()
                
                HStack(spacing:75){
                    
                    Button{
                        self.findFastFoodPlaces()
                        
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 50))
                    }
                    .padding(.bottom)
                    
                    Button{
                        let sms: String = "sms:&body=\(text) \(randomRest), \(address)"
                        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
                        
                        
                    } label: {
                        Image(systemName: "message.fill")
                            .font(.system(size: 50))
                    }
                    .padding(.bottom)
                    
                }
                HStack(spacing:75){
                    Button{
                        self.likedName = randomRest
                        self.likedAdress = address
                        self.likedImageURL = restaurantImage
                        
                        let saved: [Likes] = [Likes(name: likedName, address: likedAdress, imageURL: likedImageURL)]
                        
                        like.append(contentsOf: saved)
                        
                        mealCloudKit.saveItem(name: likedName, address: likedAdress, imageURL: likedImageURL)
                        
                        self.likedName = ""
                        self.likedAdress = ""
                        self.likedImageURL = ""
                        
                        
                        
                    } label: {
                        Image(systemName: "hand.thumbsup.circle")
                            .font(.system(size: 70))
                    }
                }
                
                HStack{
                    Spacer()
                    Image("yelp_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .position(x:325)
                    
                    
                }
            }
            .position(x:UIScreen.main.bounds.width/2,y: UIScreen.main.bounds.height/2)
            
            
        }.onAppear(){
            self.findFastFoodPlaces()
        }
        
    }
    
    
}

struct RandomFastFoodView_Previews: PreviewProvider {
    static var previews: some View {
        RandomFastFoodView(mealCloudKit: MealDataCloudKit(container: CKContainer(identifier: "iCloud.ICLOUD.RANDOM-EATS")))
    }
}
