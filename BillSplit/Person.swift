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
    
    func addItem(item: Item) {
        items.append(item)
    }
    
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
