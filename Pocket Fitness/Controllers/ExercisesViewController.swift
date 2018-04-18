//
//  ExercisesViewController.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 4/12/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import UIKit
import Material

class ExercisesViewController: UIViewController {

   var exercises : [Exercise]!
   var filteredExercises : [Exercise]!
   var exercisesSearchBarController : ExercisesSearchBarController!
   var exerciseView : ExercisesView!

   override func viewDidLoad() {
     super.viewDidLoad()

     // Do any additional setup after loading the view.


      setData()
      setView()
      prepareSearchDelegate()
      prepareTableDelegate()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   func setView() {
      let parentFrame = self.view.frame
      exerciseView = ExercisesView(frame: parentFrame)
      view.addSubview(exerciseView)
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

extension ExercisesViewController : SearchBarDelegate {
   internal func prepareSearchDelegate() {

      exercisesSearchBarController = ExercisesSearchBarController()

      // Access the searchBar.
      guard let searchBar = exerciseView.searchBar else {
         debugPrint("Didn't find search bar")
         return
      }

      searchBar.endEditing(true)
      searchBar.delegate = self
   }

   func searchBar(searchBar: SearchBar, didChange textField: UITextField, with text: String?) {
      if textField.text!.count > 0 {
         exercisesSearchBarController?.isEditing = true
         let text = textField.text!.lowercased()
         filteredExercises = exercises.filter{
            $0.exerciseName.lowercased().range(of: text) != nil
         }
      }  else  {
         filteredExercises.removeAll()
         exercisesSearchBarController?.isEditing = false
      }
      exerciseView.tableView.reloadData()
   }

   func searchBar(searchBar: SearchBar, didClear textField: UITextField, with text: String?) {
      DispatchQueue.main.async {
      self.filteredExercises.removeAll()
      self.exercisesSearchBarController?.isEditing = false
      if text != nil && text?.count == 0 {
         self.exerciseView.searchBar.endEditing(true)
      }
         self.exerciseView.tableView.reloadData()
      }

   }



}

extension ExercisesViewController : UITableViewDelegate, UITableViewDataSource {

   internal func prepareTableDelegate()   {

      exerciseView.tableView.delegate = self
      exerciseView.tableView.dataSource = self
      exerciseView.tableView.separatorStyle = .singleLine
      exerciseView.tableView.separatorColor = .black
      exerciseView.tableView.reloadData()
   }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let _ = exercises else {
         return 0
      }
      if !exercisesSearchBarController.isEditing {
         return exercises.count
      }  else  {
         return filteredExercises.count
      }
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
      let row = indexPath.row
      if !exercisesSearchBarController.isEditing {
         let data = exercises[row]
         cell.textLabel?.text = data.exerciseName
      }  else  {
         let data = filteredExercises[row]
         cell.textLabel?.text = data.exerciseName
      }

      let cellOption = UIView()
      cell.addSubview(cellOption)
      cellOption.backgroundColor = .red

      let trailing = cellOption.trailingAnchor.constraint(equalTo: cell.trailingAnchor)
      let top = cellOption.topAnchor.constraint(equalTo: cell.topAnchor)
      let bottom = cellOption.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
      let width = NSLayoutConstraint(item: cellOption, attribute: .width,
                                     relatedBy: .equal, toItem: nil,
                                     attribute: .notAnAttribute, multiplier: 1.0,
                                     constant: 50)

      let constraints = [trailing, top, bottom, width]
      cellOption.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate(constraints)

//      let holdGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleHoldGesture(_:)))
//      cell.addGestureRecognizer(holdGestureRecognizer)

      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
      cell.addGestureRecognizer(tapGestureRecognizer)

      let optionGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleOptionTapGesture(_:)))
      cellOption.addGestureRecognizer(optionGestureRecognizer)
      return cell
   }

   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      // You other cell selected functions here ...
      // then add the below at the end of it.
      exerciseView.tableView.deselectRow(at: indexPath, animated: true)
   }

   @objc func handleOptionTapGesture(_ gesture: UITapGestureRecognizer)  {

      let location = gesture.location(in: exerciseView.tableView)
      guard let indexPath = exerciseView.tableView.indexPathForRow(at: location) else {
         return
      }
      let row = indexPath.row
      let cell = exerciseView.tableView.cellForRow(at: indexPath)

      let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)

      let addExerciseAction = UIAlertAction(title: "Add Exercise To Workout", style: .default, handler: {
         (alert: UIAlertAction!) -> Void in
         print("File Deleted")
      })

      let deleteExerciseAction = UIAlertAction(title: "Delete Exercise", style: .default, handler: {
         (alert: UIAlertAction!) -> Void in
         print("File Saved")
      })

      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
         (alert: UIAlertAction!) -> Void in
         print("Cancelled")
      })

      optionMenu.addAction(addExerciseAction)
      optionMenu.addAction(deleteExerciseAction)
      optionMenu.addAction(cancelAction)

      self.present(optionMenu, animated: true, completion: nil)

   }

   @objc func handleTapGesture(_ gesture: UITapGestureRecognizer)  {

      let location = gesture.location(in: exerciseView.tableView)
      guard let indexPath = exerciseView.tableView.indexPathForRow(at: location) else {
         return
      }
      let row = indexPath.row

      let cell = exerciseView.tableView.cellForRow(at: indexPath)

      let addExerciseVC = AddExerciseViewController()
      addExerciseVC.modalPresentationStyle = .overFullScreen
      present(addExerciseVC, animated: true, completion: nil)

//      if !exercisesSearchBarController.isEditing {
//         print(exercises[row].exerciseName)
//      }  else  {
//         print(filteredExercises[row].exerciseName)
//      }

   }

   // Takes care of table view
   internal func setData() {

      exercises = [Exercise]()
      filteredExercises = [Exercise]()

      let path = Bundle.main.path(forResource: "exercises", ofType: "json")
      let url = URL(fileURLWithPath: path!)

      do {
         let data = try Data(contentsOf: url)
         let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
         if let dictionary = object as? [String: AnyObject] {
            guard let jsonExercises = object["exercises"] as? [[String: Any]]   else {
               return
            }
            for exercise in jsonExercises {
               let exerciseName = exercise["name"] as! String
               let exerciseMuscleGroup = exercise["muscle"] as! String
               let exerciseType = exercise["type"] as! String
               exercises.append(Exercise(exerciseName: exerciseName, exerciseBodyPart: exerciseMuscleGroup,
                                         exerciseType: exerciseType))
            }
         }

      }  catch {
         print(error)
      }

      let filter = ExerciseFilter(exercises: exercises)
      print(filter.sortCases)

   }



}
