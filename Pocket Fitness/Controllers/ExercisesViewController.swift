//
//  ExercisesViewController.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 4/12/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import UIKit
import SwipeCellKit

class ExercisesViewController: UIViewController {

   var exercises : [Exercise]?
   var tableView : UITableView!
   var searchController: UISearchController!

   override func viewDidLoad() {
      exercises = [Exercise]()
      exercises?.append(Exercise(exerciseId: 123, exerciseName: "Bench Press", exerciseType: "Cardio", exerciseMuscle: "Abs", userId: 1111))
      exercises?.append(Exercise(exerciseId: 123, exerciseName: "Bench Press", exerciseType: "Cardio", exerciseMuscle: "Abs", userId: 1111))
      exercises?.append(Exercise(exerciseId: 123, exerciseName: "Bench Press", exerciseType: "Cardio", exerciseMuscle: "Abs", userId: 1111))
      exercises?.append(Exercise(exerciseId: 123, exerciseName: "Bench Press", exerciseType: "Cardio", exerciseMuscle: "Abs", userId: 1111))
      exercises?.append(Exercise(exerciseId: 123, exerciseName: "Bench Press", exerciseType: "Cardio", exerciseMuscle: "Abs", userId: 1111))
      exercises?.append(Exercise(exerciseId: 123, exerciseName: "Bench Press", exerciseType: "Cardio", exerciseMuscle: "Abs", userId: 1111))
      exercises?.append(Exercise(exerciseId: 123, exerciseName: "Bench Press", exerciseType: "Cardio", exerciseMuscle: "Abs", userId: 1111))
      exercises?.append(Exercise(exerciseId: 123, exerciseName: "Bench Press", exerciseType: "Cardio", exerciseMuscle: "Abs", userId: 1111))
      exercises?.append(Exercise(exerciseId: 123, exerciseName: "Bench Press", exerciseType: "Cardio", exerciseMuscle: "Abs", userId: 1111))
      exercises?.append(Exercise(exerciseId: 123, exerciseName: "Bench Press", exerciseType: "Cardio", exerciseMuscle: "Abs", userId: 1111))
      exercises?.append(Exercise(exerciseId: 123, exerciseName: "Bench Press", exerciseType: "Cardio", exerciseMuscle: "Abs", userId: 1111))
      setUpView()
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      if let index = tableView.indexPathForSelectedRow{
         self.tableView.deselectRow(at: index, animated: true)
      }
   }

   func setUpView()  {

      view.backgroundColor = .white
      setUpSearchBar()
      setUpTableView()
   }

   func setUpTableView()   {
      tableView = UITableView()
      tableView.separatorStyle = .singleLine
      tableView.tableFooterView = UIView()
      tableView.delegate = self
      tableView.dataSource = self
      view.addSubview(tableView)
      tableView.translatesAutoresizingMaskIntoConstraints = false
      guard tableView !== nil else {
         print("Error retrieving table view")
         return
      }
      if #available(iOS 11.0, *) {
         let top = tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
         let bottom = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
         let leading = tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
         let trailing = tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
         let constraints = [bottom,trailing, leading, top]
         NSLayoutConstraint.activate(constraints)
      } else {
         let top = tableView.topAnchor.constraint(equalTo: view.topAnchor)
         let bottom = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
         let leading = tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
         let trailing = tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
         let constraints = [bottom,trailing, leading, top]
         NSLayoutConstraint.activate(constraints)
      }


   }

}

extension ExercisesViewController : UISearchBarDelegate, SwipeTableViewCellDelegate {

   func setUpSearchBar()   {
      searchController = UISearchController(searchResultsController: nil)
      navigationItem.titleView = searchController.searchBar
      let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
      navigationItem.rightBarButtonItem = addButton
      addButton.action = #selector(createNewExercise)
      searchController.searchBar.sizeToFit()
      searchController.hidesNavigationBarDuringPresentation = false
   }

   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

      guard orientation == .right else { return nil }

      let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
         print("Start delete procedure for exercise")
      }

      return [deleteAction]
   }


   @available(iOS 2.0, *)
   public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)   {

   }

   @available(iOS 2.0, *)
   public func searchBarTextDidEndEditing(_ searchBar: UISearchBar)  {

   }

}

extension ExercisesViewController : UITableViewDelegate, UITableViewDataSource {

   func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }


   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let addExerciseVC = AddExerciseViewController()
      let row = indexPath.row
      guard let exercise = exercises?[row]   else {
         return
      }
      addExerciseVC.exercise = exercise
      navigationController?.pushViewController(addExerciseVC, animated: true)
   }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let exercisesCount = exercises?.count else {
         return 0
      }
      return exercisesCount
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

      let cell = SwipeTableViewCell()
      cell.heightAnchor.constraint(equalToConstant: 50).isActive = true

      cell.delegate = self
      cell.selectionStyle = .default

      let exerciseNameLabel = UILabel()
      exerciseNameLabel.translatesAutoresizingMaskIntoConstraints = false
      cell.addSubview(exerciseNameLabel)
      exerciseNameLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 22.0).isActive = true
      exerciseNameLabel.trailingAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
      exerciseNameLabel.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
      exerciseNameLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true

      let exerciseMuscleLabel = UILabel()
      exerciseMuscleLabel.textColor = .lightGray
      exerciseMuscleLabel.textAlignment = NSTextAlignment.right
      exerciseMuscleLabel.translatesAutoresizingMaskIntoConstraints = false
      cell.addSubview(exerciseMuscleLabel)
      exerciseMuscleLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -22.0).isActive = true
      exerciseMuscleLabel.leadingAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
      exerciseMuscleLabel.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
      exerciseMuscleLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true

      if let exerciseName = exercises?[indexPath.row].exerciseName {
         exerciseNameLabel.text = exerciseName
      }  else {
         exerciseNameLabel.text = ""
      }

      if let exerciseMuscle = exercises?[indexPath.row].exerciseMuscle {
         exerciseMuscleLabel.text = exerciseMuscle
      }  else {
         exerciseMuscleLabel.text = ""
      }

      return cell
   }

   @objc func createNewExercise()   {
      let addExerciseVC = AddExerciseViewController()
      navigationController?.pushViewController(addExerciseVC, animated: true)
   }

}
