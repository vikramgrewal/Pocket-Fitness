import Foundation

public class ExerciseSet {

   var workoutExerciseId : Int64?
   var exerciseSetId : Int64?
   var exerciseSetReps : Int?
   var exerciseSetWeight : Float?
   var exerciseSetDate : Date?
   var exerciseSetTime : Date?

   init(workoutExerciseId : Int64?, exerciseSetId : Int64?, exerciseSetReps : Int?,
        exerciseSetWeight : Float?, exerciseSetDate : Date?, exerciseSetTime : Date?) {
      self.workoutExerciseId = workoutExerciseId
      self.exerciseSetReps = exerciseSetReps
      self.exerciseSetWeight = exerciseSetWeight
      self.exerciseSetDate = exerciseSetDate
      self.exerciseSetTime = exerciseSetTime
   }

   init(workoutExerciseId : Int64?) {
      self.workoutExerciseId = workoutExerciseId
   }

}

extension ExerciseSet : Equatable {

   public static func == (lhs: ExerciseSet, rhs: ExerciseSet) -> Bool {
      return lhs.workoutExerciseId == rhs.workoutExerciseId
   }

}




