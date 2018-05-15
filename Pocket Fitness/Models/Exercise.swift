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

   init(exerciseName : String?, exerciseType : String?, exerciseMuscle : String?) {
      self.exerciseName = exerciseName
      self.exerciseType = exerciseType
      self.exerciseMuscle = exerciseMuscle
   }

}

extension Exercise : Equatable {

   public static func == (lhs: Exercise, rhs: Exercise) -> Bool {
      return lhs.exerciseId == rhs.exerciseId
   }

}


// Take care of all database fetching below
extension Exercise {


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
                     let exerciseToInsert = Exercise(exerciseName: exerciseName,
                                                     exerciseType: exerciseType, exerciseMuscle: exerciseMuscle)


                     Exercise.tryToInsert(exercise: exerciseToInsert)

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

      guard let userId = User.getUserIdForSession() else {
         print("No user id found for user")
         return
      }

      let userIdColumn = Expression<Int64>(User.userIdColumn)
      let exerciseNameColumn = Expression<String>(Exercise.exerciseNameColumn)
      let exerciseMuscleColumn = Expression<String>(Exercise.exerciseMuscleColumn)
      let exerciseTypeColumn = Expression<String>(Exercise.exerciseTypeColumn)
      let exerciseTable = Table(Exercise.exerciseTableName)


      do {

         let selectExerciseQuery  = try exerciseTable.filter(exerciseNameColumn == exerciseName && userIdColumn == userId)
         let fetchedExercise = Array<SQLite.Row>(try dbConnection.prepare(selectExerciseQuery))
         guard fetchedExercise.count == 0 else {
            return
         }
         let insertQuery = try exerciseTable.insert(userIdColumn <- userId, exerciseNameColumn <- exerciseName,
                                                exerciseMuscleColumn <- exerciseMuscle, exerciseTypeColumn <- exerciseType)
         try dbConnection.run(insertQuery)
      } catch {
         print(error.localizedDescription)
      }

      
   }

   public static func saveNewExercise(exercise : Exercise) throws  {
      guard let exerciseMuscle = exercise.exerciseMuscle else {
         print("Error retrieving exercise muscle")
         throw ExerciseError.fieldsNotValid
      }
      guard let exerciseType = exercise.exerciseType else {
         print("Error retrieving exercise type")
         throw ExerciseError.fieldsNotValid
      }
      guard let exerciseName = exercise.exerciseName else {
         print("Error retrieving exercise name")
         throw ExerciseError.fieldsNotValid
      }

      guard let dbConnection = AppDatabase.getConnection() else {
         print("Error establishing connection")
         throw ExerciseError.databaseConnectionError
      }

      guard let userId = User.getUserIdForSession() else {
         print("No user id found for user")
         throw UserError.userNotFound
      }

      let userIdColumn = Expression<Int64>(User.userIdColumn)
      let exerciseNameColumn = Expression<String>(Exercise.exerciseNameColumn)
      let exerciseMuscleColumn = Expression<String>(Exercise.exerciseMuscleColumn)
      let exerciseTypeColumn = Expression<String>(Exercise.exerciseTypeColumn)
      let exerciseTable = Table(Exercise.exerciseTableName)


      do {

         let selectExerciseQuery  = try exerciseTable.filter(exerciseNameColumn == exerciseName && userIdColumn == userId)
         let fetchedExercise = Array<SQLite.Row>(try dbConnection.prepare(selectExerciseQuery))
         guard fetchedExercise.count == 0 else {
            throw ExerciseError.duplicateError
         }
         let insertQuery = try exerciseTable.insert(userIdColumn <- userId, exerciseNameColumn <- exerciseName,
                                                    exerciseMuscleColumn <- exerciseMuscle, exerciseTypeColumn <- exerciseType)
         try dbConnection.run(insertQuery)
         print("Successfully saved exercise for user: \(userId)")
      } catch {
         print(error.localizedDescription)
         throw DatabaseError.databaseError
      }


   }

   public static func getAllExercises() throws -> [Exercise]? {
      var exercises : [Exercise] = [Exercise]()

      guard let dbConnection = AppDatabase.getConnection() else {
         print("Error establishing database connection")
         throw DatabaseError.databaseError
      }

      guard let userId = User.getUserIdForSession() else {
         throw UserError.userNotFound
      }

      let exerciseTable = Table(Exercise.exerciseTableName)
      let exerciseIdColumn = Expression<Int64>(Exercise.exerciseIdColumn)
      let exerciseNameColumn = Expression<String>(Exercise.exerciseNameColumn)
      let exerciseMuscleColumn = Expression<String>(Exercise.exerciseMuscleColumn)
      let exerciseTypeColumn = Expression<String>(Exercise.exerciseTypeColumn)
      let userIdColumn = Expression<Int64>(User.userIdColumn)
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
               print("Encountered issue with one of the exercises")
            }
         }
      } catch {
         return nil
      }
      return exercises
   }

   public static func updateExistingExercise(exercise : Exercise) throws {

      guard let dbConnection = AppDatabase.getConnection() else {
         print("Error establishing database connection")
         throw DatabaseError.databaseError
      }

      guard let userId = User.getUserIdForSession() else {
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

      let exerciseTable = Table(Exercise.exerciseTableName)
      let exerciseIdColumn = Expression<Int64>(Exercise.exerciseIdColumn)
      let exerciseNameColumn = Expression<String>(Exercise.exerciseNameColumn)
      let exerciseMuscleColumn = Expression<String>(Exercise.exerciseMuscleColumn)
      let exerciseTypeColumn = Expression<String>(Exercise.exerciseTypeColumn)
      let userIdColumn = Expression<Int64>(User.userIdColumn)
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
         print(error.localizedDescription)
      }
   }

   public static func deleteExercise(exercise : Exercise) throws {

      guard let dbConnection = AppDatabase.getConnection() else {
         print("Error establishing database connection")
         throw DatabaseError.databaseError
      }

      guard let userId = User.getUserIdForSession() else {
         throw UserError.userNotFound
      }

      guard let exerciseId = exercise.exerciseId else {
         throw ExerciseError.fieldsNotValid
      }

      let exerciseTable = Table(Exercise.exerciseTableName)
      let exerciseIdColumn = Expression<Int64>(Exercise.exerciseIdColumn)
      let userIdColumn = Expression<Int64>(User.userIdColumn)
      let retrievedExercise = exerciseTable.filter(exerciseIdColumn == exerciseId && userIdColumn == userId)
      do {
         try dbConnection.run(retrievedExercise.delete())
      } catch {
         print(error.localizedDescription)
      }
   }

}

enum ExerciseError: Error {
   case duplicateError
   case databaseConnectionError
   case fieldsNotValid
}
