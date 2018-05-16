//
//  Workout.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 5/11/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import Foundation
import SQLite

public class Workout {
   var workoutId : Int64?
   var workoutName : String?
   var workoutDate : Date?
   var workoutNotes : String?
   var userId : Int64?
   var userWeight : Double?

   // Database fields
   static let workoutTableName = "Workout"
   static let workoutIdColumn = "workoutId"
   static let workoutNameColumn = "workoutName"
   static let workoutDateColumn = "workoutDate"
   static let workoutNotesColumn = "workoutNotes"
   static let workoutUserWeightColumn = "workoutUserWeight"

   init(workoutId : Int64?, workoutName : String?, workoutDate: Date?,
      workoutNotes : String?, userId :Int64?, userWeight : Double?)   {
      self.workoutId = workoutId
      self.workoutName = workoutName
      self.workoutDate = workoutDate
      self.workoutNotes = workoutNotes
      self.userId = userId
      self.userWeight = userWeight
   }

   init(workoutId : Int64, workoutName : String, workoutDate : Date, workoutNotes : String)   {
      self.workoutName = workoutName
      self.workoutDate = workoutDate
      self.workoutNotes = workoutNotes
      self.workoutId = workoutId
   }
   
}

// Handle workout database logic
extension Workout {

   public static func insertNewWorkout() -> Workout?  {
      guard let dbConnection = AppDatabase.getConnection() else {
         print("Error establishing database connection")
         return nil
      }

      guard let userId = User.getUserIdForSession() else {
         return nil
      }

      do {
         let workoutTableName = Workout.workoutTableName
         let workoutTable = Table(workoutTableName)
         let workoutDateColumn = Expression<Date>(Workout.workoutDateColumn)
         let userIdColumn = Expression<Int64>(User.userIdColumn)
         let workoutDate = Date()
         let insertWorkoutQuery = workoutTable.insert(workoutDateColumn <- workoutDate,
                                                      userIdColumn <- userId)
         let rowid = try dbConnection.run(insertWorkoutQuery)

         let workout = Workout(workoutId: rowid, workoutName: nil, workoutDate: workoutDate,
                               workoutNotes: nil, userId: userId, userWeight: nil)

         return workout
      } catch {
         return nil
      }
      return nil
   }

   public static func getAllWorkouts() -> [Workout]? {
      var workouts : [Workout] = [Workout]()

      guard let dbConnection = AppDatabase.getConnection() else {
         print("Error establishing database connection")
         return nil
      }

      guard let userId = User.getUserIdForSession() else {
         return nil
      }

      let workoutTableName = Workout.workoutTableName
      let workoutTable = Table(workoutTableName)
      let workoutIdColumn = Expression<Int64>(Workout.workoutIdColumn)
      let workoutNameColumn = Expression<String?>(Workout.workoutNameColumn)
      let workoutDateColumn = Expression<Date>(Workout.workoutDateColumn)
      let workoutNotesColumn = Expression<String?>(Workout.workoutNotesColumn )
      let workoutUserWeightColumn = Expression<Double?>(Workout.workoutUserWeightColumn)
      let userIdColumn = Expression<Int64>(User.userIdColumn)
      let getWorkoutQuery = workoutTable.filter(userIdColumn == userId).order(workoutDateColumn.desc)
      do {
         for workout in try dbConnection.prepare(getWorkoutQuery) {
            do {
               let workoutId = workout[workoutIdColumn].datatypeValue
               let workoutName = try workout.get(workoutNameColumn)?.datatypeValue
               let workoutDateString = try workout.get(workoutDateColumn).description
               let workoutDate = Date.getDateFromString(date: workoutDateString)
               let workoutNotes = try workout.get(workoutNotesColumn)?.datatypeValue
               let workoutUserWeight = try workout.get(workoutUserWeightColumn)?.datatypeValue
               let userId = try workout.get(userIdColumn).datatypeValue
               let newWorkout = Workout(workoutId: workoutId, workoutName: workoutName, workoutDate: workoutDate,
                                     workoutNotes: workoutNotes, userId: userId, userWeight: workoutUserWeight)
               workouts.append(newWorkout)
            } catch {
               // handle
               print("Encountered issue with one of the workouts")
            }
         }
      } catch {
         return nil
      }
      return workouts
   }

   public static func updateExistingWorkout(workout : Workout) throws {
      guard let dbConnection = AppDatabase.getConnection() else {
         throw DatabaseError.databaseError
      }

      guard let userId = User.getUserIdForSession() else {
         throw UserError.userNotFound
      }



      let workoutTable = AppDatabase.workoutTable
      let userIdColumn = AppDatabase.userIdColumn
      let workoutIdColumn = AppDatabase.workoutIdColumn
      let workoutNameColumn = AppDatabase.workoutNameColumn
      let workoutDateColumn = AppDatabase.workoutDateColumn
      let workoutNotescolumn = AppDatabase.workoutNotesColumn

      let workoutName = workout.workoutName == nil ? "" : workout.workoutName!
      let workoutDate = workout.workoutDate!
      let workoutNotes = workout.workoutNotes == nil ? "" : workout.workoutNotes!

      let retrievedWorkout = workoutTable.filter(userIdColumn == userId &&
         workoutIdColumn == workout.workoutId!)

      do {
         try dbConnection.run(retrievedWorkout.update(workoutNameColumn <- workoutName,
                                                      workoutNotescolumn <- workoutNotes,
                                                      workoutDateColumn <- workoutDate))
      } catch {
         print(error.localizedDescription)
      }
   }
}
