//
//  WorkoutExerciseTable.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 5/16/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import Foundation

public class WorkoutExerciseTable {
   public static func getWorkoutExercisesForWorkoutId(workoutId : Int64) -> Int? {

      guard let dbConnection = AppDatabase.getConnection() else {
         return nil
      }

      let workoutExerciseTable = AppDatabase.workoutExerciseTable
      let workoutIdColumn = AppDatabase.workoutIdColumn

      do{
         let workoutExercisesQuery = try workoutExerciseTable.filter(workoutIdColumn == workoutId)
         let fetchedExercises = Array<SQLite.Row>(try dbConnection.prepare(workoutExercisesQuery))
         return fetchedExercises.count
      } catch {
         print(error.localizedDescription)
      }

      return nil
   }
}
