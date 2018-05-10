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

   var testExercises : [[TestExercise?]]!
   var tableView : UITableView!
   var searchController: UISearchController!

   override func viewDidLoad() {
      testExercises = [[],[]]
      testExercises[0].append(TestExercise(name: "Benchpress", muscleGroup: "Chest"))
      testExercises[0].append(TestExercise(name: "Dips", muscleGroup: "Chest"))
      testExercises[1].append(TestExercise(name: "Quad Extensions", muscleGroup: "Legs"))
      testExercises[1].append(TestExercise(name: "Squat", muscleGroup: "Legs"))

      setLayout()
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      if let index = tableView.indexPathForSelectedRow{
         self.tableView.deselectRow(at: index, animated: true)
      }
   }

   private func setLayout()   {
      setUpView()
      view.addSubview(tableView)
      tableView.separatorStyle = .singleLine
      tableView.tableFooterView = UIView()
      tableView.delegate = self
      tableView.dataSource = self
      setConstraints()
   }

   private func setConstraints() {
      setTableConstraints()
   }

   func setUpView()  {

      view.backgroundColor = .white
      setUpSearchBar()
      setUpTableView()
   }

   func setUpTableView()   {
      tableView = UITableView()
      tableView.translatesAutoresizingMaskIntoConstraints = false
      guard tableView !== nil else {
         print("Error retrieving table view")
         return
      }

   }

   private func setTableConstraints()  {
      let top = tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
      let bottom = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
      let leading = tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
      let trailing = tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
      let constraints = [bottom,trailing, leading, top]
      NSLayoutConstraint.activate(constraints)
   }

}

extension ExercisesViewController : UISearchBarDelegate, SwipeTableViewCellDelegate {
   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

      guard orientation == .right else { return nil }

      let addToWorkoutAction = SwipeAction(style: .default, title: "Add To Workout") {action, indexPath in
         print("Start add to workout procedure")
      }
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

   func setUpSearchBar()   {
      searchController = UISearchController(searchResultsController: nil)
      navigationItem.titleView = searchController.searchBar
      let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
      navigationItem.rightBarButtonItem = addButton
      addButton.action = #selector(createNewExercise)
      searchController.searchBar.sizeToFit()
      searchController.hidesNavigationBarDuringPresentation = false
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
                                  multiplier: 1.0, constant: 50)
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
