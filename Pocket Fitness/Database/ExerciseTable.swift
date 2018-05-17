import Foundation
import SQLite

enum ExerciseError: Error {
   case duplicateError
   case databaseConnectionError
   case fieldsNotValid
   case insertionError
   case editError
   case saveError
   case retrieveError
   case updateError
}

public class ExerciseTable {
   public static func preloadExercises() {
      do {
         if let file = Bundle.main.url(forResource: "exercises", withExtension: "json") {
            let data = try Data(contentsOf: file)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : AnyObject]
            if let exercises = json["exercises"] {
               // json is a dictionary
               for index in 0...exercises.count - 1 {
                  do {
                     let exerciseObject = try exercises.objectAt(index) as! [String : AnyObject]
                     let exerciseName = try exerciseObject["name"] as! String
                     let exerciseMuscle = try exerciseObject["muscle"] as! String
                     let exerciseType = try exerciseObject["type"] as! String
                     let exerciseToInsert = Exercise()
                     exerciseToInsert.exerciseType = exerciseType
                     exerciseToInsert.exerciseMuscle = exerciseMuscle
                     exerciseToInsert.exerciseName = exerciseName

                     ExerciseTable.tryToInsert(exercise: exerciseToInsert)

                  } catch {
                     print(error.localizedDescription)
                  }
               }

            } else {
               print("JSON is invalid")
            }
         } else {
            print("no file")
         }
      } catch {
         print(error.localizedDescription)
      }
   }

   public static func tryToInsert(exercise : Exercise)   {
      guard let exerciseMuscle = exercise.exerciseMuscle else {
         print("Error retrieving exercise muscle")
         return
      }
      guard let exerciseType = exercise.exerciseType else {
         print("Error retrieving exercise type")
         return
      }
      guard let exerciseName = exercise.exerciseName else {
         print("Error retrieving exercise name")
         return
      }

      guard let dbConnection = AppDatabase.getConnection() else {
         print("Error establishing connection")
         return
      }

      guard let userId = UserSession.getUserId() else {
         print("No user id found for user")
         return
      }

      let exerciseTable = AppDatabase.exerciseTable
      let exerciseNameColumn = AppDatabase.exerciseNameColumn
      let userIdColumn = AppDatabase.userIdColumn
      let exerciseMuscleColumn = AppDatabase.exerciseMuscleColumn
      let exerciseTypeColumn = AppDatabase.exerciseTypeColumn


      do {

         let selectExerciseQuery  = exerciseTable.filter(exerciseNameColumn == exerciseName && userIdColumn == userId)
         let fetchedExercise = Array<SQLite.Row>(try dbConnection.prepare(selectExerciseQuery))
         guard fetchedExercise.count == 0 else {
            return
         }
         let insertQuery = exerciseTable.insert(userIdColumn <- userId, exerciseNameColumn <- exerciseName,
                                                    exerciseMuscleColumn <- exerciseMuscle, exerciseTypeColumn <- exerciseType)
         try dbConnection.run(insertQuery)
      } catch {
         print(error.localizedDescription)
      }


   }

   public static func saveNewExercise(exercise : Exercise) throws  {
      guard let exerciseMuscle = exercise.exerciseMuscle else {
         throw ExerciseError.fieldsNotValid
      }
      guard let exerciseType = exercise.exerciseType else {
         throw ExerciseError.fieldsNotValid
      }
      guard let exerciseName = exercise.exerciseName else {
         throw ExerciseError.fieldsNotValid
      }

      guard let dbConnection = AppDatabase.getConnection() else {
         throw ExerciseError.databaseConnectionError
      }

      guard let userId = UserSession.getUserId() else {
         throw UserError.userNotFound
      }

      do {

         let exerciseTable = AppDatabase.exerciseTable
         let exerciseNameColumn = AppDatabase.exerciseNameColumn
         let userIdColumn = AppDatabase.userIdColumn
         let exerciseMuscleColumn = AppDatabase.exerciseMuscleColumn
         let exerciseTypeColumn = AppDatabase.exerciseTypeColumn

         let selectExerciseQuery  = exerciseTable.filter(exerciseNameColumn == exerciseName && userIdColumn == userId)
         let fetchedExercise = Array<SQLite.Row>(try dbConnection.prepare(selectExerciseQuery))
         guard fetchedExercise.count == 0 else {
            throw ExerciseError.duplicateError
         }
         let insertQuery = exerciseTable.insert(userIdColumn <- userId, exerciseNameColumn <- exerciseName,
                                                    exerciseMuscleColumn <- exerciseMuscle, exerciseTypeColumn <- exerciseType)
         try dbConnection.run(insertQuery)
      } catch {
         throw ExerciseError.insertionError
      }


   }

   public static func getAllExercises() throws -> [Exercise]? {

      let exerciseTable = AppDatabase.exerciseTable
      let exerciseNameColumn = AppDatabase.exerciseNameColumn
      let userIdColumn = AppDatabase.userIdColumn
      let exerciseMuscleColumn = AppDatabase.exerciseMuscleColumn
      let exerciseTypeColumn = AppDatabase.exerciseTypeColumn
      let exerciseIdColumn = AppDatabase.exerciseIdColumn

      var exercises : [Exercise] = [Exercise]()

      guard let dbConnection = AppDatabase.getConnection() else {
         throw DatabaseError.databaseConnectionError
      }

      guard let userId = UserSession.getUserId() else {
         throw UserError.userNotFound
      }

      let getExerciseQuery = exerciseTable.filter(userIdColumn == userId).order(exerciseMuscleColumn, exerciseNameColumn.asc)
      do {
         for exercise in try dbConnection.prepare(getExerciseQuery) {
            do {
               let exerciseId = try exercise.get(exerciseIdColumn).datatypeValue
               let exerciseName = try exercise.get(exerciseNameColumn).datatypeValue
               let exerciseType = try exercise.get(exerciseTypeColumn).datatypeValue
               let exerciseMuscle = try exercise.get(exerciseMuscleColumn).datatypeValue
               let fetchedExercise = Exercise(exerciseId: exerciseId, exerciseName: exerciseName,
                                              exerciseType: exerciseType, exerciseMuscle: exerciseMuscle, userId: userId)
               exercises.append(fetchedExercise)
            } catch {
               throw ExerciseError.retrieveError
            }
         }
      } catch {
         throw ExerciseError.retrieveError
      }
      return exercises
   }

   public static func updateExistingExercise(exercise : Exercise) throws {

      guard let dbConnection = AppDatabase.getConnection() else {
         throw DatabaseError.databaseConnectionError
      }

      guard let userId = UserSession.getUserId() else {
         throw UserError.userNotFound
      }

      guard let exerciseId = exercise.exerciseId else {
         throw ExerciseError.fieldsNotValid
      }

      guard let exerciseName = exercise.exerciseName else {
         throw ExerciseError.fieldsNotValid
      }

      guard let exerciseMuscle = exercise.exerciseMuscle else {
         throw ExerciseError.fieldsNotValid
      }

      guard let exerciseType = exercise.exerciseType else {
         throw ExerciseError.fieldsNotValid
      }

      let exerciseTable = AppDatabase.exerciseTable
      let exerciseNameColumn = AppDatabase.exerciseNameColumn
      let userIdColumn = AppDatabase.userIdColumn
      let exerciseMuscleColumn = AppDatabase.exerciseMuscleColumn
      let exerciseTypeColumn = AppDatabase.exerciseTypeColumn
      let exerciseIdColumn = AppDatabase.exerciseIdColumn

      let retrievedExercise = exerciseTable.filter(exerciseIdColumn == exerciseId && userIdColumn == userId)
      let checkName = exerciseTable.filter(userIdColumn == userId && exerciseNameColumn == exerciseName && exerciseIdColumn != exerciseId)
      do {
         let rows = Array<SQLite.Row>(try dbConnection.prepare(checkName))
         guard rows.count == 0 else {
            throw ExerciseError.duplicateError
         }

         try dbConnection.run(retrievedExercise.update(exerciseNameColumn <- exerciseName,
                                                       exerciseMuscleColumn <- exerciseMuscle, exerciseTypeColumn <- exerciseType))
      } catch {
         throw ExerciseError.updateError
      }
   }

   public static func deleteExercise(exercise : Exercise) throws {

      guard let dbConnection = AppDatabase.getConnection() else {
         throw DatabaseError.databaseConnectionError
      }

      guard let userId = UserSession.getUserId() else {
         throw UserError.userNotFound
      }

      guard let exerciseId = exercise.exerciseId else {
         throw ExerciseError.fieldsNotValid
      }

      let exerciseTable = AppDatabase.exerciseTable
      let userIdColumn = AppDatabase.userIdColumn
      let exerciseIdColumn = AppDatabase.exerciseIdColumn

      let retrievedExercise = exerciseTable.filter(exerciseIdColumn == exerciseId && userIdColumn == userId)
      do {
         try dbConnection.run(retrievedExercise.delete())
      } catch {
         throw error
      }
   }
}
