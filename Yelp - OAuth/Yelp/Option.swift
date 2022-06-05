//
//  Option.swift
//  Yelp
//
//  Filter Option
//
//  Created by Zhaolong Zhong on 10/20/16.
//  
//

import Foundation

class Option {
    var label: String?
    var name: String?
    var value: String?
    var isSelected: Bool
    
    init(label: String?, name: String? = nil, value: String? = nil, isSelected: Bool = false) {
        self.label = label
        self.name = name
        self.value = value
        self.isSelected = isSelected
    }
    
}
