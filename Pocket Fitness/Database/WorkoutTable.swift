import Foundation
import SQLite

public enum WorkoutError : Error {
   case insertionError
   case retrievalError
   case updateError
}

public class WorkoutTable {
   public static func insertNewWorkout() throws -> Workout  {
      guard let dbConnection = AppDatabase.getConnection() else {
         throw DatabaseError.databaseConnectionError
      }

      guard let userId = UserSession.getUserId() else {
         throw UserError.userNotFound
      }

      do {
         let workoutTable = AppDatabase.workoutTable
         let workoutDateColumn = AppDatabase.workoutDateColumn
         let userIdColumn = AppDatabase.userIdColumn
         let workoutDate = Date()
         let insertWorkoutQuery = workoutTable.insert(workoutDateColumn <- workoutDate,
                                                      userIdColumn <- userId)
         let rowid = try dbConnection.run(insertWorkoutQuery)

         let workout = Workout()
         workout.workoutId = rowid
         workout.workoutDate = workoutDate
         


         return workout
      } catch {
         throw WorkoutError.insertionError
      }
   }

   public static func getAllWorkouts() throws -> [Workout] {
      var workouts : [Workout] = [Workout]()

      guard let dbConnection = AppDatabase.getConnection() else {
         throw DatabaseError.databaseConnectionError
      }

      guard let userId = UserSession.getUserId() else {
         throw UserError.userNotFound
      }

      let workoutTable = AppDatabase.workoutTable
      let workoutDateColumn = AppDatabase.workoutDateColumn
      let userIdColumn = AppDatabase.userIdColumn
      let workoutIdColumn = AppDatabase.workoutIdColumn
      let workoutNameColumn = AppDatabase.workoutNameColumn
      let workoutNotesColumn = AppDatabase.workoutNotesColumn
      let workoutUserWeightColumn = AppDatabase.workoutUserWeightColumn

      let getWorkoutQuery = workoutTable.filter(userIdColumn == userId).order(workoutDateColumn.desc)
      do {
         for workout in try dbConnection.prepare(getWorkoutQuery) {
            do {
               let workoutId = workout[workoutIdColumn].datatypeValue
               let workoutName = try workout.get(workoutNameColumn)?.datatypeValue
               let workoutDateString = try workout.get(workoutDateColumn).description
               let workoutDate = Date.getDateFromString(date: workoutDateString)
               let workoutNotes = try workout.get(workoutNotesColumn)?.datatypeValue
               let workoutUserWeight = try workout.get(workoutUserWeightColumn)?.datatypeValue
               let newWorkout = Workout(workoutId: workoutId, workoutName: workoutName, workoutDate: workoutDate,
                                        workoutNotes: workoutNotes, userWeight: workoutUserWeight)
               workouts.append(newWorkout)
            } catch {
               throw WorkoutError.retrievalError
            }
         }
      } catch {
         throw WorkoutError.retrievalError
      }
      return workouts
   }

   public static func updateExistingWorkout(workout : Workout) throws {
      guard let dbConnection = AppDatabase.getConnection() else {
         throw DatabaseError.databaseConnectionError
      }

      guard let userId = UserSession.getUserId() else {
         throw UserError.userNotFound
      }

      let workoutTable = AppDatabase.workoutTable
      let userIdColumn = AppDatabase.userIdColumn
      let workoutIdColumn = AppDatabase.workoutIdColumn
      let workoutNameColumn = AppDatabase.workoutNameColumn
      let workoutDateColumn = AppDatabase.workoutDateColumn
      let workoutNotescolumn = AppDatabase.workoutNotesColumn

      let workoutName = workout.workoutName == nil ? "" : workout.workoutName!
      let workoutDate = workout.workoutDate!
      let workoutNotes = workout.workoutNotes == nil ? "" : workout.workoutNotes!

      let retrievedWorkout = workoutTable.filter(userIdColumn == userId &&
         workoutIdColumn == workout.workoutId!)

      do {
         try dbConnection.run(retrievedWorkout.update(workoutNameColumn <- workoutName,
                                                      workoutNotescolumn <- workoutNotes,
                                                      workoutDateColumn <- workoutDate))
      } catch {
         throw WorkoutError.updateError
      }
   }
}
