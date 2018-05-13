//
//  Connection.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 5/12/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import Foundation
import SQLite

public class AppDatabase {

   public static func getConnection() -> Connection? {

      do {
         let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
         let dbConnection = try Connection("\(path)/db.sqlite3")
         return dbConnection
      } catch {
         print("\(error)")
      }
      
      return nil
   }

   public static func setUpSchema() {
      guard let dbConnection = AppDatabase.getConnection() else {
         print("Error establishing default schema for app")
         return
      }

      let exerciseTableName = Exercise.exerciseTableName

      let exerciseTable = Table(exerciseTableName)
      let exerciseIdColumn = Expression<Int64>(Exercise.exerciseIdColumn)
      let exerciseNameColumn = Expression<String>(Exercise.exerciseNameColumn)
      let exerciseTypeColumn = Expression<String>(Exercise.exerciseTypeColumn)
      let exerciseMuscleColumn = Expression<String>(Exercise.exerciseMuscleColumn)
      let userIdColumn = Expression<Int64>(User.userIdColumn)

      do {
         try dbConnection.run(exerciseTable.create(ifNotExists: true) { table in
            table.column(exerciseIdColumn, primaryKey: true)
            table.column(exerciseNameColumn, unique: true)
            table.column(exerciseTypeColumn)
            table.column(exerciseMuscleColumn)
            table.column(userIdColumn)
         })
      } catch {
         print("\(error)")
      }

      

   }

}
