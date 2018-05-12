import Foundation

public class Exercise {

   var exerciseId : Int64? // Primary key
   var exerciseName : String? // Unique
   var exerciseType : String?
   var exerciseMuscle : String?
   var userId : Int64? // Foreign key

   init(exerciseId : Int64?, exerciseName : String?, exerciseType : String?, exerciseMuscle : String?, userId : Int64?)   {
      self.exerciseId = exerciseId
      self.exerciseName = exerciseName
      self.exerciseType = exerciseType
      self.exerciseMuscle = exerciseMuscle
      self.userId = userId
   }

}

extension Exercise : Equatable {

   public static func == (lhs: Exercise, rhs: Exercise) -> Bool {
      return lhs.exerciseName == rhs.exerciseName
   }

}


// Take care of all database fetching below
extension Exercise {

   public static func getAllExercises() -> [Exercise] {
      print("Fetching all exercises")
      return [Exercise]()
   }

}
