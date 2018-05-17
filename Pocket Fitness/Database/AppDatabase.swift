import Foundation
import SQLite

// Defines all the database tables and columns
public class AppDatabase {

   static let exerciseTable = Table(exerciseTableName)
   static let exerciseIdColumn = Expression<Int64>(exerciseIdColumnName)
   static let exerciseNameColumn = Expression<String>(exerciseNameColumnName)
   static let exerciseTypeColumn = Expression<String>(exerciseTypeColumnName)
   static let exerciseMuscleColumn = Expression<String>(exerciseMuscleColumnName)
   static let userIdColumn = Expression<Int64>(userIdColumnName)

   static let userTable = Table(userTableName)
   static let facebookIdColumn = Expression<String>(facebookIdColumnName)
   static let firstNameColumn = Expression<String?>(firstNameColumnName)
   static let lastNameColumn = Expression<String?>(lastNameColumnName)
   static let emailColumn = Expression<String?>(emailColumnName)
   static let weightColumn = Expression<Double?>(weightColumnName)
   static let createdAtColumn = Expression<Date>(createdAtColumnName)

   static let workoutTable = Table(workoutTableName)
   static let workoutIdColumn = Expression<Int64>(workoutIdColumnName)
   static let workoutNameColumn = Expression<String?>(workoutNameColumnName)
   static let workoutDateColumn = Expression<Date>(workoutDateColumnName)
   static let workoutNotesColumn = Expression<String?>(workoutNotesColumnName)
   static let workoutUserWeightColumn = Expression<Double?>(workoutUserWeightColumnName)

   static let workoutExerciseTable = Table(workoutExerciseTableName)
   static let workoutExerciseIdColumn = Expression<Int64>(workoutExerciseIdColumnName)
   static let workoutExerciseDateColumn = Expression<Date>(workoutExerciseDateColumnName)

   static let workoutExerciseSetTable = Table(workoutExerciseSetTableName)
   static let workoutExerciseSetIdColumn = Expression<Int64>(workoutExerciseSetIdColumnName)
   static let workoutExerciseSetRepsColumn = Expression<Int?>(workoutExerciseSetRepsColumnName)
   static let workoutExerciseSetWeightColumn = Expression<Double?>(workoutExerciseSetWeightColumnName)
   static let workoutExerciseSetTimeColumn = Expression<Double?>(workoutExerciseSetTimeColumnName)
   static let workoutExerciseSetDateColumn = Expression<Date>(workoutExerciseSetDateColumnName)

   public static func getConnection() -> Connection? {

      do {
         let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
         let dbConnection = try Connection("\(path)/db.sqlite3")
         return dbConnection
      } catch {
         return nil
      }

   }

   public static func setUpSchema() throws {
      guard let dbConnection = AppDatabase.getConnection() else {
         throw DatabaseError.databaseConnectionError
      }

      do {
         try dbConnection.run(exerciseTable.create(ifNotExists: true) { exerciseTable in
            exerciseTable.column(exerciseIdColumn, primaryKey: true)
            exerciseTable.column(exerciseNameColumn, unique: true)
            exerciseTable.column(exerciseTypeColumn)
            exerciseTable.column(exerciseMuscleColumn)
            exerciseTable.column(userIdColumn)
         })
      } catch {
         throw DatabaseError.databaseSetupError
      }

      do {
         try dbConnection.run(userTable.create(ifNotExists: true) { userTable in
            userTable.column(userIdColumn, primaryKey: true)
            userTable.column(facebookIdColumn, unique: true)
            userTable.column(firstNameColumn, defaultValue: nil)
            userTable.column(lastNameColumn, defaultValue: nil)
            userTable.column(emailColumn, defaultValue: nil)
            userTable.column(weightColumn, defaultValue: nil)
            userTable.column(createdAtColumn)
         })
      } catch {
         throw DatabaseError.databaseSetupError
      }

      do {

         try dbConnection.run(workoutTable.create(ifNotExists: true) { workoutTable in
            workoutTable.column(workoutIdColumn, primaryKey: true)
            workoutTable.column(workoutNameColumn, defaultValue: nil)
            workoutTable.column(workoutDateColumn)
            workoutTable.column(workoutNotesColumn, defaultValue: nil)
            workoutTable.column(workoutUserWeightColumn, defaultValue: nil)
            workoutTable.column(userIdColumn)
         })
      } catch {
         throw DatabaseError.databaseSetupError
      }

      do {

         try dbConnection.run(workoutExerciseTable.create(ifNotExists: true) { workoutExerciseTable in
            workoutExerciseTable.column(workoutExerciseIdColumn, primaryKey: true)
            workoutExerciseTable.column(workoutIdColumn)
            workoutExerciseTable.column(exerciseIdColumn)
            workoutExerciseTable.column(workoutExerciseDateColumn)
            workoutExerciseTable.column(userIdColumn)
         })
      } catch {
         throw DatabaseError.databaseSetupError
      }

      do {
         try dbConnection.run(workoutExerciseSetTable.create(ifNotExists: true) { workoutExerciseSetTable in
            workoutExerciseSetTable.column(workoutExerciseSetIdColumn, primaryKey: true)
            workoutExerciseSetTable.column(workoutExerciseSetRepsColumn)
            workoutExerciseSetTable.column(workoutExerciseSetWeightColumn)
            workoutExerciseSetTable.column(workoutExerciseSetTimeColumn)
            workoutExerciseSetTable.column(workoutExerciseSetDateColumn)
            workoutExerciseSetTable.column(workoutExerciseIdColumn)
            workoutExerciseSetTable.column(workoutIdColumn)
            workoutExerciseSetTable.column(userIdColumn)
         })
      } catch {
         throw DatabaseError.databaseSetupError
      }

   }

   public static func dropEntireDatabase() throws  {
      guard let dbConnection = AppDatabase.getConnection() else {
         throw DatabaseError.databaseConnectionError
      }

      do {
         try dbConnection.run(exerciseTable.drop(ifExists: true))
         try dbConnection.run(userTable.drop(ifExists: true))
         try dbConnection.run(workoutTable.drop(ifExists: true))
         try dbConnection.run(workoutExerciseTable.drop(ifExists: true))
         try dbConnection.run(workoutExerciseSetTable.drop(ifExists: true))

      } catch {
         throw DatabaseError.databaseDropError
      }
   }

}

// Declare all app database table and column names below
extension AppDatabase {
   static let workoutExerciseSetTableName = "WorkoutExerciseSet"
   static let workoutExerciseSetIdColumnName = "workoutExerciseSetId"
   static let workoutExerciseSetRepsColumnName = "workoutExerciseSetReps"
   static let workoutExerciseSetWeightColumnName = "workoutExerciseSetWeight"
   static let workoutExerciseSetTimeColumnName = "workoutExerciseSetTime"
   static let workoutExerciseSetDateColumnName = "workoutExerciseSetDate"

   static let workoutExerciseTableName = "WorkoutExercise"
   static let workoutExerciseIdColumnName = "workoutExerciseId"
   static let workoutExerciseDateColumnName = "workoutExerciseDate"

   static let userTableName = "User"
   static let userIdColumnName = "userId"
   static let facebookIdColumnName = "facebookId"
   static let firstNameColumnName = "firstName"
   static let lastNameColumnName = "lastName"
   static let emailColumnName = "email"
   static let weightColumnName = "weight"
   static let createdAtColumnName = "createdAt"

   static let workoutTableName = "Workout"
   static let workoutIdColumnName = "workoutId"
   static let workoutNameColumnName = "workoutName"
   static let workoutDateColumnName = "workoutDate"
   static let workoutNotesColumnName = "workoutNotes"
   static let workoutUserWeightColumnName = "workoutUserWeight"

   static let exerciseTableName = "Exercise"
   static let exerciseIdColumnName = "exerciseId"
   static let exerciseNameColumnName = "exerciseName"
   static let exerciseTypeColumnName = "exerciseType"
   static let exerciseMuscleColumnName = "exerciseMuscle"

}

public enum DatabaseError : Error {
   case databaseConnectionError
   case databaseSetupError
   case databaseDropError
}
