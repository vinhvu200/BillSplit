//
//  Item.swift
//  BillSplit
//
//  Created by Vinh Vu on 7/10/17.
//  Copyright © 2017 Vinh Vu. All rights reserved.
//

import Foundation

struct Item {

    var name: String
    var price: Float
    
    var finalName: String
    var finalPrice: Float
    var people: [Person]
    
    init(name: String, price: Float) {
        self.name = name
        self.price = price
        finalName = ""
        finalPrice = 0
        people = []
    }
}
