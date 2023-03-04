//
//  Review.swift
//  Hoom
//
//  Created by Anish on 19/10/2020.
//

import Foundation

class Review {
    var name : String
    var userId: Int
    var companyId:Int
    var rating : Int
    var createdAt : String
    init(name:String,userId: Int,companyId:Int,rating : Int,createdAt : String) {
        self.name = name
        self.userId = userId
        self.companyId = companyId
        self.rating = rating
        self.createdAt = createdAt
    }
}

/*  {
 "email_verified_at" : null,
 "email" : "anish1890@gmail.com",
 "password" : "$2y$10$O0kotk04MaXX4j93OF.mXOwTWv6Fok25SOrZ0VCSDbDM6gdg2TJtq",
 "remember_token" : null,
 "company_id" : 1,
 "id" : 2,
 "rating" : 4,
 "role_id" : 3,
 "user_id" : 2,
 "created_at" : "2020-10-07T23:48:36.000000Z",
 "updated_at" : "2020-10-07T23:48:36.000000Z",
 "name" : "anish"
}*/
