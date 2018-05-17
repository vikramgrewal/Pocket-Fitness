import Foundation
import SQLite

public class UserTable {

   public static func getUserWithFacebookId(facebookId: String) -> User? {

      guard let dbConnection = AppDatabase.getConnection() else {
         return nil
      }

      let userTable = AppDatabase.userTable
      let userIdColumn = AppDatabase.userIdColumn
      let facebookIdColumn = AppDatabase.facebookIdColumn
      let firstNameColumn = AppDatabase.firstNameColumn
      let lastNameColumn = AppDatabase.lastNameColumn
      let emailColumn = AppDatabase.emailColumn
      let weightColumn = AppDatabase.weightColumn
      let createdAtColumn = AppDatabase.createdAtColumn

      do {
         let userQuery = userTable.filter(facebookIdColumn == facebookId)
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
         return nil
      }


   }

   public static func insertUser(facebookId : String) -> User? {
      guard let dbConnection = AppDatabase.getConnection() else {
         return nil
      }

      let userTable = AppDatabase.userTable
      let userToInsert = User(facebookId: facebookId, createdAt: Date())
      let facebookIdColumn = AppDatabase.facebookIdColumn
      let createdAtColumn = AppDatabase.createdAtColumn

      do {
         let rowId = try dbConnection.run(userTable.insert(facebookIdColumn <- facebookId,
                                                           createdAtColumn <- userToInsert.createdAt!))
         userToInsert.userId = rowId
         guard userToInsert.facebookId != nil else {
            return nil
         }
         return userToInsert
      } catch {
         return nil
      }
   }

   public static func getCurrentUser() throws -> User  {
      guard let dbConnection = try AppDatabase.getConnection() else {
         throw DatabaseError.databaseConnectionError
      }

      let userTable = AppDatabase.userTable
      let userIdColumn = AppDatabase.userIdColumn
      let facebookIdColumn = AppDatabase.facebookIdColumn
      let firstNameColumn = AppDatabase.firstNameColumn
      let lastNameColumn = AppDatabase.lastNameColumn
      let emailColumn = AppDatabase.emailColumn
      let weightColumn = AppDatabase.weightColumn
      let createdAtColumn = AppDatabase.createdAtColumn

      guard let userId = UserSession.getUserId() else {
         throw UserError.userNotFound
      }


      let userQuery = userTable.filter(userIdColumn == userId)
      let fetchedUser = Array<SQLite.Row>(try dbConnection.prepare(userQuery))
      guard fetchedUser.count == 1 else {
         throw UserError.userNotFound
      }

      let facebookId = fetchedUser[0][facebookIdColumn]
      let firstName = fetchedUser[0][firstNameColumn]
      let lastName = fetchedUser[0][lastNameColumn]
      let email = fetchedUser[0][emailColumn]
      let weight = fetchedUser[0][weightColumn]
      let createdAt = fetchedUser[0][createdAtColumn]

      let user = User(userId : userId, facebookId: facebookId, firstName: firstName,
                      lastName: lastName, email: email, bodyWeight: weight, createdAt: createdAt)


      return user
   }

   public static func updateExistingUser(user : User) throws {
      guard let dbConnection = AppDatabase.getConnection() else {
         throw DatabaseError.databaseConnectionError
      }

      guard let userId = UserSession.getUserId() else {
         throw UserError.userNotFound
      }


      let userTable = AppDatabase.userTable
      let userIdColumn = AppDatabase.userIdColumn
      let firstNameColumn = AppDatabase.firstNameColumn
      let lastNameColumn = AppDatabase.lastNameColumn
      let emailColumn = AppDatabase.emailColumn

      let firstName = user.firstName == nil ? "" : user.firstName!
      let lastName = user.lastName == nil ? "" : user.lastName!
      let email = user.email == nil ? "" : user.email!

      let retrievedExercise = userTable.filter(userIdColumn == userId)
      do {

         try dbConnection.run(retrievedExercise.update(firstNameColumn <- firstName,
                                                       lastNameColumn <- lastName,
                                                       emailColumn <- email))
      } catch {
         throw error
      }
   }
}

public enum UserError : Error {
   case userNotFound
   case facebookIdError
}
