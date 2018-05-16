import UIKit
import Eureka

class AddExerciseViewController: FormViewController {

   var exercise : Exercise?

    override func viewDidLoad() {
      super.viewDidLoad()
      setView()
      // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



   func setView() {
      view.backgroundColor = .white
      navigationAccessoryView.tintColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 141.0/255.0, alpha: 1.0)
      setUpNavigation()
      setForm()
      // Check if an exercise was passed and if so add the delete button to the view
      guard exercise != nil else {
         exercise = Exercise()
         return
      }
      addDeleteButton()
   }

   // Set up navigation bar buttons
   func setUpNavigation()  {
      navigationController?.navigationBar.barStyle = .default
      // Add navigation bar button with save display to save exercise
      let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveExercise))
      navigationItem.rightBarButtonItem = saveButton
      // Set offset from end to ensure easy pressing
      let rightBarOffset = UIOffset(horizontal: -16.0, vertical: 0.0)
      navigationItem.rightBarButtonItem?.setTitlePositionAdjustment(rightBarOffset, for: .default)
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
         }.cellUpdate { cell, row in
            cell.textField.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
         }.onChange{ row in
            self.exercise?.exerciseName = row.value
         }
         <<< TextRow(){ row in
            row.placeholder = "Exercise Muscle Group"
            row.tag = "exerciseMuscleRow"
            guard let exerciseMuscle = exercise?.exerciseMuscle else {
               return
            }
            row.value = exerciseMuscle
         }.cellUpdate { cell, row in
               cell.textField.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
         }.onChange{ row in
               self.exercise?.exerciseMuscle = row.value
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
         }.cellUpdate { cell, row in
            cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
            cell.detailTextLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
         }.onPresent { from, to in
            to.selectableRowCellUpdate = { cell, row in
               cell.textLabel!.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
            }
         }.onChange{ row in
               self.exercise?.exerciseType = row.value
         }
   }

   func addDeleteButton()  {
      // Create delete button for exercise
      let deleteButton = UIButton()
      // Set all properties for delete button below
      deleteButton.addTarget(self, action: #selector(deleteExercise), for: .touchUpInside)
      deleteButton.setTitle("Delete Exercise", for: .normal)
      deleteButton.backgroundColor = UIColor(red: 246.0/255.0, green: 53.0/255.0, blue: 76.0/255.0, alpha: 1.0)
      // Set property to false since programatically created
      deleteButton.translatesAutoresizingMaskIntoConstraints = false
      // Add delete button to view
      view.addSubview(deleteButton)
      // Set all constraints below
      if #available(iOS 11.0, *) {
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
      } else {
         let bottom = deleteButton.bottomAnchor.constraint(equalTo:
            view.bottomAnchor, constant: -20)
         let leading = deleteButton.leadingAnchor.constraint(equalTo:
            view.leadingAnchor, constant: 20)
         let trailing = deleteButton.trailingAnchor.constraint(equalTo:
            view.trailingAnchor, constant: -20)
         let height = NSLayoutConstraint.init(item: deleteButton, attribute: .height,
                                              relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                              multiplier: 1.0, constant: 50)
         let constraints = [bottom, leading, trailing, height]
         NSLayoutConstraint.activate(constraints)
      }

   }

   @objc func saveExercise() {

      // Check and validate all fields before writing to database
      let exerciseNameRow : TextRow? = form.rowBy(tag: "exerciseNameRow")
      let exerciseTypeRow : PushRow<String>? = form.rowBy(tag: "exerciseTypeRow")
      let exerciseMuscleRow : TextRow? = form.rowBy(tag: "exerciseMuscleRow")
      guard let exerciseName = exerciseNameRow?.value else {
         print("No name found")
         return
      }
      guard let exerciseType = exerciseTypeRow?.value else {
         print("No type found")
         return
      }
      guard let exerciseMuscle = exerciseMuscleRow?.value else {
         print("No muscle found")
         return
      }
      exercise?.exerciseName = exerciseName
      exercise?.exerciseType = exerciseType
      exercise?.exerciseMuscle = exerciseMuscle

      if exercise?.exerciseId != nil {
         // TODO: Check to see if all fields are valid. Update all values for
         // this particular exerciseId. Once saved show alert in middle saying
         // saved. Pop this view controller off the navigation and go to the
         // previous screem.
         do {
            try Exercise.updateExistingExercise(exercise: exercise!)
            navigationController?.popViewController(animated: true)
         } catch {
            print(error.localizedDescription)
         }
         
      }  else {
         do {
            try Exercise.saveNewExercise(exercise: exercise!)
            navigationController?.popViewController(animated: true)
         } catch {
            print(error.localizedDescription)
         }
      }
   }

   @objc func deleteExercise()   {
      // TODO: Hook up to delete button as action. Delete exercise from database.
      // If the popped navigation controller is of exercises view controller reload
      // the data in the previous controller. If it is not, that means it is the push view
      // controller, so reload that data, so the user can make the correct choice
      do {
         try Exercise.deleteExercise(exercise: exercise!)
         navigationController?.popViewController(animated: true)
      } catch {
         print(error.localizedDescription)
      }
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

