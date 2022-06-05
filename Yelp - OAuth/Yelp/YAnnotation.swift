//
//  YAnnotation.swift
//  Yelp
//
//  Created by Zhaolong Zhong on 10/22/16.
//  
//

import UIKit
import MapKit

class YAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var business: Business?
    var index: Int
    
    init(business: Business, index: Int) {
        self.business = business
        let location = self.business!.location
        self.coordinate = CLLocationCoordinate2DMake(location!.coordinate!.latitude, location!.coordinate!.longitude)
        self.title = business.name
        self.index = index
    }

}
