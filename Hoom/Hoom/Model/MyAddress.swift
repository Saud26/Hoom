//
//  MyAddress.swift
//  Hoom
//
//  Created by Anish on 09/10/2020.
//

import Foundation

class MyAddress {
    var id : Int
    var townId : Int
    var address : String
    var postCode:String
    var userId : Int
    
    init(id:Int,townId:Int,address:String,postCode:String,userId:Int) {
        self.id = id
        self.townId = townId
        self.address = address
        self.postCode = postCode
        self.userId = userId
    }
}
/*
 [
   {
     "id" : 2,
     "town_id" : 1,
     "address" : "Hosue 205",
     "postcode" : "71005",
     "user_id" : 2
   }
 ]
 */
