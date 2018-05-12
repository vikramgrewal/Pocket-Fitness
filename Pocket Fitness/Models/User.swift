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
