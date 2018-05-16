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

   static let exerciseTableName = Exercise.exerciseTableName

   static let exerciseTable = Table(exerciseTableName)
   static let exerciseIdColumn = Expression<Int64>(Exercise.exerciseIdColumn)
   static let exerciseNameColumn = Expression<String>(Exercise.exerciseNameColumn)
   static let exerciseTypeColumn = Expression<String>(Exercise.exerciseTypeColumn)
   static let exerciseMuscleColumn = Expression<String>(Exercise.exerciseMuscleColumn)
   static let userIdColumn = Expression<Int64>(User.userIdColumn)

   static let userTableName = User.userTableName
   static let userTable = Table(userTableName)
   static let facebookIdColumn = Expression<String>(User.facebookIdColumn)
   static let firstNameColumn = Expression<String?>(User.firstNameColumn)
   static let lastNameColumn = Expression<String?>(User.lastNameColumn)
   static let emailColumn = Expression<String?>(User.emailColumn)
   static let weightColumn = Expression<Double?>(User.weightColumn)
   static let createdAtColumn = Expression<Date>(User.createdAtColumn)

   static let workoutTableName = Workout.workoutTableName
   static let workoutTable = Table(workoutTableName)
   static let workoutIdColumn = Expression<Int64>(Workout.workoutIdColumn)
   static let workoutNameColumn = Expression<String?>(Workout.workoutNameColumn)
   static let workoutDateColumn = Expression<Date>(Workout.workoutDateColumn)
   static let workoutNotesColumn = Expression<String?>(Workout.workoutNotesColumn )
   static let workoutUserWeightColumn = Expression<Double?>(Workout.workoutUserWeightColumn)

   static let workoutExerciseTableName = WorkoutExercise.workoutExerciseTableName
   static let workoutExerciseTable = Table(workoutExerciseTableName)
   static let workoutExerciseIdColumn = Expression<Int64>(WorkoutExercise.workoutExerciseIdColumn)
   static let workoutExerciseDateColumn = Expression<Date>(WorkoutExercise.workoutExerciseDateColumn)

   static let workoutExerciseSetTableName = WorkoutExerciseSet.workoutExerciseSetTableName
   static let workoutExerciseSetTable = Table(workoutExerciseSetTableName)
   static let workoutExerciseSetIdColumn = Expression<Int64>(WorkoutExerciseSet.workoutExerciseSetIdColumn)
   static let workoutExerciseSetRepsColumn = Expression<Int?>(WorkoutExerciseSet.workoutExerciseSetRepsColumn)
   static let workoutExerciseSetWeightColumn = Expression<Double?>(WorkoutExerciseSet.workoutExerciseSetWeightColumn)
   static let workoutExerciseSetTimeColumn = Expression<Double?>(WorkoutExerciseSet.workoutExerciseSetTimeColumn)
   static let workoutExerciseSetDateColumn = Expression<Date>(WorkoutExerciseSet.workoutExerciseSetDateColumn)

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

      do {

         try dbConnection.run(exerciseTable.create(ifNotExists: true) { exerciseTable in
            exerciseTable.column(exerciseIdColumn, primaryKey: true)
            exerciseTable.column(exerciseNameColumn, unique: true)
            exerciseTable.column(exerciseTypeColumn)
            exerciseTable.column(exerciseMuscleColumn)
            exerciseTable.column(userIdColumn)
         })
      } catch {
         print("\(error)")
      }

      do {

         try dbConnection.run(userTable.create(ifNotExists: true) { userTable in
            userTable.column(userIdColumn, primaryKey: true)
            userTable.column(facebookIdColumn, unique: true)
            userTable.column(firstNameColumn, defaultValue: nil)
            userTable.column(lastNameColumn, defaultValue: nil)
            userTable.column(emailColumn, defaultValue: nil)
            userTable.column(weightColumn, defaultValue: nil)
            userTable.column(createdAtColumn)
         })
      } catch {
         print("\(error)")
      }

      do {

         try dbConnection.run(workoutTable.create(ifNotExists: true) { workoutTable in
            workoutTable.column(workoutIdColumn, primaryKey: true)
            workoutTable.column(workoutNameColumn, defaultValue: nil)
            workoutTable.column(workoutDateColumn)
            workoutTable.column(workoutNotesColumn, defaultValue: nil)
            workoutTable.column(workoutUserWeightColumn, defaultValue: nil)
            workoutTable.column(userIdColumn)
         })
      } catch {
         print("\(error)")
      }

      do {

         try dbConnection.run(workoutExerciseTable.create(ifNotExists: true) { workoutExerciseTable in
            workoutExerciseTable.column(workoutExerciseIdColumn, primaryKey: true)
            workoutExerciseTable.column(workoutIdColumn)
            workoutExerciseTable.column(exerciseIdColumn)
            workoutExerciseTable.column(workoutExerciseDateColumn)
            workoutExerciseTable.column(userIdColumn)
         })
      } catch {
         print("\(error)")
      }

      do {
         try dbConnection.run(workoutExerciseSetTable.create(ifNotExists: true) { workoutExerciseSetTable in
            workoutExerciseSetTable.column(workoutExerciseSetIdColumn, primaryKey: true)
            workoutExerciseSetTable.column(workoutExerciseSetRepsColumn)
            workoutExerciseSetTable.column(workoutExerciseSetWeightColumn)
            workoutExerciseSetTable.column(workoutExerciseSetTimeColumn)
            workoutExerciseSetTable.column(workoutExerciseSetDateColumn)
            workoutExerciseSetTable.column(workoutExerciseIdColumn)
            workoutExerciseSetTable.column(workoutIdColumn)
            workoutExerciseSetTable.column(userIdColumn)
         })
      } catch {
         print("\(error)")
      }

   }

   public static func dropEntireDatabase()   {
      guard let dbConnection = AppDatabase.getConnection() else {
         return
      }

      do {

         try dbConnection.run(exerciseTable.drop(ifExists: true))
         try dbConnection.run(userTable.drop(ifExists: true))
         try dbConnection.run(workoutTable.drop(ifExists: true))
         try dbConnection.run(workoutExerciseTable.drop(ifExists: true))
         try dbConnection.run(workoutExerciseSetTable.drop(ifExists: true))

      } catch {
         print("\(error)")
      }
   }

}

enum DatabaseError : Error {
   case databaseError
}
