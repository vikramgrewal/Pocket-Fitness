import UIKit
import Koyomi
import SwipeCellKit

class WorkoutsViewController: UIViewController {

   var searchController : UISearchController!
   var tableViewController : UITableViewController!
   var calendarMonthLabel : UILabel!
   var koyomi : Koyomi!
   var calendarView : UIView!
   var workoutsTableViewModel : WorkoutsTableViewModel?
   var calendarHeightConstraint : NSLayoutConstraint!

    override func viewDidLoad() {
         super.viewDidLoad()
         setUpView()
      // Do any additional setup after loading the view.
    }

   override func viewWillAppear(_ animated: Bool) {
      if let index = tableViewController.tableView.indexPathForSelectedRow{
         tableViewController.tableView.deselectRow(at: index, animated: true)
      }
      fetchData()
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   func setUpView()  {
      view.backgroundColor = .white
      setUpSearchBar()
      setUpCalendar()
      setUpTableView()
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

// TODO: Implement search bar functionality and adapt search bar delegate
extension WorkoutsViewController : SwipeTableViewCellDelegate {

   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

   guard orientation == .right else { return nil }

      let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
         do {
            guard let workoutTableViewCellModel = self.workoutsTableViewModel?.workoutTableViewCellsModel![indexPath.row] else {
               return
            }

            guard let workout = workoutTableViewCellModel.workout else {
               return
            }

            try WorkoutTable.deleteWorkout(workout: workout)
            self.workoutsTableViewModel?.workoutTableViewCellsModel?.remove(at: indexPath.row)
            self.tableViewController.tableView.reloadData()
         } catch {
            print(error.localizedDescription)
         }
      }

      return [deleteAction]
   }

   func setUpSearchBar()   {
      // TODO: Implement search bar and search functionality of workouts
      searchController = UISearchController(searchResultsController: nil)
      // Instantiate add button for exercises
      let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewWorkout))
      // Setup properties for add button below this line if customization is needed
      // Sets the navigation right bar button item to the add button
      navigationItem.rightBarButtonItem = addButton
      searchController.hidesNavigationBarDuringPresentation = false
      // TODO: Implement search bar functionality enable if functional
//      searchController.searchBar.sizeToFit()
      //Sets the center of a navigation bar to the search bar
//      navigationItem.titleView = searchController.searchBar
      // This will enable the koyomi calendar constraints
//      navigationItem.leftBarButtonItem = UIBarButtonItem(title: "C", style: .plain, target: self, action: nil)
//      navigationItem.leftBarButtonItem?.action = #selector(toggleCalendar)
   }

   // Action for right bar button item to add a new workout to database
   @objc func addNewWorkout() {

      // Perform off main thread to ensure no freezes happen
      DispatchQueue.main.async{
         // Create a new workout in the database and pass that workout object to next view controller
         do {
            let workout = try WorkoutTable.insertNewWorkout()

            // Instantiate edit workout view controller with workout, so user
            // can edit workout without having to load. Possibly put indicator view
            let editWorkoutVC = EditWorkoutViewController()
            editWorkoutVC.workout = workout
            self.navigationController?.pushViewController(editWorkoutVC, animated: true)
         } catch {
            print(error)
         }
      }
      
   }

}

// TODO: Adapt koyomi calendar delegate for filtering workouts for dates
extension WorkoutsViewController {

   func setUpCalendar() {
      // Instantiate calendar UIView
      calendarView = UIView()
      // Set to false since programatically creating
      calendarView.translatesAutoresizingMaskIntoConstraints = false
      // Add to view controller view
      view.addSubview(calendarView)
      // Set up constraints
      // TODO: Adapt for versions before IOS11
      if #available(iOS 11.0, *) {
         calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
         calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
         calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
      } else {
         calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
         calendarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
         calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      }
      calendarHeightConstraint = calendarView.heightAnchor.constraint(equalToConstant: 0)
      calendarHeightConstraint.isActive = true

      // Create a label for the month title
      calendarMonthLabel = UILabel()
      // Set all calendar month label properties below
      calendarMonthLabel.textColor = .white
      calendarMonthLabel.backgroundColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 141.0/255.0, alpha: 1.0)
      calendarMonthLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
      calendarMonthLabel.alpha = 0.0
      calendarMonthLabel.isHidden = true
      calendarMonthLabel.textAlignment = .center
      // Set to false since programatically creating view
      calendarMonthLabel.translatesAutoresizingMaskIntoConstraints = false
      // Add month label to calendar view to share constraints (common ancestors)
      calendarView.addSubview(calendarMonthLabel)
      // Set month label constraints below
      calendarMonthLabel.topAnchor.constraint(equalTo: calendarView.topAnchor).isActive = true
      calendarMonthLabel.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor).isActive = true
      calendarMonthLabel.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor).isActive = true
      calendarMonthLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
      // Instantiate koyomi calendar with proper initialization method
      koyomi = Koyomi(frame: .zero, sectionSpace: 1.5, cellSpace: 0.5, inset: .init(top: 1, left: 1, bottom: 1, right: 1), weekCellHeight: 25)
      // Set koyomi calendar properties below
      koyomi.setDayFont(fontName: "HelveticaNeue-Bold", size: 15.0)
      koyomi.setWeekFont(fontName: "HelveticaNeue-Bold", size: 15.0)
      koyomi.alpha = 0.0
      koyomi.isHidden = true
      koyomi.selectionMode = .sequence(style: .background)
      koyomi.selectedStyleColor = UIColor(red: 255.0/255.0, green: 198.0/255.0, blue: 99.0/255.0, alpha: 1.0)
      koyomi.weekColor = .white
      koyomi.weekBackgrondColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 141.0/255.0, alpha: 1.0)
      koyomi.holidayColor.saturday = .darkGray
      koyomi.holidayColor.sunday = .darkGray
      koyomi.separatorColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 141.0/255.0, alpha: 1.0)
      // This formats the calendar month label to the correct appearance
      resetLabelText()
      // Set to false since programatically creating view
      koyomi.translatesAutoresizingMaskIntoConstraints = false
      // Add koyomi calendar to calendar view
      calendarView.addSubview(koyomi)
      // Set all calendar constraints below
      koyomi.topAnchor.constraint(equalTo: calendarView.topAnchor, constant:30.0).isActive = true
      koyomi.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor).isActive = true
      koyomi.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor).isActive = true
      koyomi.heightAnchor.constraint(equalToConstant: 175).isActive = true

      // Adds gesture recognizers for swipe left and right on calendar to allow
      // changing months without clicking buttons
      let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(calendarSwipeGesture))
      swipeRight.direction = UISwipeGestureRecognizerDirection.right
      koyomi.addGestureRecognizer(swipeRight)

      let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(calendarSwipeGesture))
      swipeLeft.direction = UISwipeGestureRecognizerDirection.left
      koyomi.addGestureRecognizer(swipeLeft)
   }

   // Sets the month label to desired format
   func resetLabelText()   {
      calendarMonthLabel.text = koyomi.currentDateString(withFormat: "MMMM") + " " +
         koyomi.currentDateString(withFormat: "YYYY")
   }

   // Calls koyomi display method which will change month of calendar
   @objc func calendarSwipeGesture(gesture: UIGestureRecognizer) {

      if let swipeGesture = gesture as? UISwipeGestureRecognizer {

         // Switch case to see which swipe gesture direction was detected
         switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
               koyomi.display(in: .previous)
            case UISwipeGestureRecognizerDirection.left:
               koyomi.display(in: .next)
            default:
               break
         }
         // Resets month label to correct label after swipe
         resetLabelText()
      }
   }

   // Allows toggling the calendar view after pressing navigation bar button
   @objc func toggleCalendar()   {
      if(calendarHeightConstraint.constant == 0)  {
         calendarHeightConstraint.constant = 205
         // Method below will animate a fade in and update constraints of calendar view
         self.koyomi.isHidden = false
         self.calendarMonthLabel.isHidden = false
         UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.koyomi.alpha = 1
            self.calendarMonthLabel.alpha = 1
            self.view.layoutIfNeeded()
         })
      }  else  {
         calendarHeightConstraint.constant = 0
         koyomi.display(in: .current)
         resetLabelText()
         // Method below will animate a fade out and update constraints of calendar view
         UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.koyomi.alpha = 0
            self.calendarMonthLabel.alpha = 0
            self.view.layoutIfNeeded()
         }, completion: { _ in
            self.koyomi.isHidden = true
            self.calendarMonthLabel.isHidden = true
         })
      }
   }

}

// TODO: Implement database fetch query and create swipeablecellkit
extension WorkoutsViewController : UITableViewDelegate, UITableViewDataSource {

   func setUpTableView()   {
      // Instaintiate table view
      tableViewController = UITableViewController(style: .plain)
      tableViewController.tableView.estimatedRowHeight = 70.0
      tableViewController.tableView.rowHeight = UITableViewAutomaticDimension
      tableViewController.tableView.backgroundColor = .clear
      tableViewController.tableView.delegate = self
      tableViewController.tableView.dataSource = self
      tableViewController.tableView.separatorStyle = .singleLine
      tableViewController.tableView.separatorInset = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 0)
      tableViewController.tableView.tableFooterView = UIView()
      tableViewController.tableView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(tableViewController.tableView)
      if #available(iOS 11.0, *) {
         tableViewController.tableView.leadingAnchor.constraint(equalTo:
            view.safeAreaLayoutGuide.leadingAnchor).isActive = true
         tableViewController.tableView.topAnchor.constraint(equalTo:
            calendarView.bottomAnchor).isActive = true
         tableViewController.tableView.trailingAnchor.constraint(equalTo:
            view.safeAreaLayoutGuide.trailingAnchor).isActive = true
         tableViewController.tableView.bottomAnchor.constraint(equalTo:
            view.safeAreaLayoutGuide.bottomAnchor).isActive = true
      } else {
         tableViewController.tableView.leadingAnchor.constraint(equalTo:
            view.leadingAnchor).isActive = true
         tableViewController.tableView.topAnchor.constraint(equalTo:
            calendarView.bottomAnchor).isActive = true
         tableViewController.tableView.trailingAnchor.constraint(equalTo:
            view.trailingAnchor).isActive = true
         tableViewController.tableView.bottomAnchor.constraint(equalTo:
            view.bottomAnchor).isActive = true
      }


   }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let workoutCount = workoutsTableViewModel?.workoutTableViewCellsModel?.count else {
         return 0
      }
      return workoutCount
   }

   // Instantiates view controller off main thread with workout data and pushes
   // to navigationcontroller
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

      // Access data model for tableview cell
      let workoutTableViewCellModel = workoutsTableViewModel?.workoutTableViewCellsModel![indexPath.row]

      DispatchQueue.main.async(execute: {
         guard let workout = workoutTableViewCellModel?.workout else {
            return
         }
         let editWorkoutVC = EditWorkoutViewController()
         editWorkoutVC.workout = workout
         self.navigationController?.pushViewController(editWorkoutVC, animated: true)
      })
   }

   // Returns the desired height for tableviewcell
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 70.0
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      // Instantiate tableview cell with a default style
      let cell = SwipeTableViewCell(style: .default, reuseIdentifier: nil)
      // Handle all cell properties below
      cell.backgroundColor = .white
      cell.delegate = self

      // Connect data model for tableview cell
      let workoutTableViewCellModel = workoutsTableViewModel?.workoutTableViewCellsModel![indexPath.row]

      // Instantiate a uiview to hold the date label for each cell
      let dateView = UIView()
      // Set all date view properties below
      dateView.backgroundColor = .clear
      // Set to false since view is created programatically
      dateView.translatesAutoresizingMaskIntoConstraints = false
      // Add view to cell
      cell.addSubview(dateView)
      // Set constraints for date view below
      dateView.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
      dateView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
      dateView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
      dateView.widthAnchor.constraint(equalToConstant: 70.0).isActive = true

      // Create day label section to add to date view
      let dayLabel = UILabel()
      // Set all day label properties below
      dayLabel.backgroundColor = .clear
      dayLabel.text = ""
      dayLabel.textAlignment = .center
      dayLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
      // Set to false snce programatically creating view
      dayLabel.translatesAutoresizingMaskIntoConstraints = false
      // Add day label to date view
      dateView.addSubview(dayLabel)
      // Set all constraints for day labe below
      dayLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor).isActive = true
      dayLabel.trailingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
      dayLabel.centerYAnchor.constraint(equalTo: dateView.centerYAnchor).isActive = true
      dayLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

      // Create month label section to add to date view
      let monthLabel = UILabel()
      // Set all month label properties below
      monthLabel.backgroundColor = .clear
      monthLabel.text = ""
      monthLabel.textAlignment = .center
      monthLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
      // Set to false since programaticaaly creating view
      monthLabel.translatesAutoresizingMaskIntoConstraints = false
      // Add month label to date view
      dateView.addSubview(monthLabel)
      // Set all constraints for month label below
      monthLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor).isActive = true
      monthLabel.trailingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
      monthLabel.bottomAnchor.constraint(equalTo: dayLabel.topAnchor).isActive = true
      monthLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true

      // Create year label section to add to date view
      let yearLabel = UILabel()
      // Set all year label properties below
      yearLabel.backgroundColor = .clear
      yearLabel.textAlignment = .center
      yearLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
      yearLabel.text = ""
      // Set to false since programatically creating view
      yearLabel.translatesAutoresizingMaskIntoConstraints = false
      // Add year label to date view
      dateView.addSubview(yearLabel)
      // Set all constraints for year label below
      yearLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor).isActive = true
      yearLabel.trailingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
      yearLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
      yearLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor).isActive = true

      // Create workout label with name and exercises for cell
      let workoutLabel = UILabel()
      // Set all workout label properties below
      workoutLabel.backgroundColor = .clear
      workoutLabel.text = workoutTableViewCellModel?.workout?.workoutName ?? ""
      workoutLabel.textAlignment = .left
      workoutLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
      // Set to false since programatically creating view
      workoutLabel.translatesAutoresizingMaskIntoConstraints = false
      // Add workout label to cell
      cell.addSubview(workoutLabel)
      // Set all workout label constraints below
      workoutLabel.leadingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
      workoutLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant: 7.5).isActive = true
      workoutLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
      workoutLabel.bottomAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true

      // Create workout sets label for workout label
      let workoutSetsLabel = UILabel()
      // Set all workout sets label properties below
      workoutSetsLabel.backgroundColor = .clear
      let exercisesLabel = workoutTableViewCellModel?.labelText ?? "0"
      workoutSetsLabel.text = "\(exercisesLabel) Exercises"
      workoutSetsLabel.textAlignment = .left
      workoutSetsLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 14.0)
      workoutSetsLabel.textColor = .lightGray
      // Set to false since programatically creating view
      workoutSetsLabel.translatesAutoresizingMaskIntoConstraints = false
      // Add view to cell
      cell.addSubview(workoutSetsLabel)
      // Set up workouts sets label below
      workoutSetsLabel.leadingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
      workoutSetsLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
      workoutSetsLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
      workoutSetsLabel.topAnchor.constraint(equalTo: workoutLabel.bottomAnchor).isActive = true

      // Check if our workout date is a nil value before changing the label
      if let workoutDate = workoutTableViewCellModel?.workout?.workoutDate {

         // Format the date into three sections for our month, day, and year labels
         let dateFormatter = DateFormatter()
         // Represent day in 2 digit date
         dateFormatter.dateFormat = "dd"
         let dayString = dateFormatter.string(from: workoutDate)

         // Represent month in 3 letters
         dateFormatter.dateFormat = "MMMM"
         let monthString = dateFormatter.string(from: workoutDate)

         // Represent year in 4 digits
         dateFormatter.dateFormat = "YYYY"
         let yearString = dateFormatter.string(from: workoutDate)

         // Set all our labels to the correct label values
         dayLabel.text = dayString
         monthLabel.text = monthString
         yearLabel.text = yearString

      }

      return cell
   }

   func fetchData() {
      DispatchQueue.main.async {
         do {
            // Fetch our data model from our sqlite database off main thread
            self.workoutsTableViewModel = try WorkoutsTableViewModel.getWorkoutTableViewModel()
            let range = NSMakeRange(0, self.tableViewController.tableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.tableViewController.tableView.reloadSections(sections as IndexSet, with: .automatic)
         } catch {
            // If any errors go wrong do not do anything except maybe alert the user
            print(error)
         }
      }
   }

}


