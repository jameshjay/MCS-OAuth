//
//  Business.swift
//  Yelp
//
//
//
//

import UIKit
import OAuthSwift
import CoreLocation

class Business: NSObject {
    let name: String?
    let address: String?
    let imageURL: URL?
    let categories: String?
    let distance: String?
    let ratingImageURL: URL?
    let reviewCount: NSNumber?
    let snippet: String?
    var location: YLocation? = nil
    let deals: Array<AnyObject>?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        
        var address = ""
        if location != nil {
            self.location = YLocation(dictionary: location!)
            
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
        }
        self.address = address
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joined(separator: ", ")
        } else {
            categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = URL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
        snippet = dictionary["snippet_text"] as? String
        
//        if let location = dictionary["location"] as? NSDictionary {
//            if let coordinate = location["coordinate"] as? NSDictionary {
//                self.location = CLLocation(latitude: coordinate["latitude"] as! Double, longitude: coordinate["longitude"] as! Double)
//            } else {
//                self.location = nil
//            }
//        } else {
//            self.location = nil
//        }
        
        if let deals = dictionary["deals"] as? Array<AnyObject> {
            self.deals = deals
        } else {
            self.deals = nil
        }
    }
    
    static func businesses(array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        
        return businesses
    }
    
    static func searchWithTerm(term: String, location: String?, sort: YelpSortMode?, completion: @escaping ([Business]?, Error?) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(term, location: location, sort: nil, completion: completion)
    }

    static func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, Error?) -> Void) -> Void {
        _ = YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, completion: completion)
    }
    
    static func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, offset: Int?, completion: @escaping ([Business]?, Error?) -> Void) -> Void {
        _ = YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, offset: offset, completion: completion)
    }
    
    static func searchWithTerm(term: String, filters: [Filter], offset: Int?, completion: @escaping ([Business]?, Error?) -> Void) -> Void {
        _ = YelpClient.sharedInstance.searchWithTerm(term, filters: filters, offset: offset, completion: completion)
    }
}
