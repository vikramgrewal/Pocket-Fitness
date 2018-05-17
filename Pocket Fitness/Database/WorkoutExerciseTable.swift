import Foundation
import SQLite

public class WorkoutExerciseTable {

   public static func getWorkoutExercisesForWorkoutId(workoutId : Int64) throws -> Int? {

      guard let dbConnection = AppDatabase.getConnection() else {
         throw DatabaseError.databaseConnectionError
      }

      let workoutExerciseTable = AppDatabase.workoutExerciseTable
      let workoutIdColumn = AppDatabase.workoutIdColumn

      do{
         let workoutExercisesQuery = workoutExerciseTable.filter(workoutIdColumn == workoutId)
         let fetchedExercises = Array<SQLite.Row>(try dbConnection.prepare(workoutExercisesQuery))
         return fetchedExercises.count
      } catch {
         throw WorkoutExerciseError.retrievalError
      }
   }
}

public enum WorkoutExerciseError : Error {
   case retrievalError
}
