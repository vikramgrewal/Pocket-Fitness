import Foundation
import SQLite

public class WorkoutFormModel {
   var workoutFormSectionModels : [WorkoutFormSectionModel]?

   init(workoutId : Int64)   {
      do {
         try getFormModel(workoutId: workoutId)
      } catch {
         workoutFormSectionModels = [WorkoutFormSectionModel]()
      }
   }

   func getFormModel(workoutId : Int64) throws {
      do {
         guard let workoutExercises = try WorkoutExerciseTable.getWorkoutExercisesForWorkoutId(workoutId: workoutId) else {
            workoutFormSectionModels = [WorkoutFormSectionModel]()
            return
         }
         workoutFormSectionModels = [WorkoutFormSectionModel]()
         for workoutExercise in workoutExercises {
            let workoutFormSectionModel = WorkoutFormSectionModel()
            workoutFormSectionModel.workoutExercise = workoutExercise
            do {
               guard let exerciseId = workoutExercise.exerciseId else {
                  return
               }

               guard let workoutExerciseId = workoutExercise.workoutExerciseId else {
                  return
               }
               let exercise = try ExerciseTable.getExerciseForId(exerciseId: exerciseId)
               workoutFormSectionModel.exercise = exercise
               let workoutExerciseSets = try WorkoutExerciseSetTable.getAllWorkoutSets(workoutExerciseId: workoutExerciseId)
               workoutFormSectionModel.workoutExerciseSets = workoutExerciseSets
               workoutFormSectionModels?.append(workoutFormSectionModel)
            } catch {
               print(error)
            }
         }
      } catch {
         print(error)
      }
   }
}

public class WorkoutFormSectionModel {
   var workoutExercise : WorkoutExercise?
   var exercise : Exercise?
   var workoutExerciseSets : [WorkoutExerciseSet]?
}
