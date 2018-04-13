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

   @IBOutlet weak var exercisesTableView: UITableView!

   override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         prepareSearchBar()

         setData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
   internal func prepareSearchBar() {

      exercisesSearchBarController = ExercisesSearchBarController()
      let searchBarFrame = CGRect(x: 0, y: 20, width: view.bounds.size.width, height: 50)
      exercisesSearchBarController.searchBar.frame = searchBarFrame

      // Access the searchBar.
      guard let searchBar = exercisesSearchBarController?.searchBar else {
         debugPrint("Didn't find search bar")
         return
      }

      view.addSubview(searchBar)

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
      exercisesTableView.reloadData()
   }

   func searchBar(searchBar: SearchBar, didClear textField: UITextField, with text: String?) {
      filteredExercises.removeAll()
      exercisesSearchBarController?.isEditing = false
      if text != nil && text?.count == 0 {
         exercisesSearchBarController.searchBar.endEditing(true)
      }
      exercisesTableView.reloadData()
   }



}

extension ExercisesViewController : UITableViewDelegate, UITableViewDataSource {

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let data = exercises else {
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

      return cell
   }

   // Takes care of table view
   internal func setData() {

      let exerciseNames = ["Deadlift", "Bench Press", "Dips", "Military Press"]
      let exerciseBodyParts = ["Back", "Chest", "Triceps", "Shoulders"]
      var exercises : [Exercise] = [Exercise]()
      filteredExercises = [Exercise]()
      for index in 0...exerciseNames.count-1   {
         let uuid = UUID()
         let exerciseName = exerciseNames[index]
         let exerciseBodyPart = exerciseBodyParts[index]
         let exercise = Exercise(exerciseId: uuid, exerciseName: exerciseName,
                                 exerciseBodyPart: exerciseBodyPart)
         exercises.append(exercise)
      }
      self.exercises = exercises
      exercisesTableView.delegate = self
      exercisesTableView.dataSource = self
      exercisesTableView.reloadData()
   }

}
