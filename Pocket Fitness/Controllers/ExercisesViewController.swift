//
//  ExercisesViewController.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 4/12/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import UIKit
import Material
import SwipeCellKit

class ExercisesViewController: UIViewController {

   var testExercises : [[TestExercise?]]!
   var tableView : TableView!
   var addExerciseButton : Button!

   override func viewDidLoad() {
      testExercises = [[],[]]
      testExercises[0].append(TestExercise(name: "Benchpress", muscleGroup: "Chest"))
      testExercises[0].append(TestExercise(name: "Dips", muscleGroup: "Chest"))
      testExercises[1].append(TestExercise(name: "Quad Extensions", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))

      setLayout()
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      navigationController?.setNavigationBarHidden(true, animated: true)
   }

   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(true)
      navigationController?.setNavigationBarHidden(false, animated: false)
   }

   private func setLayout()   {
      setUpView()
      view.addSubview(tableView)
      view.addSubview(addExerciseButton)
      addExerciseButton.addTarget(self, action: #selector(createNewExercise), for: .touchUpInside)
      tableView.separatorStyle = .singleLine
      tableView.tableFooterView = UIView()
      tableView.delegate = self
      tableView.dataSource = self
      searchBarController?.searchBar.delegate = self
      setConstraints()
   }

   private func setConstraints() {
      setTableConstraints()
      setButtonConstraints()
   }

   func setUpView()  {

      view.backgroundColor = .white
      setUpTableView()
      setUpAddExerciseButton()

   }

   func setUpTableView()   {
      tableView = TableView()
      tableView.translatesAutoresizingMaskIntoConstraints = false
      guard tableView !== nil else {
         print("Error retrieving table view")
         return
      }

   }

   func setUpAddExerciseButton() {
      addExerciseButton = Button()
      addExerciseButton.translatesAutoresizingMaskIntoConstraints = false
      addExerciseButton.backgroundColor = .lightGray
      addExerciseButton.titleEdgeInsets.right = 10
      addExerciseButton.titleEdgeInsets.left = 10
      addExerciseButton.titleEdgeInsets.bottom = 10
      addExerciseButton.titleEdgeInsets.top = 10
      addExerciseButton.titleLabel?.adjustsFontSizeToFitWidth = true
      addExerciseButton.titleLabel?.font = UIFont(name:"Times New Roman", size: 24)
      addExerciseButton.setTitle("Add Exercise", for: .normal)
      addExerciseButton.setTitleColor(.white, for: .normal)
      guard addExerciseButton !== nil else {
         print("Error retrieving button")
         return
      }

   }

   private func setButtonConstraints() {
      let bottom = addExerciseButton.bottomAnchor.constraint(equalTo:
         view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
      let trailing = addExerciseButton.trailingAnchor.constraint(equalTo:
         view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
      let height = NSLayoutConstraint(item: addExerciseButton,
                                      attribute: .height, relatedBy: .equal, toItem: nil,
                                      attribute: .notAnAttribute, multiplier: 1.0, constant: 60)
      let constraints = [bottom, trailing, height]
      NSLayoutConstraint.activate(constraints)
   }

   private func setTableConstraints()  {
      let top = tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
      let bottom = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
      let leading = tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
      let trailing = tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
      let constraints = [bottom,trailing, leading, top]
      NSLayoutConstraint.activate(constraints)
      let insets = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
      tableView.contentInset = insets
   }

}

extension ExercisesViewController : SearchBarDelegate, SwipeTableViewCellDelegate {
   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

      guard orientation == .right else { return nil }

      let addToWorkoutAction = SwipeAction(style: .default, title: "Add To Workout") {action, indexPath in
         print("Start add to workout procedure")
      }
      let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
         print("Start delete procedure for exercise")
      }

      return [deleteAction, addToWorkoutAction]
   }


   func searchBar(searchBar: SearchBar, didChange textField: UITextField, with text: String?)   {

   }

   func searchBar(searchBar: SearchBar, didClear textField: UITextField, with text: String?) {
      searchBar.endEditing(true)
   }


}

extension ExercisesViewController : UITableViewDelegate, UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return testExercises[section].count
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = SwipeTableViewCell()
      cell.delegate = self

      cell.selectionStyle = .default
      if let cellName = testExercises[indexPath.section][indexPath.row]?.name {
         cell.textLabel?.text = cellName
      }  else {
         cell.textLabel?.text = ""
      }

      let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openExercise))
      cell.addGestureRecognizer(gestureRecognizer)

      let height = NSLayoutConstraint.init(item: cell, attribute: .height,
                                  relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                  multiplier: 1.0, constant: 55)
      let constraints = [height]
      NSLayoutConstraint.activate(constraints)
      return cell
   }

   func  numberOfSections(in tableView: UITableView) -> Int {
      if testExercises.count > 0 {
         tableView.backgroundView = nil
         return testExercises.count
      } else {
         let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
         messageLabel.text = "Retrieving data.\nPlease wait."
         messageLabel.numberOfLines = 0;
         messageLabel.textAlignment = .center;
         messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
         messageLabel.sizeToFit()
         tableView.backgroundView = messageLabel;
      }
      return 0
   }

   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      guard let sectionExercise = testExercises[section][0] else {
         return "Default"
      }
      return sectionExercise.muscleGroup
   }

   @objc func openExercise(gestureRecognizer : UITapGestureRecognizer) {
      let addExerciseVC = AddExerciseViewController()
      if gestureRecognizer.state == UIGestureRecognizerState.ended {
         let tapLocation = gestureRecognizer.location(in: tableView)
         if let tapIndexPath = tableView.indexPathForRow(at: tapLocation) {
            if let tappedCell = tableView.cellForRow(at: tapIndexPath) {
               let section = tapIndexPath.section
               let row = tapIndexPath.row
               guard let exercise = testExercises[section][row]   else {
                  return
               }
               addExerciseVC.exerciseId = "123"
               addExerciseVC.exerciseType = "Strength"
               addExerciseVC.exerciseCategory = exercise.muscleGroup
               addExerciseVC.exerciseName = exercise.name
            }
         }
      }
      navigationController?.pushViewController(addExerciseVC, animated: true)
   }

   @objc func createNewExercise()   {
      let addExerciseVC = AddExerciseViewController()
      navigationController?.pushViewController(addExerciseVC, animated: true)
   }

}

struct TestExercise {
   var name, muscleGroup : String
}
