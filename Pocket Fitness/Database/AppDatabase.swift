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

      do {

         let exerciseTableName = Exercise.exerciseTableName

         let exerciseTable = Table(exerciseTableName)
         let exerciseIdColumn = Expression<Int64>(Exercise.exerciseIdColumn)
         let exerciseNameColumn = Expression<String>(Exercise.exerciseNameColumn)
         let exerciseTypeColumn = Expression<String>(Exercise.exerciseTypeColumn)
         let exerciseMuscleColumn = Expression<String>(Exercise.exerciseMuscleColumn)
         let userIdColumn = Expression<Int64>(User.userIdColumn)

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
         let userTableName = User.userTableName
         let userTable = Table(userTableName)
         let userIdColumn = Expression<Int64>(User.userIdColumn)
         let facebookIdColumn = Expression<String>(User.facebookIdColumn)
         let firstNameColumn = Expression<String?>(User.firstNameColumn)
         let lastNameColumn = Expression<String?>(User.lastNameColumn)
         let emailColumn = Expression<String?>(User.emailColumn)
         let weightColumn = Expression<Double?>(User.weightColumn)
         let createdAtColumn = Expression<Date>(User.createdAtColumn)

         try dbConnection.run(userTable.create(ifNotExists: true) { userTable in
            userTable.column(userIdColumn, primaryKey: true)
            userTable.column(facebookIdColumn, unique: true)
            userTable.column(firstNameColumn)
            userTable.column(lastNameColumn)
            userTable.column(emailColumn)
            userTable.column(weightColumn)
            userTable.column(createdAtColumn)
         })
      } catch {
         print("\(error)")
      }

      do {
         let workoutTableName = Workout.workoutTableName
         let workoutTable = Table(workoutTableName)
         let workoutIdColumn = Expression<Int64>(Workout.workoutIdColumn)
         let workoutNameColumn = Expression<String?>(Workout.workoutNameColumn)
         let workoutDateColumn = Expression<Date>(Workout.workoutDateColumn)
         let workoutNotesColumn = Expression<String?>(Workout.workoutNameColumn)
         let workoutUserWeightColumn = Expression<Double?>(Workout.workoutUserWeightColumn)
         let userIdColumn = Expression<Int64>(User.userIdColumn)

         try dbConnection.run(workoutTable.create(ifNotExists: true) { workoutTable in
            workoutTable.column(workoutIdColumn, primaryKey: true)
            workoutTable.column(workoutNameColumn)
            workoutTable.column(workoutDateColumn)
            workoutTable.column(workoutNotesColumn)
            workoutTable.column(workoutUserWeightColumn)
            workoutTable.column(userIdColumn)
         })
      } catch {
         print("\(error)")
      }

      do {
         let workoutExerciseTableName = WorkoutExercise.workoutExerciseTableName
         let workoutExerciseTable = Table(workoutExerciseTableName)
         let workoutExerciseIdColumn = Expression<Int64>(WorkoutExercise.workoutExerciseIdColumn) //PK
         let workoutIdColumn = Expression<Int64>(Workout.workoutIdColumn) //FK
         let exerciseIdColumn = Expression<Int64>(Exercise.exerciseIdColumn) //FK
         let workoutExerciseDateColumn = Expression<Date>(WorkoutExercise.workoutExerciseDateColumn)

         try dbConnection.run(workoutExerciseTable.create(ifNotExists: true) { workoutExerciseTable in
            workoutExerciseTable.column(workoutExerciseIdColumn, primaryKey: true)
            workoutExerciseTable.column(workoutIdColumn)
            workoutExerciseTable.column(exerciseIdColumn)
            workoutExerciseTable.column(workoutExerciseDateColumn)
         })
      } catch {
         print("\(error)")
      }

      do {
         let workoutExerciseSetTableName = WorkoutExerciseSet.workoutExerciseSetTableName
         let workoutExerciseSetTable = Table(workoutExerciseSetTableName)
         let workoutExerciseSetId = Expression<Int64>(WorkoutExerciseSet.workoutExerciseSetIdColumn)
         let workoutExerciseSetReps = Expression<Int?>(WorkoutExerciseSet.workoutExerciseSetRepsColumn)
         let workoutExerciseSetWeight = Expression<Double?>(WorkoutExerciseSet.workoutExerciseSetWeightColumn)
         let workoutExerciseSetTime = Expression<Double?>(WorkoutExerciseSet.workoutExerciseSetTimeColumn)
         let workoutExerciseSetDate = Expression<Date>(WorkoutExerciseSet.workoutExerciseSetDateColumn)
         let workoutExerciseId = Expression<Int64>(WorkoutExercise.workoutExerciseIdColumn) //FK
         let workoutId = Expression<Int64>(Workout.workoutIdColumn) //FK
         let userId = Expression<Int64>(User.userIdColumn) //FK

         try dbConnection.run(workoutExerciseSetTable.create(ifNotExists: true) { workoutExerciseSetTable in
            workoutExerciseSetTable.column(workoutExerciseSetId, primaryKey: true)
            workoutExerciseSetTable.column(workoutExerciseSetReps)
            workoutExerciseSetTable.column(workoutExerciseSetWeight)
            workoutExerciseSetTable.column(workoutExerciseSetTime)
            workoutExerciseSetTable.column(workoutExerciseSetDate)
            workoutExerciseSetTable.column(workoutExerciseId)
            workoutExerciseSetTable.column(workoutId)
            workoutExerciseSetTable.column(userId)
         })
      } catch {
         print("\(error)")
      }

   }

}
