//
//  RestaurantsAnnotation.swift
//  Random Eats
//
//  Created by Trevor Berggren on 8/19/22.
//

import Foundation
import MapKit
import UIKit

final class RestaurantsAnnotation: NSObject, MKAnnotation{
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(restaurants: Restaurants){
        self.title = restaurants.name
        self.coordinate = restaurants.coordinate
    }
}
