import Foundation

public class WorkoutsTableViewModel {
   var workoutTableViewCellsModel : [WorkoutTableViewCellModel]?

   init()   {
      workoutTableViewCellsModel = [WorkoutTableViewCellModel]()
   }

   func addWorkoutInformation(workoutInformation : WorkoutTableViewCellModel)   {
      workoutTableViewCellsModel?.append(workoutInformation)
   }

   public static func getWorkoutTableViewModel() throws -> WorkoutsTableViewModel?   {
      do {
         let workouts = try WorkoutTable.getAllWorkouts()
         let workoutTableViewModel = WorkoutsTableViewModel()
         for workout in workouts {
            let exercisesAmount = try ExerciseTable.getExerciseCountForWorkout(workout: workout)
            let workoutTableViewCellModel = WorkoutTableViewCellModel()
            if exercisesAmount != nil {
               workoutTableViewCellModel.setWorkoutInformation(workout: workout, labelText: "\(exercisesAmount!)")
            } else {
               workoutTableViewCellModel.setWorkoutInformation(workout: workout, labelText: "0")
            }
            workoutTableViewModel.addWorkoutInformation(workoutInformation: workoutTableViewCellModel)
         }
         return workoutTableViewModel
      } catch {
         throw WorkoutError.retrievalError
      }
   }

}

public class WorkoutTableViewCellModel {
   var workout : Workout?
   var labelText : String?

   func setWorkoutInformation(workout : Workout, labelText : String)  {
      self.workout = workout
      self.labelText = labelText
   }

}

