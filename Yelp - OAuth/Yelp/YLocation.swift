//
//  Location.swift
//  Yelp
//
//  Created by Zhaolong Zhong on 10/22/16.
//  
//

import Foundation
import CoreLocation

class YLocation: NSObject {
    static let latitudeKey = "latitudeKey"
    static let longitudeKey = "longitudeKey"
    
    var address: String?
    var city: String?
    var coordinate: CLLocationCoordinate2D?
    var crossStreets: String?
    var displayAddress: String?
    var neighborhoods: String?
    var stateCode: String?
    var postalCode: String?
    
    init(dictionary: NSDictionary) {
        if let addressArray = dictionary["address"] as? NSArray {
            self.address = addressArray[0] as? String
        }
        
        if let city = dictionary["city"] as? String {
            self.city = city
        }
        
        if let coordinate = dictionary["coordinate"] as? [String: AnyObject] {
            self.coordinate = CLLocationCoordinate2D(latitude: coordinate["latitude"] as! Double, longitude: coordinate["longitude"] as! Double)
        }
        
        if let crossStreets = dictionary["cross_streets"] as? String {
            self.crossStreets = crossStreets
        }
        
        if let displayAddress = dictionary["display_address"] as? String {
            self.displayAddress = displayAddress
        }
        
        if let neighborhoods = dictionary["neighborhoods"] as? NSArray {
            var address = ""
            if neighborhoods.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods[0] as! String
            }
            
            self.address = address
        }
        
        if let stateCode = dictionary["state_code"] as? String {
            self.stateCode = stateCode
        }
        
        if let postalCode = dictionary["postal_code"] as? String {
            self.postalCode = postalCode
        }
    }
    
    static func getDefaultLocation() -> CLLocation {
        var defaultLocation: CLLocation!
        
        let defaults = UserDefaults.standard
        if let latitude = defaults.object(forKey: self.latitudeKey) as? Double, let longitude = defaults.object(forKey: self.longitudeKey) as? Double {
            defaultLocation = CLLocation(latitude: latitude, longitude: longitude)
        } else {
            // Default the location to San Francisco
            defaultLocation = CLLocation(latitude: 37.785771, longitude: -122.406165)
        }
        
        return defaultLocation
    }
}
