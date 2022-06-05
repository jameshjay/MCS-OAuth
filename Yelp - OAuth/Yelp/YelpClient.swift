//
//  YelpClient.swift
//  Yelp
//
//  
//  
//

import UIKit
import OAuthSwift

class YelpClient: OAuthSwiftClient {
    // Yelp Search API: https://www.yelp.com/developers/documentation/v2/search_api
    
    static let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
    static let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
    static let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
    static let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"
    static let searchBaseURL = "http://api.yelp.com/v2/search"
    
    static let sharedInstance: YelpClient = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, oauthToken: yelpToken, oauthTokenSecret: yelpTokenSecret, version: .oauth1)
    
    func searchWithTerm(_ term: String, location: String?, sort: YelpSortMode?, completion: @escaping ([Business]?, Error?) -> Void) {
        
        return searchWithTerm(term, sort: sort, categories: nil, deals: nil, completion: completion)
    }
    
    func searchWithTerm(_ term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, Error?) -> Void) {
        return searchWithTerm(term, sort: sort, categories: categories, deals: deals, offset: 0, completion: completion)
    }
    
    func searchWithTerm(_ term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, offset: Int?, completion: @escaping ([Business]?, Error?) -> Void) {
        
        let defaultLocation = YLocation.getDefaultLocation().coordinate
        var parameters: [String : AnyObject] = ["term": term as AnyObject, "ll": "\(defaultLocation.latitude),\(defaultLocation.longitude)" as AnyObject]
        
        if sort != nil {
            parameters["sort"] = sort!.rawValue as AnyObject?
        }
        
        if categories != nil && categories!.count > 0 {
            parameters["category_filter"] = (categories!).joined(separator: ",") as AnyObject?
        }
        
        if deals != nil {
            parameters["deals_filter"] = deals! as AnyObject?
        }
        
        if let offset = offset {
            parameters["offset"] = offset as AnyObject?
        }
        
        print(parameters)
        
        self.get(YelpClient.searchBaseURL, parameters: parameters, success: { (data, response) -> Void in
            guard let response = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                print("Response cannot be parsed as JSONObject.")
                return
            }
            
            let dictionaries = response["businesses"] as? [NSDictionary]
            print(dictionaries?.first)
            if dictionaries != nil {
                completion(Business.businesses(array: dictionaries!), nil)
            }
        }) { (error) -> Void in
            print("there was an error: \(error)")
        }
    }
    
    func searchWithTerm(_ term: String, filters: [Filter], offset: Int?, completion: @escaping ([Business]?, Error?) -> Void) {
        
        let defaultLocation = YLocation.getDefaultLocation().coordinate
        var parameters: [String : AnyObject] = ["term": term as AnyObject, "ll": "\(defaultLocation.latitude),\(defaultLocation.longitude)" as AnyObject]
        
        for filter in filters {
            switch filter.name {
            case "sort":
                parameters["sort"] = filter.selectedOptions.first!.value! as AnyObject
                break
            case "popular_filter":
                for option in filter.selectedOptions {
                    if (option.name?.contains("deal"))! {
                        parameters["deals_filter"] = 1 as AnyObject
                    }
                }
                break
            case "category_filter":
                let categories:[String] = filter.selectedOptions.map{ $0.value! }
                parameters["category_filter"] = categories.joined(separator: ",") as AnyObject?
                break
            default:
                break
            }
        }
        
        if let offset = offset {
            parameters["offset"] = offset as AnyObject?
        }
        
        print(parameters)
      
        
        
        self.get(YelpClient.searchBaseURL, parameters: parameters, success: { (data, response) -> Void in
            guard let response = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                print("Response cannot be parsed as JSONObject.")
                return
            }
            
            let dictionaries = response["businesses"] as? [NSDictionary]
            print(dictionaries?.first)
            if dictionaries != nil {
                completion(Business.businesses(array: dictionaries!), nil)
            }
        }) { (error) -> Void in
            print("there was an error: \(error)")
        }
    }
}
