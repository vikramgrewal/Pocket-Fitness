import Foundation

public class WorkoutExerciseSet {

   var workoutExerciseSetId : Int64? // Primary key
   var workoutExerciseId : Int64? // Foreign key
   var workoutId : Int64? // Foreign key
   var workoutExerciseSetReps : Int?
   var workoutExerciseSetWeight : Float?
   var workoutExerciseSetDate : Date?
   var workoutExerciseSetTime : Date?
   
   init(workoutExerciseSetId : Int64?, workoutExerciseId : Int64?,
        workoutId : Int64?, workoutExerciseSetReps : Int?,
        workoutExerciseSetWeight : Float?, workoutExerciseSetDate : Date?,
        workoutExerciseSetTime : Date?)  {

      self.workoutExerciseSetId = workoutExerciseSetId
      self.workoutExerciseId = workoutExerciseId
      self.workoutId = workoutId
      self.workoutExerciseSetReps = workoutExerciseSetReps
      self.workoutExerciseSetWeight = workoutExerciseSetWeight
      self.workoutExerciseSetDate = workoutExerciseSetDate
      self.workoutExerciseSetTime = workoutExerciseSetTime

   }

   convenience init() {
      self.init(workoutExerciseSetId: nil, workoutExerciseId: nil,
                workoutId: nil, workoutExerciseSetReps: nil, workoutExerciseSetWeight: nil,
                workoutExerciseSetDate: nil, workoutExerciseSetTime: nil)
   }

}

extension WorkoutExerciseSet : Equatable {

   public static func == (lhs: WorkoutExerciseSet, rhs: WorkoutExerciseSet) -> Bool {
      return lhs.workoutExerciseId == rhs.workoutExerciseId
   }

}




