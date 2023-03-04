//
//  CompanyServices.swift
//  Hoom
//
//  Created by Anish on 15/10/2020.
//

import Foundation

class CompanyServices {
    
    var id : Int
    var status : String
    var price : Int
    var companyId: Int
    var serviceDetail : String
    
    init(id:Int,status:String,price:Int,companyId:Int,serviceDetail:String) {
        self.id = id
        self.status = status
        self.price = price
        self.companyId = companyId
        self.serviceDetail = serviceDetail
    }
    
    
}
/*
 {
   "id" : 1,
   "status" : "1",
   "price" : 5,
   "company_id" : 1,
   "service_detail" : "Tree Trim"
 },
 */
