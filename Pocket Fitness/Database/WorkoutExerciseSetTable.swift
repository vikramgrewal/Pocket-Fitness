import SQLite
import Foundation

public class WorkoutExerciseSetTable {

   public static func insertNewWorkoutSet(workoutId : Int64, workoutExerciseId : Int64,
                                          exerciseId : Int64) throws -> Int64? {
      guard let dbConnection = AppDatabase.getConnection() else {
         throw DatabaseError.databaseConnectionError
      }

      guard let userId = UserSession.getUserId() else {
         throw UserError.userNotFound
      }

      do {
         let workoutExerciseSetTable = AppDatabase.workoutExerciseSetTable
         let workoutExerciseSetDateColumn = AppDatabase.workoutExerciseSetDateColumn
         let userIdColumn = AppDatabase.userIdColumn
         let exerciseIdColumn = AppDatabase.exerciseIdColumn
         let workoutIdColumn = AppDatabase.workoutIdColumn
         let workoutExerciseIdColumn = AppDatabase.workoutExerciseIdColumn
         let workoutExerciseSetDate = Date()
         let insertWorkoutExerciseSetQuery = workoutExerciseSetTable.insert(
            workoutExerciseSetDateColumn <- workoutExerciseSetDate,
            userIdColumn <- userId, workoutExerciseIdColumn <- workoutExerciseId,
            exerciseIdColumn <- exerciseId, workoutIdColumn <- workoutId)
         let rowid = try dbConnection.run(insertWorkoutExerciseSetQuery)

         return rowid
      } catch {
         throw WorkoutError.insertionError
      }
   }

   public static func getAllWorkoutSets(workoutExerciseId : Int64) throws -> [WorkoutExerciseSet]? {

      var workoutExerciseSets : [WorkoutExerciseSet] = [WorkoutExerciseSet]()

      guard let dbConnection = AppDatabase.getConnection() else {
         throw DatabaseError.databaseConnectionError
      }

      guard let userId = UserSession.getUserId() else {
         throw UserError.userNotFound
      }

      let workoutExerciseSetTable = AppDatabase.workoutExerciseSetTable
      let workoutExerciseSetIdColumn = AppDatabase.workoutExerciseSetIdColumn
      let userIdColumn = AppDatabase.userIdColumn
      let workoutExerciseIdColumn = AppDatabase.workoutExerciseIdColumn
      let workoutExerciseSetDateColumn = AppDatabase.workoutExerciseSetDateColumn
      let exerciseIdColumn = AppDatabase.exerciseIdColumn
      let workoutIdColumn = AppDatabase.workoutIdColumn
      let workoutExerciseSetRepsColumn = AppDatabase.workoutExerciseSetRepsColumn
      let workoutExerciseSetWeightColumn = AppDatabase.workoutExerciseSetWeightColumn

      let getWorkoutExerciseSetsQuery = workoutExerciseSetTable.filter(userIdColumn == userId
         && workoutExerciseIdColumn == workoutExerciseId).order(workoutExerciseSetDateColumn.asc)
      do {
         for workoutExerciseSet in try dbConnection.prepare(getWorkoutExerciseSetsQuery) {
            do {
               let workoutExerciseId = try workoutExerciseSet.get(workoutExerciseIdColumn).datatypeValue
               let exerciseId = try workoutExerciseSet.get(exerciseIdColumn).datatypeValue
               let workoutExerciseSetDate = try workoutExerciseSet.get(workoutExerciseSetDateColumn).datatypeValue
               let workoutExerciseSetId = try workoutExerciseSet.get(workoutExerciseSetIdColumn).datatypeValue
               let workoutId = try workoutExerciseSet.get(workoutIdColumn).datatypeValue
               let workoutExerciseSetReps = try workoutExerciseSet.get(workoutExerciseSetRepsColumn)?.distance(to: 0)
               let workoutExerciseSetWeight = try workoutExerciseSet.get(workoutExerciseSetWeightColumn)?.datatypeValue
               let workoutExerciseSet = WorkoutExerciseSet()
               workoutExerciseSet.workoutExerciseId = workoutExerciseId
               workoutExerciseSet.workoutExerciseSetId = workoutExerciseSetId
               workoutExerciseSet.workoutId = workoutId
               workoutExerciseSet.workoutExerciseSetReps = workoutExerciseSetReps
               workoutExerciseSet.workoutExerciseSetDate = Date.getDateFromString(date: workoutExerciseSetDate)
               workoutExerciseSet.exerciseId = exerciseId
               workoutExerciseSet.workoutExerciseSetWeight = workoutExerciseSetWeight
               workoutExerciseSets.append(workoutExerciseSet)
            } catch {
               throw WorkoutExerciseError.retrievalError
            }
         }
      } catch {
         throw WorkoutExerciseSetError.retrievalError
      }

      return workoutExerciseSets
   }

   public static func updateExistingWorkoutSet(workoutExerciseSetId : Int64, weightLifted : Double,
                                               reps : Int) -> Bool {

      guard let dbConnection = AppDatabase.getConnection() else {
         return false
      }

      guard let userId = UserSession.getUserId() else {
         return false
      }

      let workoutExerciseSetWeight = weightLifted
      let workoutExerciseSetReps = reps

      let workoutExerciseSetTable = AppDatabase.workoutExerciseSetTable
      let userIdColumn = AppDatabase.userIdColumn
      let workoutExerciseSetIdColumn = AppDatabase.workoutExerciseSetIdColumn
      let workoutExerciseSetRepsColumn = AppDatabase.workoutExerciseSetRepsColumn
      let workoutExerciseSetWeightColumn = AppDatabase.workoutExerciseSetWeightColumn


      let retrievedWorkoutExerciseSet = workoutExerciseSetTable.filter(userIdColumn == userId
      && workoutExerciseSetIdColumn == workoutExerciseSetId)
      do {
         try dbConnection.run(retrievedWorkoutExerciseSet.update(
            workoutExerciseSetWeightColumn <- workoutExerciseSetWeight,
            workoutExerciseSetRepsColumn <- workoutExerciseSetReps))
         return true
      } catch {
         return false
      }
   }

}

public enum WorkoutExerciseSetError : Error {
   case retrievalError
}
