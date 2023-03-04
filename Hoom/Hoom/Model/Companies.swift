//
//  Companies.swift
//  Hoom
//
//  Created by Anish on 09/10/2020.
//

import Foundation

class Companies {
    var id : Int
    var serviceId:Int
    var name:String
    var price:String
    
    init(id:Int,serviceId:Int,name:String,price:String) {
        self.id = id
        self.serviceId = serviceId
        self.name = name
        self.price = price
    }
}

