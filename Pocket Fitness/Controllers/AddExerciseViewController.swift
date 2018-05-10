//
//  AddExerciseViewController.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 4/16/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import UIKit
import Eureka

class AddExerciseViewController: FormViewController {

   var exerciseId : String?
   var exerciseType : String?
   var exerciseName : String?
   var exerciseCategory : String?

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

   @objc func saveExercise() {
      if let _ = exerciseId  {

      }  else {

      }
   }

   func setView() {
      view.backgroundColor = .white
      setForm()
      guard let _ = exerciseId else {
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
            row.onChange { row in
               if let exerciseName = row.value {
                  self.exerciseName = exerciseName
               }
            }
            guard let _ = self.exerciseName else {
               return
            }
            row.value = self.exerciseName
         }
         <<< TextRow(){ row in
            row.placeholder = "Exercise Muscle Group"
            row.tag = "exerciseCategoryRow"
            row.onChange { row in
               if let exerciseCategory = row.value {
                  self.exerciseCategory = exerciseCategory
               }
            }
            guard let _ = self.exerciseCategory else {
               return
            }
            row.value = self.exerciseCategory
         }
         <<< PushRow<String>() { row in
            row.title = "Exercise Type"
            row.tag = "exerciseTypeRow"
            row.options = ["Cardio", "Strength"]
            row.cell.textLabel?.textColor = .red
            row.onChange { row in //5
               if let exerciseType = row.value {
                  self.exerciseType = exerciseType
               }
            }
            guard let _ = self.exerciseType else {
               return
            }
            row.value = self.exerciseType
      }
   }

   func addDeleteButton()  {
      let deleteButton = UIButton()
      deleteButton.setTitle("Delete Exercise", for: .normal)
      deleteButton.backgroundColor = UIColor(red: 246.0/255.0, green: 53.0/255.0, blue: 76.0/255.0, alpha: 1.0)
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
      view.addSubview(deleteButton)
      NSLayoutConstraint.activate(constraints)
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

