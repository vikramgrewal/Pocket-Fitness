//
//  EditWorkoutViewController.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 5/1/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import UIKit
import Eureka

class EditWorkoutViewController: FormViewController {

   var workoutExerciseSetPickerView : UIPickerView?
   var pickerViewHeight, pickerCompleteViewTrailing : NSLayoutConstraint?
   var pickerCompleteView : UIButton?
   var pickerVC : WorkoutExerciseSetPickerViewController?
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
      setUpPickerView()
      setUpPickerCompleteView()
      navigationOptions = .Enabled
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
            guard let workoutName = workout?.workoutName else {
               return
            }
            $0.value = workoutName
         }
         <<< DateTimeRow() {
            $0.title = "Workout Date"
            $0.maximumDate = Date()
            $0.tag = "workoutDateRow"
//            $0.onChange { [unowned self] row in
//            }
            guard let workoutDate = workout?.workoutDate else {
               return
            }
            $0.value = workoutDate
         }
         <<< TextRow() {
            $0.title = "Workout Notes"
            $0.placeholder = "e.g pain in left hip during squats"
            $0.tag = "workoutNotesRow"
            guard let workoutNotes = workout?.workoutNotes else {
               return
            }
            $0.value = workoutNotes
         }
         +++ Section("Workout Exercises")   {
            $0.header?.height = { 0 }
            $0.tag = "workoutExercisesSection"
            $0.footer?.height = { 0 }
      }

      tableView.contentInset = UIEdgeInsetsMake(0, 0, 54, 0);
   }

   func setUpAddExerciseButton() {
      let button = UIButton()
      button.backgroundColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 141.0/255.0, alpha: 1.0)
      button.setTitle("Add Exercise", for: .normal)
      button.setTitleColor(.white, for: .normal)
      view.addSubview(button)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
      button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
      button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
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

      let exerciseNameRow = PushRow<String>()   {
         $0.title = "Exercise Name"

         $0.presentationMode = PresentationMode.show(
            controllerProvider: ControllerProvider.callback(builder: { return MyPushViewController() }),
            onDismiss: { vc in let _ = vc.navigationController?.popViewController(animated: true) }
         )

      }.onChange { row in
         if row.value != nil {
            row.cell.isUserInteractionEnabled = false
         }
      }

      let addButton = ButtonRow() {
         $0.title = "Add Set"
         }.cellUpdate { cell, row in
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

            let workoutExerciseSet = StrengthExerciseSetRow(tag: nil, workoutId: "workoutId", workoutExerciseId: workoutExerciseSectionTag)
            .onCellSelection { cell, row in
                  guard let indexPath = row.indexPath else {
                     return
                  }

                  self.openPickerView()
                  self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// Handles all logic for setting up picker view and toggling control
extension EditWorkoutViewController {

   func setUpPickerView()  {

      pickerVC = WorkoutExerciseSetPickerViewController()
      pickerVC?.setUp()
      view.addSubview((pickerVC?.workoutExerciseSetPickerView)!)
      pickerVC?.workoutExerciseSetPickerView?.translatesAutoresizingMaskIntoConstraints = false
      pickerVC?.workoutExerciseSetPickerView?.layer.zPosition = 10
      pickerVC?.workoutExerciseSetPickerView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
      pickerVC?.workoutExerciseSetPickerView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
      pickerVC?.workoutExerciseSetPickerView?.heightAnchor.constraint(equalToConstant: 125).isActive = true
      pickerViewHeight = pickerVC?.workoutExerciseSetPickerView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
      pickerViewHeight?.isActive = true

   }

   func setUpPickerCompleteView() {

      pickerCompleteView = UIButton()
      pickerCompleteView?.layer.zPosition = 11
      pickerCompleteView?.backgroundColor = UIColor(red: 53/255, green: 103/255, blue: 172/255, alpha: 1.0)
      pickerCompleteView?.setTitle("Done", for: .normal)
      pickerCompleteView?.setTitleColor(.white, for: .normal)
      view.addSubview(pickerCompleteView!)
      pickerCompleteView?.addTarget(self, action: #selector(closePickerView), for: .touchUpInside)
      pickerCompleteView?.translatesAutoresizingMaskIntoConstraints = false
      pickerCompleteView?.heightAnchor.constraint(equalToConstant: 44).isActive = true
      pickerCompleteView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
      pickerCompleteView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
      pickerCompleteViewTrailing = pickerCompleteView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
      pickerCompleteViewTrailing?.isActive = true

   }

   func openPickerView() {

      let exercise = Exercise(exerciseId: 2, exerciseName: "wow", exerciseType: "Card", exerciseMuscle: "Abs", userId: 12)
      pickerVC?.instantiatePickerView(exercise: exercise, workoutId: 12, workoutExerciseId: 12, workoutExerciseSetId: 12)
      if pickerViewHeight?.constant == 0 {

         pickerViewHeight?.constant = -125
         pickerCompleteViewTrailing?.constant = -125 - 44

         UIView.animate(withDuration: 0.5) {
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 125+54, right: 0)
            self.view.layoutIfNeeded()
         }

      }

   }

   @objc func closePickerView()  {
      if pickerViewHeight?.constant != 0 {
         pickerViewHeight?.constant = 0
         pickerCompleteViewTrailing?.constant = 0

         UIView.animate(withDuration: 0.5) {
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 54, right: 0)
            self.view.layoutIfNeeded()
         }
         
      }
   }

   

}



