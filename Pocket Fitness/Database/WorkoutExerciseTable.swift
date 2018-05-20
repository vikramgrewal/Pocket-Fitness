import Foundation
import SQLite

public class WorkoutExerciseTable {

   public static func getWorkoutExercisesCountForWorkoutId(workoutId : Int64) throws -> Int? {

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

   public static func getWorkoutExercisesForWorkoutId(workoutId : Int64) throws -> [WorkoutExercise]? {

      var workoutExercises : [WorkoutExercise] = [WorkoutExercise]()

      guard let dbConnection = AppDatabase.getConnection() else {
         throw DatabaseError.databaseConnectionError
      }

      guard let userId = UserSession.getUserId() else {
         throw UserError.userNotFound
      }

      let workoutExerciseTable = AppDatabase.workoutExerciseTable
      let workoutIdColumn = AppDatabase.workoutIdColumn
      let userIdColumn = AppDatabase.userIdColumn
      let workoutExerciseDateColumn = AppDatabase.workoutExerciseDateColumn
      let workoutExerciseIdColumn = AppDatabase.workoutExerciseIdColumn
      let exerciseIdColumn = AppDatabase.exerciseIdColumn

      let getWorkoutExercisesQuery = workoutExerciseTable.filter(userIdColumn == userId
         && workoutIdColumn == workoutId).order(workoutExerciseDateColumn.asc)
      do {
         for workoutExercise in try dbConnection.prepare(getWorkoutExercisesQuery) {
            do {
               let workoutExerciseId = try workoutExercise.get(workoutExerciseIdColumn).datatypeValue
               let exerciseId = try workoutExercise.get(exerciseIdColumn).datatypeValue
               let workoutExerciseDate = try workoutExercise.get(workoutExerciseDateColumn).datatypeValue
               let workoutExercise = WorkoutExercise()
               workoutExercise.exerciseId = exerciseId
               workoutExercise.workoutExerciseDate = Date.getDateFromString(date: workoutExerciseDate)
               workoutExercise.workoutExerciseId = workoutExerciseId
               workoutExercise.workoutId = workoutId
               workoutExercises.append(workoutExercise)
            } catch {
               throw WorkoutExerciseError.retrievalError
            }
         }
      } catch {
         throw WorkoutExerciseError.retrievalError
      }
      return workoutExercises
   }

   public static func insertNewWorkoutExercise(workoutId : Int64, exerciseId : Int64) throws -> WorkoutExercise?  {
      guard let dbConnection = AppDatabase.getConnection() else {
         throw DatabaseError.databaseConnectionError
      }

      guard let userId = UserSession.getUserId() else {
         throw UserError.userNotFound
      }

      do {
         let workoutExerciseTable = AppDatabase.workoutExerciseTable
         let workoutIdColumn = AppDatabase.workoutIdColumn
         let exerciseIdColumn = AppDatabase.exerciseIdColumn
         let userIdColumn = AppDatabase.userIdColumn
         let workoutExerciseDateColumn = AppDatabase.workoutExerciseDateColumn

         let workoutExerciseDate = Date()

         let insertWorkoutExerciseQuery = workoutExerciseTable.insert(
            workoutExerciseDateColumn <- workoutExerciseDate, userIdColumn <- userId,
            exerciseIdColumn <- exerciseId, workoutIdColumn <- workoutId)

         let rowid = try dbConnection.run(insertWorkoutExerciseQuery)

         let workoutExercise = WorkoutExercise()
         workoutExercise.workoutId = workoutId
         workoutExercise.exerciseId = exerciseId
         workoutExercise.workoutExerciseDate = workoutExerciseDate
         workoutExercise.workoutExerciseId = rowid

         return workoutExercise
      } catch {
         throw WorkoutExerciseError.insertionError
      }
   }

}

public enum WorkoutExerciseError : Error {
   case retrievalError
   case insertionError
}
