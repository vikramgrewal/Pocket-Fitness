//
//  CustomExerciseSelectorView.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 5/9/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import Foundation
import Eureka

class MyPushViewController: SelectorViewController<SelectorRow<PushSelectorCell<String>>> {

   var exercises : [Exercise]?
   var exerciseNames : [String]?

   override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
   }

   override func viewDidLoad() {
      super.viewDidLoad()
      let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAddExerciseViewController))
      navigationItem.rightBarButtonItem = addButton
      // Will need to include action to add a new exercise right here

   }

   override func viewDidAppear(_ animated: Bool) {
      getAllExercises()
   }

   func getAllExercises()  {
      
   }


   @objc func openAddExerciseViewController()   {
      let addExerciseVC = AddExerciseViewController()
      navigationController?.pushViewController(addExerciseVC, animated: true)
   }
}
