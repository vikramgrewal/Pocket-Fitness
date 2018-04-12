//
//  AuthenticationKeychain.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 4/11/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//
import Foundation
import Security

// Constant Identifiers
let userAccount = "AuthenticatedUser"
let accessGroup = "SecuritySerivice"

/**
 *  User defined keys for new entry
 *  Note: add new keys for new secure item and use them in load and save methods
 */

let tokenKey = "KeyForToken"
let idKey = "KeyForFacebookID"
let expirationDateKey = "KeyForExpirationDate"
let refreshDateKey = "KeyForTokenRefreshDate"

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

public class KeychainController: NSObject {

   /**
    * Exposed methods to perform save and load queries.
    */

   public class func saveToken(token: NSString) {
      self.save(service: tokenKey as String as NSString, data: token as String as NSString)
   }
   public class func saveID(ID: NSString) {
      self.save(service: idKey as String as NSString, data: ID as String as NSString)
   }

   public class func saveTokenRefreshDate(refreshDate: NSDate)  {
      self.save(service: refreshDateKey as String as NSString, data: refreshDate.description as String as NSString)
   }

   public class func saveTokenExpirationDate(expirationDate: NSDate)  {
      self.save(service: expirationDateKey as String as NSString, data: expirationDate.description as String as NSString)
   }

   public class func loadToken() -> NSString? {
      return self.load(service: tokenKey as String as NSString)
   }
   public class func loadID() -> NSString? {
      return self.load(service: idKey as String as NSString)
   }

   public class func loadTokenRefreshDate() -> NSString? {
      return self.load(service: refreshDateKey as String as NSString)
   }

   public class func loadTokenExpirationDate() -> NSString? {
      return self.load(service: expirationDateKey as String as NSString)
   }

   /**
    * Internal methods for querying the keychain.
    */

   private class func save(service: NSString, data: NSString) {
      let dataFromString: NSData = data.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)! as NSData

      // Instantiate a new default keychain query
      let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])

      // Delete any existing items
      SecItemDelete(keychainQuery as CFDictionary)

      // Add the new keychain item
      SecItemAdd(keychainQuery as CFDictionary, nil)
   }

   private class func load(service: NSString) -> NSString? {
      // Instantiate a new default keychain query
      // Tell the query to return a result
      // Limit our results to one item
      let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])

      var dataTypeRef :AnyObject?

      // Search for the keychain items
      let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
      var contentsOfKeychain: NSString? = nil

      if status == errSecSuccess {
         if let retrievedData = dataTypeRef as? NSData {
            contentsOfKeychain = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue)
         }
      } else {
         print("Nothing was retrieved from the keychain. Status code \(status)")
      }

      return contentsOfKeychain
   }
}
