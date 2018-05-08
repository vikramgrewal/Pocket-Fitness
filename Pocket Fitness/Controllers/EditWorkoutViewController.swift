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

   }

   @objc func addNewExercise()   {
      guard let _ = form.sectionBy(tag: "workoutExercisesSection")   else {
         return
      }
      let section = Section() {
         $0.tag = "workoutExerciseId"
      }

      form.append(section)

      let pushRow = PushRow<String>()   {
         $0.title = "Exercise Name"
         $0.options = ["Bench Press", "Dips"]
      }
      

      let strengthExerciseSetRow = StrengthExerciseSetRow()

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
         guard let sectionTag = workoutExerciseSection.tag else {
            return
         }
         guard let indexOfRow = row.section?.index(of: row) else {
            return
         }

         var workoutExerciseSet : StrengthExerciseSetRow = StrengthExerciseSetRow()

         workoutExerciseSection.insert(workoutExerciseSet, at: indexOfRow)

         self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)

      }

      section.append(pushRow)

      section.append(strengthExerciseSetRow)

      section.append(addButton)

      guard let indexPath = form.last?.last?.indexPath else {
         return
      }
      self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
   }

   func setUpDefaultForm()  {
      form
         +++ Section("Workout Information")   { section in
            section.header?.height = { 45 }
         }
         <<< TextRow() { // 3
            $0.title = "Workout Name" //4
            $0.placeholder = "e.g. Legs"
            $0.tag = "workoutNameRow"
         }
         <<< DateTimeRow() {
            $0.title = "Workout Date" //2
            $0.value = Date() //3
            $0.maximumDate = Date() //4
            $0.tag = "workoutDateRow"
            $0.onChange { [unowned self] row in //5
            }
         }
         <<< TextRow() { // 3
            $0.title = "Workout Notes" //4
            $0.placeholder = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
            $0.tag = "workoutNotesRow"
         }
         +++ Section("Workout Exercises")   { section in
            section.header?.height = { 45 }
            section.tag = "workoutExercisesSection"
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


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
