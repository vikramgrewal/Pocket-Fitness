
//
//  User.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 4/11/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import Foundation

public class User {

   var userId : Int64?
   var facebookId : String?
   var firstName : String?
   var lastName : String?
   var email : String?
   var bodyWeight : Double?
   var createdAt : Date?

   // Database fields for columns
   static let userTableName = "User"
   static let userIdColumn = "userId"
   static let facebookIdColumn = "facebookId"
   static let firstNameColumn = "firstName"
   static let lastNameColumn = "lastName"
   static let emailColumn = "email"
   static let weightColumn = "weight"
   static let createdAtColumn = "createdAt"

   init(userId : Int64?, facebookId : String?,
        firstName : String?, lastName : String?,
        email : String?, bodyWeight : Double?,
        createdAt : Date?)   {
      self.userId = userId
      self.facebookId = facebookId
      self.firstName = firstName
      self.lastName = lastName
      self.email = email
      self.bodyWeight = bodyWeight
      self.createdAt = createdAt
   }

   init(facebookId: String)   {
      self.facebookId = facebookId
   }
   

}


