import UIKit
import Eureka

public class ExercisePushViewController: SelectorViewController<SelectorRow<PushSelectorCell<Exercise>>>, UISearchBarDelegate {

   var exercises : [Exercise]?
   var searchController: UISearchController!

   public override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
   }

   public override func viewDidLoad() {
      super.viewDidLoad()
   }

   public override func viewWillAppear(_ animated: Bool) {
      fetchExercises()
      setUpSearchBar()
   }

   func fetchExercises()   {
      do {
         form.removeAll()
         exercises = try ExerciseTable.getAllExercises()
         setupForm(with: exercises!)
         tableView.reloadData()
      } catch {
         exercises = [Exercise]()
      }
   }

   func setUpSearchBar()   {
      searchController = UISearchController(searchResultsController: nil)
      searchController.searchBar.delegate = self
      searchController.dimsBackgroundDuringPresentation = false
      navigationItem.titleView = searchController.searchBar
      let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewExercise))
      navigationItem.rightBarButtonItem = addButton
      searchController.searchBar.sizeToFit()
      searchController.hidesNavigationBarDuringPresentation = false
   }

   public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      guard let searchBarText = searchBar.text?.lowercased() else {
         return
      }
      guard searchBarText.count > 0 else {
         form.removeAll()
         fetchExercises()
         tableView.reloadData()
         return
      }

      form.removeAll()
      tableView.reloadData()

      do {
         guard let originalExercises = try ExerciseTable.getAllExercises() else {
            return
         }
         exercises = originalExercises.filter{ exercise in
            return (exercise.exerciseName?.lowercased().contains(searchBarText))!
         }
         setupForm(with: exercises!)
         tableView.reloadData()
      } catch {
         print(error.localizedDescription)
         form.removeAll()
         tableView.reloadData()
         fetchExercises()
         tableView.reloadData()
      }

   }

   public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      fetchExercises()
   }

   @objc func createNewExercise()   {
      form.removeAll()
      tableView.reloadData()
      let addExerciseVC = AddExerciseViewController()
      self.searchController.isActive = false
      navigationController?.pushViewController(addExerciseVC, animated: true)
   }

}


