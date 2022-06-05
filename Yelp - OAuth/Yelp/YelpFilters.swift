//
//  YelpFilters.swift
//  Yelp
//
//  Created by Zhaolong Zhong on 10/20/16.
//  
//

import Foundation

class YelpFilters {
    static let sharedInstance: YelpFilters = YelpFilters()
    
    var filters = [
        Filter(
            label: "",
            name:"order",
            options:[
                Option(label: "Order Pickup or Deliver", name: "", value: "")
            ],
            type: .option
        ),
        Filter(
            label: "Most Popular",
            name: "popular_filter",
            options:[
                Option(label: "Offering a Deal", name: "deals_filter", value: "1"),
                Option(label: "Hot and New", name: "", value: "2"),
                Option(label: "Open Now", name: "is_closed", value: "3")
            ],
            type: .option,
            visibleItems: 3
        ),
        Filter(
            label: "Distance",
            name: "distance_filter",
            options: [
                Option(label: "Best Match", value: "", isSelected: true),
                Option(label: "0.3 miles", value: "600"),
                Option(label: "1 mile", value: "1609"),
                Option(label: "5 miles", value: "8000"),
                Option(label: "20 miles", value: "32000")
            ],
            type: .single
        ),
        Filter(
            label: "Sort by",
            name: "sort",
            options: [
                Option(label: "Best Match", value: "0", isSelected: true),
                Option(label: "Distance", value: "1"),
                Option(label: "Rating", value: "2"),
                Option(label: "Most Reviewed", value: "3")
            ],
            type: .single
        ),
        Filter(
            label: "General Features",
            name: "general_features_filter",
            options: [
                Option(label: "Take-out"),
                Option(label: "Good for Kids"),
                Option(label: "Takes Reservations"),
                Option(label: "Accepts Cedit Cards"),
                Option(label: "Outdoor Seating"),
                Option(label: "Good for Group"),
                Option(label: "Wheelchair Accessible"),
                Option(label: "PokeStop Nearby"),
                Option(label: "Full Bar"),
                Option(label: "Happy Hour"),
                Option(label: "Good for Breakfast"),
                Option(label: "Good for Brunch"),
                Option(label: "Good for Lunch"),
                Option(label: "Good for Dessert"),
                Option(label: "Good for Late Night"),
                Option(label: "Free Wi-Fi")
            ],
            type: .multiple,
            visibleItems: 3
        )
    ]
}
