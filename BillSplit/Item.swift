//
//  Item.swift
//  BillSplit
//
//  Created by Vinh Vu on 7/10/17.
//  Copyright © 2017 Vinh Vu. All rights reserved.
//

import Foundation

class Item {

    var name: String
    var price: Float
    var people: [Person]
    
    init(name: String, price: Float) {
        self.name = name
        self.price = price
        people = []
    }
    
    func addPerson(person: Person) {
        
        people.append(person)
    }
    
    func removePerson(person: Person) {
        
        var count:Int = 0
        for p in people {
            if p === person {
                people.remove(at: count)
                break
            }
            count += 1
        }
    }
}
