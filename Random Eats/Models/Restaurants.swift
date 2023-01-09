//
//  Restaurants.swift
//  Random Eats
//
//  Created by Trevor Berggren on 8/19/22.
//

import Foundation
import MapKit

struct Restaurants{
    
    let placemark: MKPlacemark
    
    var id: UUID{
        return  UUID()
    }
    
    var name: String{
        self.placemark.name ?? ""
    }
    
    var title: String{
        self.placemark.title ?? ""
    }
    
    var coordinate: CLLocationCoordinate2D{
        self.placemark.coordinate
    }
    
}
