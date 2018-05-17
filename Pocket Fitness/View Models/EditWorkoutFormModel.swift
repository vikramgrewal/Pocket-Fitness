import Foundation

public class EditWorkoutFormModel {
   var editWorkoutFormSections : [EditWorkoutFormSectionModel]?

   init()   {
      editWorkoutFormSections = [EditWorkoutFormSectionModel]()
   }
}

public class EditWorkoutFormSectionModel {
   var workoutExercise : WorkoutExercise?
   var exercise : Exercise?
   var workoutExerciseSets : [WorkoutExerciseSet]?

   init() {

   }
}
