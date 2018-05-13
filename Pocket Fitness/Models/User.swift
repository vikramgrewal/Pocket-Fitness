
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

   static let userIdColumn = "userId"

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
   

}

let loginKey = "isLoggedIn"
let defaults = UserDefaults.standard

struct User {
   let userId, retrievedToken : String
   let refreshDate, expirationDate : Date
}

class UserSession {

   static func isLoggedIn() -> Bool {
      let loggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn") == true ? true : false
      return loggedIn
   }

   static func login(user : User)   {
      defaults.setValue(true, forKey: loginKey)
      defaults.synchronize()
      KeychainController.saveID(ID: user.userId as NSString)
      KeychainController.saveToken(token: user.retrievedToken as NSString)
      KeychainController.saveTokenRefreshDate(refreshDate: user.refreshDate as NSDate)
      KeychainController.saveTokenExpirationDate(expirationDate: user.expirationDate as NSDate)
   }

   static func logout()  {
      defaults.setValue(false, forKey: loginKey)
      defaults.synchronize()
   }
}