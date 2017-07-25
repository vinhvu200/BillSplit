//
//  Person.swift
//  BillSplit
//
//  Created by Vinh Vu on 7/14/17.
//  Copyright © 2017 Vinh Vu. All rights reserved.
//

import Foundation

class Person {
    
    var name: String
    var owe: Float
    var items: [Item]
    
    init(name: String) {
        self.name = name
        self.owe = 0.0
        self.items = []
    }
    
    // Add item to items array to signify
    // he or she are responsible for the item
    func addItem(item: Item) {
        items.append(item)
    }
    
    // Remove item from items array to signify
    // he or she is not responsible for the item
    func removeItem(item: Item) {
        
        var count:Int = 0
        for i in items {
            if i === item {
                items.remove(at: count)
                break
            }
            count += 1
        }
    }
}
