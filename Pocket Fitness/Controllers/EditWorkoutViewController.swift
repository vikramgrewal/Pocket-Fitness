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
//      <<< PickerInlineRow<Int>() {
//         $0.title = "Weight"
//         $0.options = { return [0, 1, 2, 3 , 4, 5, 6, 7] }()
//      }  <<< PickerInlineRow<Int>() {
//         $0.title = "Sets"
//         $0.options = { return [0, 1, 2, 3 , 4, 5, 6, 7] }()
//      }

      func towns(for country: String) -> [String] {
         if country == "Germany" {
            return ["Berlin"]
         } else {
            return ["Vienna"]
         }
      }

      let button = UIButton()
      button.backgroundColor = .white
      button.setTitle("Add Exercise", for: .normal)
      button.setTitleColor(.blue, for: .normal)
      view.addSubview(button)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
      button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
      button.heightAnchor.constraint(equalToConstant: 30).isActive = true
      button.widthAnchor.constraint(equalToConstant: 90).isActive = true
      button.addTarget(self, action: #selector(addNewExercise), for: .touchUpInside)
   }

   @objc func addNewExercise()   {
      guard let _ = form.sectionBy(tag: "workoutExercisesSection")   else {
         return
      }
      let section = Section() {
         $0.tag = "Wow"
      }

      form.append(section)

      let pushRow = PushRow<String>()   {
         $0.title = "Exercise Name"
         $0.options = ["Bench Press", "Dips"]
      }

      let splitExerciseSetRow = SplitRow<PickerInputRow<Float>,PickerInputRow<Int>>(){
         $0.rowLeftPercentage = 50.0 / 100.0
         $0.rowLeft = PickerInputRow<Float>(){
            $0.title = "Weight"
            $0.options = [1,2,3,4]
         }
         $0.rowRight = PickerInputRow<Int>(){
            $0.title = "Reps"
            $0.options = [1,2,3,4]
         }

      }.onChange{
            print("SplitRow.onChange:","left:",$0.value?.left,"right:",$0.value?.right)
            print($0.section?.tag)
      }

         
      let addButton = ButtonRow() {
         $0.title = "Add Set"
      }.cellUpdate { cell, row in
         cell.textLabel?.textColor = .white
         cell.backgroundColor = UIColor(red: 74.0/255.0, green: 185.0/255.0, blue: 55.0/255.0, alpha: 1.0)
      }

      section.append(pushRow)

      section.append(splitExerciseSetRow)

      section.append(addButton)

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
