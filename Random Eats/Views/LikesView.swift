//
//  LikesView.swift
//  Random Eats
//
//  Created by Trevor Berggren on 1/2/23.
//

import SwiftUI
import MapKit
import SwiftfulLoadingIndicators
import CloudKit



struct LikesView: View {
    
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
    @State private var mealYoutube: String = ""
    @State private var text: String = "Let's try"
    @State private var mealText: String = "Let's make"
    @State var like: [Likes] = []
    @State private var likedName: String = ""
    @State private var likedAdress: String = ""
    @State private var likedImageURL: String = ""
    @State private var likedYoutubeURL: String = ""
    @State var venues: [Venue] = []
    @State var meals: [Meal] = []
    @State var savedLikes: [Likes] = []
    @StateObject  var mealCloudKit: MealDataCloudKit
    let container = CKContainer(identifier: "iCloud.ICLOUD.RANDOM-EATS")
    
    init(mealCloudKit: MealDataCloudKit){
        _mealCloudKit = StateObject(wrappedValue: mealCloudKit)
    }
    
    func deleteItem(_ indexSet: IndexSet){
        indexSet.forEach { index in
            let item = mealCloudKit.likes[index]
            if let recordId = item.recordId {
                mealCloudKit.deleteItem(recordId)
                
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
            VStack{
                
                List {
                    ForEach(mealCloudKit.likes,id: \.recordId){ item in
                        VStack{
                            HStack {
                                
                                if let restaurantImage = item.imageURL{
                                    AsyncImage(url: URL(string: "\(restaurantImage)")) { phase in
                                        if let image = phase.image {
                                            image // Displays the loaded image.
                                                .resizable()
                                                .frame(width: 100, height: 100)
                                            
                                        }
                                        else if phase.error != nil {
                                            LoadingIndicator(animation: .threeBalls, color: .black, size: .medium, speed: .normal) // Indicates an error.
                                        } else {
                                            
                                            LoadingIndicator(animation: .circleTrim, color: .black, size: .medium, speed: .normal) // Acts as a placeholder.
                                            
                                        }
                                    }
                                }
                                
                                if let name = item.name {
                                    Text(name)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color.black)
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                                } else {
                                    Text("No data")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color.black)
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                if let address = item.address {
                                    Text(address)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color.black)
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                                } else {
                                    Text("No data")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color.black)
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                if item.address == "" {
                                    Spacer()
                                }
                                
                            }
                            
                            VStack{
                                
                                HStack{
                                    if item.address != "" {
                                        
                                        Button("Directions"){
                                            if let address = item.address{
                                                getDirections(address:address)
                                                
                                            }
                                            
                                        }
                                        .buttonStyle(GrowingBlueButton())
                                    }
                                    
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteItem)
                }
            }
        }.onAppear(){
            mealCloudKit.populateList()
        }
    }
}


struct LikesView_Previews: PreviewProvider {
    static var previews: some View {
        LikesView(mealCloudKit: MealDataCloudKit(container: CKContainer(identifier: "iCloud.ICLOUD.RANDOM-EATS")))
    }
}
