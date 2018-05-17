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
      setUpView()
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      if let index = tableView.indexPathForSelectedRow{
         self.tableView.deselectRow(at: index, animated: true)
      }
      fetchData()
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
      searchController.searchBar.delegate = self
      searchController.dimsBackgroundDuringPresentation = false
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
         do {
            guard let exerciseToDelete = self.exercises?[indexPath.row] else {
               return
            }
            try ExerciseTable.deleteExercise(exercise: exerciseToDelete)
            self.fetchData()
         } catch {
            print(error.localizedDescription)
         }
      }

      return [deleteAction]
   }




   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      guard let searchBarText = searchBar.text?.lowercased() else {
         return
      }
      guard searchBarText.count > 0 else {
         fetchData()
         return
      }

      do {
         guard let originalExercises = try ExerciseTable.getAllExercises() else {
            return
         }
         exercises = originalExercises.filter{ exercise in
            return (exercise.exerciseName?.lowercased().contains(searchBarText))!
         }
         tableView.reloadData()
      } catch {
         print(error.localizedDescription)
         fetchData()
      }
   }
}

extension ExercisesViewController : UITableViewDelegate, UITableViewDataSource {

   public func fetchData() {

   }

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
      self.searchController.isActive = false
      navigationController?.pushViewController(addExerciseVC, animated: true)
   }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let exercisesCount = exercises?.count else {
         return 0
      }
      return exercisesCount
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

      let cell = SwipeTableViewCell(style: .default, reuseIdentifier: nil)
      cell.heightAnchor.constraint(equalToConstant: 50).isActive = true

      cell.delegate = self
      cell.selectionStyle = .default

      let exerciseNameLabel = UILabel()
      exerciseNameLabel.translatesAutoresizingMaskIntoConstraints = false
      cell.addSubview(exerciseNameLabel)
      exerciseNameLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
      exerciseNameLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 22.0).isActive = true
      exerciseNameLabel.trailingAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
      exerciseNameLabel.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
      exerciseNameLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true

      let exerciseMuscleLabel = UILabel()
      exerciseMuscleLabel.textColor = .lightGray
      exerciseMuscleLabel.textAlignment = NSTextAlignment.right
      exerciseMuscleLabel.translatesAutoresizingMaskIntoConstraints = false
      exerciseMuscleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
      cell.addSubview(exerciseMuscleLabel)
      exerciseMuscleLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -22.0).isActive = true
      exerciseMuscleLabel.centerXAnchor.constraint(equalTo: exerciseNameLabel.trailingAnchor).isActive = true
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
      self.searchController.isActive = false
      navigationController?.pushViewController(addExerciseVC, animated: true)
   }

}
