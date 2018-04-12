//
//  User.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 4/11/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import Foundation

let loginKey = "isLoggedIn"

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
      UserDefaults.standard.setValue(true, forKey: loginKey)
      UserDefaults.standard.synchronize()
      KeychainController.saveID(ID: user.userId as NSString)
      KeychainController.saveToken(token: user.retrievedToken as NSString)
      KeychainController.saveTokenRefreshDate(refreshDate: user.refreshDate as NSDate)
      KeychainController.saveTokenExpirationDate(expirationDate: user.expirationDate as NSDate)
   }

   static func logout(user : User)  {
      UserDefaults.setValue(false, forKey: loginKey)
   }

}
