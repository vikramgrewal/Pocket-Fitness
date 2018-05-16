import Foundation
import SQLite

public class WorkoutExercise {

   var workoutExerciseId : Int64? // Primary key
   var workoutId : Int64? // Foreign key
   var exerciseId : Int64? // Foreign key
   var workoutExerciseDate : Date?
   var userId : Int64? // Foreign key

   // Database
   
   
   init(workoutExerciseId : Int64?, workoutId : Int64?,
        exerciseId : Int64?, workoutExerciseDate : Date?, userId : Int64?) {
      self.workoutExerciseId = workoutExerciseId
      self.workoutId = workoutId
      self.exerciseId = exerciseId
      self.workoutExerciseDate = workoutExerciseDate
      self.userId = userId
   }
}

extension WorkoutExercise : Equatable {
   
   public static func == (lhs: WorkoutExercise, rhs: WorkoutExercise) -> Bool {
      return lhs.workoutExerciseId == rhs.workoutExerciseId
   }

}

// TODO: Implement all database functions for particular model
extension WorkoutExercise {

   
}
