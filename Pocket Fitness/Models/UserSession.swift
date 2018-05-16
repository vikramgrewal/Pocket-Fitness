import Foundation

let loginKey = "isLoggedIn"
let defaults = UserDefaults.standard

class UserSession {

   static func isLoggedIn() -> Bool {
      let loggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn") == true ? true : false
      return loggedIn
   }

   static func login(user : User)   {
      defaults.setValue(true, forKey: loginKey)
      defaults.synchronize()
      KeychainController.saveID(ID: user.facebookId as! NSString)
//      KeychainController.saveToken(token: user.retrievedToken as NSString)
//      KeychainController.saveTokenRefreshDate(refreshDate: user.refreshDate as NSDate)
//      KeychainController.saveTokenExpirationDate(expirationDate: user.expirationDate as NSDate)
   }

   static func logout()  {
      defaults.setValue(false, forKey: loginKey)
      defaults.synchronize()
   }
}
