import Foundation
import SQLite

public class Workout {
   var workoutId : Int64?
   var workoutName : String?
   var workoutDate : Date?
   var workoutNotes : String?
   var userWeight : Double?

   init(workoutId : Int64?, workoutName : String?, workoutDate: Date?,
      workoutNotes : String?, userWeight : Double?)   {
      self.workoutId = workoutId
      self.workoutName = workoutName
      self.workoutDate = workoutDate
      self.workoutNotes = workoutNotes
      self.userWeight = userWeight
   }

   convenience init() {
      self.init(workoutId: nil, workoutName: nil, workoutDate: nil,
                workoutNotes: nil, userWeight: nil)
   }
   
}
