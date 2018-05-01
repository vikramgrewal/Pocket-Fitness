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
      form +++ Section("Exercise 1") <<< TextRow()   {
         $0.title = "Exercise Name" //4
         $0.placeholder = "e.g. Bench Press"
      }

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
