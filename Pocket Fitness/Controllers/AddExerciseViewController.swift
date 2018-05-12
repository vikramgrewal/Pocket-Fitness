import UIKit
import Eureka

class AddExerciseViewController: FormViewController {

   var exercise : Exercise?

    override func viewDidLoad() {
      super.viewDidLoad()
      setUpNavigation()
      setView()
      // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   func setUpNavigation()  {
      navigationController?.navigationBar.barStyle = .default

      let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
      navigationItem.rightBarButtonItem = saveButton
      let rightBarOffset = UIOffset(horizontal: -16.0, vertical: 0.0)
      navigationItem.rightBarButtonItem?.setTitlePositionAdjustment(rightBarOffset, for: .default)

      navigationItem.rightBarButtonItem?.action = #selector(saveExercise)
   }

   func setView() {
      view.backgroundColor = .white
      setForm()
      guard exercise != nil else {
         return
      }
      addDeleteButton()
   }

   func setForm() {
      form +++
         Section("Exercise")
         <<< TextRow(){ row in
            row.placeholder = "Exercise Name"
            row.tag = "exerciseNameRow"
            guard let exerciseName = exercise?.exerciseName else {
               return
            }
            row.value = exerciseName
         }
         <<< TextRow(){ row in
            row.placeholder = "Exercise Muscle Group"
            row.tag = "exerciseCategoryRow"
            guard let exerciseMuscle = exercise?.exerciseMuscle else {
               return
            }
            row.value = exerciseMuscle
         }
         <<< PushRow<String>() { row in
            row.title = "Exercise Type"
            row.tag = "exerciseTypeRow"
            row.options = ["Cardio", "Strength"]
            row.cell.textLabel?.textColor = .red
            guard let exerciseType = exercise?.exerciseType else {
               return
            }
            row.value = exerciseType
         }
   }

   func addDeleteButton()  {
      let deleteButton = UIButton()
      deleteButton.setTitle("Delete Exercise", for: .normal)
      deleteButton.backgroundColor = UIColor(red: 246.0/255.0, green: 53.0/255.0, blue: 76.0/255.0, alpha: 1.0)
      view.addSubview(deleteButton)
      deleteButton.translatesAutoresizingMaskIntoConstraints = false
      let bottom = deleteButton.bottomAnchor.constraint(equalTo:
         view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
      let leading = deleteButton.leadingAnchor.constraint(equalTo:
         view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
      let trailing = deleteButton.trailingAnchor.constraint(equalTo:
         view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
      let height = NSLayoutConstraint.init(item: deleteButton, attribute: .height,
                                           relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                           multiplier: 1.0, constant: 50)
      let constraints = [bottom, leading, trailing, height]
      NSLayoutConstraint.activate(constraints)
   }

   @objc func saveExercise() {
      if exercise != nil {
         // TODO: Check to see if all fields are valid. Update all values for
         // this particular exerciseId. Once saved show alert in middle saying
         // saved. Pop this view controller off the navigation and go to the
         // previous screem.
      }  else {
         // TODO: Check to see if all fields are valid. Insert this new exercise
         // into the database.
      }
   }

   @objc func deleteExercise()   {
      // TODO: Hook up to delete button as action. Delete exercise from database.
      // If the popped navigation controller is of exercises view controller reload
      // the data in the previous controller. If it is not, that means it is the push view
      // controller, so reload that data, so the user can make the correct choice
   }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

