import Foundation
import SQLite

public class Exercise {

   var exerciseId : Int64? // Primary key
   var exerciseName : String? // Unique
   var exerciseType : String?
   var exerciseMuscle : String?
   var userId : Int64? // Foreign key

   static let exerciseTableName = "Exercise"
   static let exerciseIdColumn = "exerciseId"
   static let exerciseNameColumn = "exerciseName"
   static let exerciseTypeColumn = "exerciseType"
   static let exerciseMuscleColumn = "exerciseMuscle"

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
      let exercises = [Exercise]()
      return exercises
   }

   public static func preloadExerciseTable() {
      guard let dbConnection = AppDatabase.getConnection() else {
         print("Error establishing connection during dropping exercise table")
         return
      }

      let exerciseTable = Table(exerciseTableName)
   }

   public static func dropExerciseTable() {
      guard let dbConnection = AppDatabase.getConnection() else {
         print("Error establishing connection during dropping exercise table")
         return
      }

      let exerciseTable = Table(exerciseTableName)

      do {
         try dbConnection.run(exerciseTable.drop(ifExists: true))
         print("Dropping \(exerciseTableName) if does not exist")
      } catch {
         print("Error dropping Table(\"\(exerciseTableName))\"")
      }
   }

}
