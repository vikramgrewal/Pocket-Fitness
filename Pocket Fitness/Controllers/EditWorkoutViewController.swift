import UIKit
import Eureka

class EditWorkoutViewController: FormViewController {

   var workout : Workout?

    override func viewDidLoad() {
        super.viewDidLoad()

         setUpView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   func setUpView()  {
      view.backgroundColor = .white
      setUpDefaultForm()
      setUpAddExerciseButton()
      navigationOptions = .Enabled
      navigationAccessoryView.tintColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 141.0/255.0, alpha: 1.0)
   }

   func setUpDefaultForm()  {
      form
         +++ Section()   { section in
            section.header?.height = { 44 }
         }
         <<< TextRow() {
            $0.title = "Workout Name"
            $0.placeholder = "e.g. Legs"
            $0.tag = "workoutNameRow"
            if let workoutName = workout?.workoutName {
               $0.value = workoutName
            }else {
               $0.value = nil
            }
         }.cellUpdate { cell, row in
            cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
            cell.textField.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
            self.saveWorkoutInformation()
            cell.tintColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 141.0/255.0, alpha: 1.0)
         }
         <<< DateTimeRow() {
            $0.title = "Workout Date"
            $0.maximumDate = Date()
            $0.tag = "workoutDateRow"
//            $0.onChange { [unowned self] row in
//            }
            if let workoutDate = workout?.workoutDate {
               $0.value = workoutDate
            }else {
               $0.value = nil
            }
         }.cellUpdate { cell, row in
            cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
            cell.detailTextLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
            self.saveWorkoutInformation()
            cell.tintColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 141.0/255.0, alpha: 1.0)
         }
         <<< TextRow() {
            $0.title = "Workout Notes"
            $0.placeholder = "e.g pain in left hip during squats"
            $0.tag = "workoutNotesRow"
            if let workoutNotes = workout?.workoutNotes {
               $0.value = workoutNotes
            }else {
               $0.value = nil
            }

         }.cellUpdate { cell, row in
            cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
            cell.textField.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
            self.saveWorkoutInformation()
            cell.tintColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 141.0/255.0, alpha: 1.0)
         }
         +++ Section("Workout Exercises")   {
            $0.header?.height = { 0 }
            $0.tag = "workoutExercisesSection"
            $0.footer?.height = { 0 }
      }

      tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)

   }

   func setUpAddExerciseButton() {
      let button = UIButton()
      button.backgroundColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 141.0/255.0, alpha: 1.0)
      button.setTitle("Add Exercise", for: .normal)
      button.setTitleColor(.white, for: .normal)
      button.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
      view.addSubview(button)
      button.translatesAutoresizingMaskIntoConstraints = false
      if #available(iOS 11.0, *) {
         button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
         button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
         button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
      } else {
         button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
         button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
         button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
      }
      button.heightAnchor.constraint(equalToConstant: 44).isActive = true
      button.addTarget(self, action: #selector(addNewExercise), for: .touchUpInside)
   }


   @objc func addNewExercise()   {

      guard let workoutExercisesSection = form.sectionBy(tag: "workoutExercisesSection")   else {
         return
      }

      // Write new exercise to database using some model
      let newExerciseId = UUID().uuidString

      let newExerciseSection = Section() {
         $0.tag = newExerciseId
         $0.header?.height = { 0 }
      }

      form.append(newExerciseSection)

      let exerciseNameRow = PushRow<Exercise>()   {
         $0.title = "Exercise Name"

         $0.presentationMode = PresentationMode.show(
            controllerProvider: ControllerProvider.callback(builder: { return ExercisePushViewController() }),
            onDismiss: { vc in let _ = vc.navigationController?.popViewController(animated: true) }
         )

         }.onPresent { from, to in
            to.selectableRowCellUpdate = { cell, row in
               cell.textLabel!.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
            }
         }.cellUpdate{ cell, row in
            cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
            cell.detailTextLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
         }.onChange { row in
            if row.value != nil {
               row.cell.isUserInteractionEnabled = false
            }
         }

      let addButton = ButtonRow() {
         $0.title = "Add Set"
         }.cellUpdate { cell, row in
            cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
            cell.textLabel?.textColor = .white
            cell.backgroundColor = UIColor(red: 255.0/255.0, green: 182.0/255.0, blue: 55.0/255.0, alpha: 1.0)
         }.onCellSelection{ cell, row in

            guard var workoutExerciseSection : Section = row.section else {
               return
            }

            guard let indexPath = row.indexPath else {
               return
            }

            guard let workoutExerciseSectionTag = workoutExerciseSection.tag else {
               return
            }

            guard let indexOfRow = row.section?.index(of: row) else {
               return
            }

            guard let firstRow = workoutExerciseSection.first as? PushRow<String> else {
               return
            }

            guard let exerciseValue = firstRow.value else {
               let alertController = UIAlertController.init(title: "Warning", message: "Select an exercise!", preferredStyle: .alert)
               alertController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
               self.present(alertController, animated: true, completion: nil)
               return
            }

            let workoutExerciseSet = SplitRow<DecimalRow, IntRow>() {
               $0.rowLeft = DecimalRow(){
                  $0.placeholder = "e.g. 14 lbs"
                  $0.formatter = DecimalFormatter()
                  $0.useFormatterDuringInput = true
               }

               $0.rowRight = IntRow(){
                  $0.placeholder = "e.g. 10 reps"
               }
               $0.rowLeftPercentage = 0.5
               $0.rowLeft?.placeholder = "e.g. 14 lbs"
               $0.rowRight?.placeholder = "e.g. 5 reps"
            }

            workoutExerciseSection.insert(workoutExerciseSet, at: indexOfRow)

            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)

      }

      newExerciseSection.append(exerciseNameRow)

      newExerciseSection.append(addButton)

      newExerciseSection.footer?.height = { 44 }

      guard let indexPath = form.last?.last?.indexPath else {
         return
      }
      self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
   }

   func saveWorkoutInformation() {
      guard let workoutNameRow = form.rowBy(tag: "workoutNameRow") as? TextRow,
         let workoutDateRow  = form.rowBy(tag: "workoutDateRow") as? DateTimeRow,
         let workoutNotesRow = form.rowBy(tag: "workoutNotesRow") as? TextRow else {
            print("Something went wrong")
            return
      }

      guard  let workoutId = workout?.workoutId else {
         return
      }
      let workoutName = workoutNameRow.value == nil ? "" : workoutNameRow.value!
      let workoutDate = workoutDateRow.value!
      let workoutNotes = workoutNotesRow.value == nil ? "" : workoutNotesRow.value!

      let workoutToUpdate = Workout(workoutId: workoutId, workoutName: workoutName,
                                    workoutDate: workoutDate, workoutNotes: workoutNotes,
                                    userWeight : nil)
      do {
         try WorkoutTable.updateExistingWorkout(workout: workoutToUpdate)
      } catch {
         print(error)
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



