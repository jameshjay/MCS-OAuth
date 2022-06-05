//
//  YelpHelpers.swift
//  Yelp
//
//  Created by Zhaolong Zhong on 10/19/16.
//  
//

import Foundation

class YelpHelper {
    static func readFileFrom(_ path: String, ofType: String) -> Data? {
        if let path = Bundle.main.path(forResource: path, ofType: ofType) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
                return data
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }

}
