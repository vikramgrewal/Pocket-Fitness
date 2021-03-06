import Foundation
import SQLite

public class User {

   var userId : Int64?
   var facebookId : String?
   var firstName : String?
   var lastName : String?
   var email : String?
   var bodyWeight : Double?
   var createdAt : Date?

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

   init(facebookId: String, createdAt: Date)   {
      self.facebookId = facebookId
      self.createdAt = createdAt
   }

   convenience init()   {
      self.init(userId: nil, facebookId: nil, firstName: nil,
                lastName: nil, email: nil, bodyWeight: nil, createdAt: nil)
   }

}
