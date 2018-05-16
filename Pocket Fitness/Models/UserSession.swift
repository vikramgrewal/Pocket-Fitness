import Foundation

let loginKey = "isLoggedIn"
let defaults = UserDefaults.standard
let userIdKey = "userIdKey"

class UserSession {

   static func isLoggedIn() -> Bool {
      let loggedIn = UserDefaults.standard.bool(forKey: loginKey) == true ? true : false
      return loggedIn
   }

   static func getUserId() -> Int64 {
      let userId = UserDefaults.standard.object(forKey: userIdKey) as! Int64
      return userId
   }

   static func login(user : User)   {
      defaults.setValue(true, forKey: loginKey)
      defaults.setValue(user.userId, forKey: userIdKey)
      defaults.synchronize()
      KeychainController.saveID(ID: user.facebookId as! NSString)
//      KeychainController.saveToken(token: user.retrievedToken as NSString)
//      KeychainController.saveTokenRefreshDate(refreshDate: user.refreshDate as NSDate)
//      KeychainController.saveTokenExpirationDate(expirationDate: user.expirationDate as NSDate)
   }

   static func logout()  {
      defaults.setValue(false, forKey: loginKey)
      defaults.setValue(nil, forKey: loginKey)
      defaults.synchronize()
   }
}
