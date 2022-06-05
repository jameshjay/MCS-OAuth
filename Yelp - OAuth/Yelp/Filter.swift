//
//  Filter.swift
//  Yelp
//
//  Created by Zhaolong Zhong on 10/20/16.
//  
//

import Foundation

class Filter {
    var label: String
    var name: String
    var options: [Option]
    var type: FilterType
    var visibleItems: Int?
    var isOpen: Bool
    
    init(label: String, name: String, options: [Option], type: FilterType, visibleItems: Int? = 0) {
        self.label = label
        self.name = name
        self.options = options
        self.type = type
        self.visibleItems = visibleItems
        self.isOpen = false
    }
    
    var selectedIndex: Int {
        get {
            for i in 0..<self.options.count {
                if self.options[i].isSelected {
                    return i
                }
            }
            
            return -1
        }
        set {
            if self.type == .single {
                self.options[self.selectedIndex].isSelected = false
            }
            
            self.options[newValue].isSelected = true
        }
    }
    
    var selectedOptions: [Option] {
        get {
            var options = [Option]()
            for option in self.options {
                if option.isSelected {
                    options.append(option)
                }
            }
            
            return options
        }
    }
    
}
