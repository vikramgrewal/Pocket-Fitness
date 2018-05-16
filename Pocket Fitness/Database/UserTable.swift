//
//  UserTable.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 5/16/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import Foundation

public class UserTable {
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

   public static func getUserIdForSession() -> Int64? {
      guard let facebookId = KeychainController.loadID() else {
         print("Error fetching facebookId")
         return nil
      }

      guard let fetchedUser = User.getUserWithFacebookId(facebookId: facebookId as String) else {
         print("Error fetching user id")
         return nil
      }

      guard let userId = fetchedUser.userId else {
         return nil
      }

      return userId
   }

   public static func getCurrentUser() throws -> User  {
      guard let dbConnection = AppDatabase.getConnection() else {
         throw DatabaseError.databaseError
      }

      guard let userId = User.getUserIdForSession() else {
         throw UserError.userNotFound
      }


      let userTableName = User.userTableName
      let userTable = Table(userTableName)
      let userIdColumn = Expression<Int64>(User.userIdColumn)
      let facebookIdColumn = Expression<String>(User.facebookIdColumn)
      let firstNameColumn = Expression<String?>(User.firstNameColumn)
      let lastNameColumn = Expression<String?>(User.lastNameColumn)
      let emailColumn = Expression<String?>(User.emailColumn)
      let weightColumn = Expression<Double?>(User.weightColumn)
      let createdAtColumn = Expression<Date>(User.createdAtColumn)

      let userQuery = try userTable.filter(userIdColumn == userId)
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

      let user = User(userId: userId, facebookId: facebookId, firstName: firstName,
                      lastName: lastName, email: email, bodyWeight: weight, createdAt: createdAt)

      return user
   }

   public static func updateExistingUser(user : User) throws {
      guard let dbConnection = AppDatabase.getConnection() else {
         print("Error establishing database connection")
         throw DatabaseError.databaseError
      }

      guard let userId = UserTable.getUserIdForSession() else {
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
         print(error.localizedDescription)
      }
   }
}

enum UserTableError {
   case userNotFound
}
