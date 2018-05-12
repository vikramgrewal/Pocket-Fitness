//
//  WorkoutExerciseSetPickerViewController.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 5/9/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import UIKit

class WorkoutExerciseSetPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

   var workoutExerciseSetPickerView : UIPickerView?
   var exercise : Exercise?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   func setUp()  {

      workoutExerciseSetPickerView = UIPickerView()
      workoutExerciseSetPickerView?.translatesAutoresizingMaskIntoConstraints = false
      workoutExerciseSetPickerView?.backgroundColor = .groupTableViewBackground
      workoutExerciseSetPickerView?.delegate = self
      workoutExerciseSetPickerView?.dataSource = self

   }

   func numberOfComponents(in pickerView: UIPickerView) -> Int {
      
      return 3

   }


   // The number of rows of data
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

      switch component {
         case 0:
            return 1000
         case 1:
            return 8
         default:
            return 100
      }

   }

   // The data to return for the row and component (column) that's being passed in
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

      var poundsLabels : [Int] = [Int]()
      var poundDecimalLabels : [Double] = [Double]()
      var repLabels : [Int] = [Int]()
      for poundNames in stride(from: 0, to: 1000, by: 1) {
         poundsLabels.append(poundNames)
      }
      for poundDecimalNames in stride(from: 0, to: 1, by: 0.125) {
         poundDecimalLabels.append(poundDecimalNames)
      }
      for repNames in 0...250 {
         repLabels.append(repNames)
      }
      switch component {
      case 0:
         return "\(poundsLabels[row])"
      case 1:
         let poundDecimalNumber: Double = poundDecimalLabels[row]
         let poundDecimalString = String(format: "%.3f", poundDecimalNumber).components(separatedBy: ".").last ?? "error"
         return ".\(poundDecimalString) lbs"
      default:
         return "\(repLabels[row]) reps"
      }

   }

   func instantiatePickerView(exercise : Exercise, workoutId : Int64, workoutExerciseId : Int64, workoutExerciseSetId : Int64) {
      self.exercise = exercise
      workoutExerciseSetPickerView?.reloadAllComponents()
      workoutExerciseSetPickerView?.reloadInputViews()
      print("Starting logging for new exercise set")
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
