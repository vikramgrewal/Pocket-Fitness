import Foundation

public class ExerciseSet {

   var workoutExerciseId : String?
   var exerciseSetId : String?
   var exerciseSetReps : Int?
   var exerciseSetWeight : Float?
   var exerciseSetDate : Date?
   var exerciseSetTime : Date?

   init(workoutExerciseId : String?, exerciseSetId : String?, exerciseSetReps : Int?,
        exerciseSetWeight : Float?, exerciseSetDate : Date?, exerciseSetTime : Date?) {
      self.workoutExerciseId = workoutExerciseId
      self.exerciseSetReps = exerciseSetReps
      self.exerciseSetWeight = exerciseSetWeight
      self.exerciseSetDate = exerciseSetDate
      self.exerciseSetTime = exerciseSetTime
   }

   init(workoutExerciseId : String?) {
      self.workoutExerciseId = workoutExerciseId
   }

}

extension ExerciseSet : Equatable {

   public static func == (lhs: ExerciseSet, rhs: ExerciseSet) -> Bool {
      return lhs.exerciseSetId == rhs.exerciseSetId
   }

}




