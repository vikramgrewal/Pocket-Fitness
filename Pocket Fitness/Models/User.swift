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

   init(facebookId: String, createdAt: Date)   {
      self.facebookId = facebookId
      self.createdAt = createdAt
   }

}

// Handle all database queries for users below this mark
extension User {
   public static func getUserWithFacebookId(facebookId: String) -> User? {
      guard let dbConnection = AppDatabase.getConnection() else {
         return nil
      }

      do {
         let userTableName = User.userTableName
         let userTable = Table(userTableName)
         let userIdColumn = Expression<Int64>(User.userIdColumn)
         let facebookIdColumn = Expression<String>(User.facebookIdColumn)
         let firstNameColumn = Expression<String?>(User.firstNameColumn)
         let lastNameColumn = Expression<String?>(User.lastNameColumn)
         let emailColumn = Expression<String?>(User.emailColumn)
         let weightColumn = Expression<Double?>(User.weightColumn)
         let createdAtColumn = Expression<Date>(User.createdAtColumn)

         let userQuery = try userTable.filter(facebookIdColumn == facebookId)
         let fetchedUser = Array<SQLite.Row>(try dbConnection.prepare(userQuery))
         guard fetchedUser.count == 1 else {
            return nil
         }

         let userId = fetchedUser[0][userIdColumn]
         let facebookId = fetchedUser[0][facebookIdColumn]
         let firstName = fetchedUser[0][firstNameColumn]
         let lastName = fetchedUser[0][lastNameColumn]
         let email = fetchedUser[0][emailColumn]
         let weight = fetchedUser[0][weightColumn]
         let createdAt = fetchedUser[0][createdAtColumn]

         let user = User(userId: userId, facebookId: facebookId, firstName: firstName,
                         lastName: lastName, email: email, bodyWeight: weight, createdAt: createdAt)

         return user

      } catch {
         print("\(error)")
         return nil
      }
      return nil
   }

   public static func insertUser(facebookId : String) -> User? {
      guard let dbConnection = AppDatabase.getConnection() else {
         return nil
      }

      let userTable = Table(userTableName)
      let userToInsert = User(facebookId: facebookId, createdAt: Date())
      let facebookIdColumn = Expression<String>(User.facebookIdColumn)
      let createdAtColumn = Expression<Date>(User.createdAtColumn)

      do {
         let rowId = try dbConnection.run(userTable.insert(facebookIdColumn <- facebookId,
                                                           createdAtColumn <- userToInsert.createdAt!))
         userToInsert.userId = rowId
         guard let facebookId = userToInsert.facebookId else {
            return nil
         }
         return userToInsert
      } catch {
         print("\(error)")
         return nil
      }
   }
}

