//
//  MyOrders.swift
//  Hoom
//
//  Created by Anish on 26/10/2020.
//

import Foundation

class MyOrders {
    var userId :Int
    var order_address : String
    var id : Int
    var order_total : Int
    var order_date : String
    
    var order_details:String
    var order_status : String
    var service_id : Int
    var order_id : Int
    var service_title : String
    var estimated_price : String
   
    init(userId :Int,order_address : String,id : Int,order_total : Int,order_date : String,order_details:String,order_status : String,service_id : Int,order_id : Int,service_title : String,estimated_price : String) {
        self.userId = userId
        self.order_address = order_address
        self.id = id
        self.order_total = order_total
        self.order_date = order_date
        self.order_details = order_details
        self.order_status = order_status
        self.service_id = service_id
        self.order_id = order_id
        self.service_title = service_title
        self.estimated_price = estimated_price
    }
    
}

/*
 {
   "user_id" : 2,
   "order_address" : "9",
   "id" : 13,
   "order_total" : 80,
   "order_date" : "2020-10-26 22:00:00",
   "order_details" : "Abc Co",
   "order_status" : "paid",
   "service_id" : 3,
   "order_id" : 13,
   "service_title" : "Full Services",
   "updated_at" : "2020-10-26T17:00:20.000000Z",
   "estimated_price" : "40",
   "created_at" : "2020-10-26T17:00:20.000000Z"
 }
 */
