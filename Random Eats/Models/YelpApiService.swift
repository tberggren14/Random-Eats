//
//  YelpApiService.swift
//  Random Eats
//
//  Created by Trevor Berggren on 8/22/22.
//

import Foundation
import CoreLocation
import Combine
import UIKit

let apiKey = "qOT3o0nW3jTmfdHSa4A2ahGHgVH8k0dHdickXWU_9O2gA1hjTeKh3m23Uh1Z0M1tmY4WjfEWNkW6U_gPFWHJmar04hIaGGrvoiMSjlLLXt7d80JoBCbYqaHg0qYDY3Yx"

extension MainView{
    
    func retrieveVenue(
        name: String,
        address: String,
        completionHandler: @escaping ([Venue]?, Error?) -> Void) {
            
            var baseURL = "https://api.yelp.com/v3/businesses/search?term=\(name)&location=\(address)"
            guard let url = URL(string: baseURL) else { return }
            var request = URLRequest(url: url)
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { (data,response,error) in
                if let error = error {
                    completionHandler(nil, error)
                }
                
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options:[])
                    
                    guard let resp = json as? NSDictionary else { return }
                    guard let businesses = resp.value(forKey: "businesses") as? [NSDictionary] else {return}
                    
                    var venueList: [Venue] = []
                    
                    for business in businesses {
                        var venue = Venue()
                        venue.name = business.value(forKey: "name") as? String
                        venue.yelpID = business.value(forKey: "id") as? String
                        venue.rating = business.value(forKey: "rating") as? Double
                        venue.price = business.value(forKey: "price") as? String
                        venue.image_url = business.value(forKey: "image_url") as? String
                        
                        if venue.rating == nil {
                            venue.rating = 0.0
                            
                        }
                        
                        venueList.append(venue)
                        
                    }
                    
                    completionHandler(venueList,nil)
                } catch{
                    print("caught error")
                }
            }.resume()
            
            
        }
    /*
     func fetchRandomMeal(
     completionHandler: @escaping ([Meal]?, Error?) -> Void ){
     
     let baseURL = "https://www.themealdb.com/api/json/v1/1/random.php"
     guard let url = URL(string: baseURL) else { return }
     var request = URLRequest(url: url)
     request.setValue("", forHTTPHeaderField: "Authorization")
     request.httpMethod = "GET"
     
     URLSession.shared.dataTask(with: request) { (data,response,error) in
     if let error = error {
     completionHandler(nil, error)
     }
     
     do{
     
     let json = try JSONSerialization.jsonObject(with: data!, options:[])
     
     guard let resp = json as? NSDictionary else { return }
     guard let meals = resp.value(forKey: "meals") as? [NSDictionary] else {return}
     
     var mealList: [Meal] = []
     
     for meal in meals {
     var mealData = Meal()
     mealData.name = meal.value(forKey: "strMeal") as? String
     mealData.mealImageURL = meal.value(forKey: "strMealThumb") as? String
     
     mealList.append(mealData)
     
     }
     
     completionHandler(mealList,nil)
     } catch{
     print("caught error")
     }
     }.resume()
     
     
     } */
    
}

extension RandomFastFoodView{
    
    func retrieveVenue(
        name: String,
        address: String,
        completionHandler: @escaping ([Venue]?, Error?) -> Void) {
            
            var baseURL = "https://api.yelp.com/v3/businesses/search?term=\(name)&location=\(address)"
            guard let url = URL(string: baseURL) else { return }
            var request = URLRequest(url: url)
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { (data,response,error) in
                if let error = error {
                    completionHandler(nil, error)
                }
                
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options:[])
                    
                    guard let resp = json as? NSDictionary else { return }
                    guard let businesses = resp.value(forKey: "businesses") as? [NSDictionary] else {return}
                    
                    var venueList: [Venue] = []
                    
                    for business in businesses {
                        var venue = Venue()
                        venue.name = business.value(forKey: "name") as? String
                        venue.yelpID = business.value(forKey: "id") as? String
                        venue.rating = business.value(forKey: "rating") as? Double
                        venue.price = business.value(forKey: "price") as? String
                        venue.image_url = business.value(forKey: "image_url") as? String
                        
                        if venue.rating == nil {
                            venue.rating = 0.0
                            
                        }
                        
                        venueList.append(venue)
                        
                    }
                    
                    completionHandler(venueList,nil)
                } catch{
                    print("caught error")
                }
            }.resume()
            
            
        }
    /*
     func fetchRandomMeal(
     completionHandler: @escaping ([Meal]?, Error?) -> Void ){
     
     let baseURL = "https://www.themealdb.com/api/json/v1/1/random.php"
     guard let url = URL(string: baseURL) else { return }
     var request = URLRequest(url: url)
     request.setValue("", forHTTPHeaderField: "Authorization")
     request.httpMethod = "GET"
     
     URLSession.shared.dataTask(with: request) { (data,response,error) in
     if let error = error {
     completionHandler(nil, error)
     }
     
     do{
     
     let json = try JSONSerialization.jsonObject(with: data!, options:[])
     
     guard let resp = json as? NSDictionary else { return }
     guard let meals = resp.value(forKey: "meals") as? [NSDictionary] else {return}
     
     var mealList: [Meal] = []
     
     for meal in meals {
     var mealData = Meal()
     mealData.name = meal.value(forKey: "strMeal") as? String
     mealData.mealImageURL = meal.value(forKey: "strMealThumb") as? String
     
     mealList.append(mealData)
     
     }
     
     completionHandler(mealList,nil)
     } catch{
     print("caught error")
     }
     }.resume()
     
     
     } */
    
}

extension RandomRestaurantView{
    
    func retrieveVenue(
        name: String,
        address: String,
        completionHandler: @escaping ([Venue]?, Error?) -> Void) {
            
            var baseURL = "https://api.yelp.com/v3/businesses/search?term=\(name)&location=\(address)"
            guard let url = URL(string: baseURL) else { return }
            var request = URLRequest(url: url)
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { (data,response,error) in
                if let error = error {
                    completionHandler(nil, error)
                }
                
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options:[])
                    
                    guard let resp = json as? NSDictionary else { return }
                    guard let businesses = resp.value(forKey: "businesses") as? [NSDictionary] else {return}
                    
                    var venueList: [Venue] = []
                    
                    for business in businesses {
                        var venue = Venue()
                        venue.name = business.value(forKey: "name") as? String
                        venue.yelpID = business.value(forKey: "id") as? String
                        venue.rating = business.value(forKey: "rating") as? Double
                        venue.price = business.value(forKey: "price") as? String
                        venue.image_url = business.value(forKey: "image_url") as? String
                        
                        if venue.rating == nil {
                            venue.rating = 0.0
                            
                        }
                        
                        venueList.append(venue)
                        
                    }
                    
                    completionHandler(venueList,nil)
                } catch{
                    print("caught error")
                }
            }.resume()
            
            
        }
    /*
     func fetchRandomMeal(
     completionHandler: @escaping ([Meal]?, Error?) -> Void ){
     
     let baseURL = "https://www.themealdb.com/api/json/v1/1/random.php"
     guard let url = URL(string: baseURL) else { return }
     var request = URLRequest(url: url)
     request.setValue("", forHTTPHeaderField: "Authorization")
     request.httpMethod = "GET"
     
     URLSession.shared.dataTask(with: request) { (data,response,error) in
     if let error = error {
     completionHandler(nil, error)
     }
     
     do{
     
     let json = try JSONSerialization.jsonObject(with: data!, options:[])
     
     guard let resp = json as? NSDictionary else { return }
     guard let meals = resp.value(forKey: "meals") as? [NSDictionary] else {return}
     
     var mealList: [Meal] = []
     
     for meal in meals {
     var mealData = Meal()
     mealData.name = meal.value(forKey: "strMeal") as? String
     mealData.mealImageURL = meal.value(forKey: "strMealThumb") as? String
     
     mealList.append(mealData)
     
     }
     
     completionHandler(mealList,nil)
     } catch{
     print("caught error")
     }
     }.resume()
     
     
     } */
    
}
