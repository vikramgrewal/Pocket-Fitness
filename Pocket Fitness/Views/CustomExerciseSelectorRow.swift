import UIKit
import Eureka

class ExercisePushViewController: SelectorViewController<SelectorRow<PushSelectorCell<Exercise>>> {

   var exercises : [Exercise]?

   override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
   }

   override func viewDidLoad() {
      super.viewDidLoad()
   }

   override func viewWillAppear(_ animated: Bool) {
      fetchExercises()
   }

   func fetchExercises()   {
      do {
         exercises = try ExerciseTable.getAllExercises()
         setupForm(with: exercises!)
      } catch {
         exercises = [Exercise]()
      }
   }

}
