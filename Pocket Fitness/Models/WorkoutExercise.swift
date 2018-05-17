import Foundation
import SQLite

public class WorkoutExercise {

   var workoutExerciseId : Int64? 
   var workoutId : Int64?
   var exerciseId : Int64?
   var workoutExerciseDate : Date?

   init(workoutExerciseId : Int64?, workoutId : Int64?,
        exerciseId : Int64?, workoutExerciseDate : Date?) {
      self.workoutExerciseId = workoutExerciseId
      self.workoutId = workoutId
      self.exerciseId = exerciseId
      self.workoutExerciseDate = workoutExerciseDate
   }

   convenience init()   {
      self.init(workoutExerciseId: nil, workoutId: nil,
                exerciseId: nil, workoutExerciseDate: nil)
   }
}

extension WorkoutExercise : Equatable {
   
   public static func == (lhs: WorkoutExercise, rhs: WorkoutExercise) -> Bool {
      return lhs.workoutExerciseId == rhs.workoutExerciseId
   }

}
