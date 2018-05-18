import Foundation
import SQLite

public class Exercise {

   var exerciseId : Int64?
   var exerciseName : String?
   var exerciseType : String?
   var exerciseMuscle : String?
   var userId : Int64?


   init(exerciseId : Int64?, exerciseName : String?, exerciseType : String?, exerciseMuscle : String?, userId : Int64?)   {
      self.exerciseId = exerciseId
      self.exerciseName = exerciseName
      self.exerciseType = exerciseType
      self.exerciseMuscle = exerciseMuscle
      self.userId = userId
   }

   convenience init() {
      self.init(exerciseId: nil, exerciseName: nil,
                exerciseType: nil, exerciseMuscle: nil, userId: nil)
   }

}

extension Exercise : Equatable, CustomStringConvertible {
   public var description: String {
      return exerciseName!
   }


   public static func == (lhs: Exercise, rhs: Exercise) -> Bool {
      return lhs.exerciseId == rhs.exerciseId
   }

}

