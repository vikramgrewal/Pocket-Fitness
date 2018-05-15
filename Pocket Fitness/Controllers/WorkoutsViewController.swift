//
//  WorkoutsViewController.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 4/24/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import UIKit
import Koyomi
import SQLite
import SwipeCellKit

class WorkoutsViewController: UIViewController {

   var searchController : UISearchController!
   var tableViewController : UITableViewController!
   var calendarHeightConstraint : NSLayoutConstraint!
   var calendarMonthLabel : UILabel!
   var koyomi : Koyomi!
   var calendarView : UIView!
   var workouts : [Workout]?
   var workoutsTableViewModel : WorkoutsTableViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

      // TODO: Implement log in functionality to check if user is logged in.
      // If the user is not logged in, make sure to prompt the login view controller.
      // If the user is logged in the person will be prompted if they want to insert
      // default exercises into database

      setUpView()
      fetchData()

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
      definesPresentationContext = false
      extendedLayoutIncludesOpaqueBars = !(navigationController?.navigationBar.isTranslucent)!
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

extension WorkoutsViewController {

   func setUpSearchBar()   {
      searchController = UISearchController(searchResultsController: nil)
//      searchController.searchBar.sizeToFit()
//      navigationItem.titleView = searchController.searchBar
      navigationItem.leftBarButtonItem = UIBarButtonItem(title: "C", style: .plain, target: self, action: nil)
      let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewWorkout))
      navigationItem.rightBarButtonItem = addButton
      searchController.hidesNavigationBarDuringPresentation = false
      navigationItem.leftBarButtonItem?.action = #selector(toggleCalendar)
   }



   @objc func addNewWorkout() {

      DispatchQueue.main.async(execute: {
         // Create a new workout in the database and pass that workout object to next view controller
         guard let workout = Workout.insertNewWorkout() else {
            return
         }
         let editWorkoutVC = EditWorkoutViewController()
         editWorkoutVC.workout = workout
         self.navigationController?.pushViewController(editWorkoutVC, animated: true)
      })
      
   }

}

extension WorkoutsViewController {

   func setUpCalendar() {
      calendarView = UIView()
      view.addSubview(calendarView)
      calendarView.translatesAutoresizingMaskIntoConstraints = false
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
      calendarMonthLabel = UILabel()
      calendarView.addSubview(calendarMonthLabel)
      calendarMonthLabel.textColor = .white
      calendarMonthLabel.backgroundColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 141.0/255.0, alpha: 1.0)
      calendarMonthLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
      calendarMonthLabel.alpha = 0.0
      calendarMonthLabel.isHidden = true
      calendarMonthLabel.translatesAutoresizingMaskIntoConstraints = false
      calendarMonthLabel.topAnchor.constraint(equalTo: calendarView.topAnchor).isActive = true
      calendarMonthLabel.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor).isActive = true
      calendarMonthLabel.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor).isActive = true
      calendarMonthLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
      calendarMonthLabel.textAlignment = .center
      koyomi = Koyomi(frame: .zero, sectionSpace: 1.5, cellSpace: 0.5, inset: .init(top: 1, left: 1, bottom: 1, right: 1), weekCellHeight: 25)
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
      resetLabelText()
      calendarView.addSubview(koyomi)
      koyomi.translatesAutoresizingMaskIntoConstraints = false
      koyomi.topAnchor.constraint(equalTo: calendarView.topAnchor, constant:30.0).isActive = true
      koyomi.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor).isActive = true
      koyomi.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor).isActive = true
      koyomi.heightAnchor.constraint(equalToConstant: 175).isActive = true

      let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(calendarSwipeGesture))
      swipeRight.direction = UISwipeGestureRecognizerDirection.right
      koyomi.addGestureRecognizer(swipeRight)

      let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(calendarSwipeGesture))
      swipeLeft.direction = UISwipeGestureRecognizerDirection.left
      koyomi.addGestureRecognizer(swipeLeft)
   }



   @objc func calendarSwipeGesture(gesture: UIGestureRecognizer) {

      if let swipeGesture = gesture as? UISwipeGestureRecognizer {

         switch swipeGesture.direction {
         case UISwipeGestureRecognizerDirection.right:
            koyomi.display(in: .previous)
         case UISwipeGestureRecognizerDirection.left:
            koyomi.display(in: .next)
         default:
            break
         }
         resetLabelText()
      }
   }

   func resetLabelText()   {
      calendarMonthLabel.text = koyomi.currentDateString(withFormat: "MMMM") + " " +
         koyomi.currentDateString(withFormat: "YYYY")
   }

   @objc func toggleCalendar()   {
      if(calendarHeightConstraint.constant == 0)  {
         calendarHeightConstraint.constant = 205
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

extension WorkoutsViewController : UITableViewDelegate, UITableViewDataSource {

   func fetchData() {
      workoutsTableViewModel = WorkoutsTableViewModel()
      workouts = Workout.getAllWorkouts()
      guard workouts != nil else {
         tableViewController.tableView.reloadData()
         return
      }
      workoutsTableViewModel?.workouts = workouts
      for workout in workouts! {
         guard let workoutId = workout.workoutId else {
            return
         }
         workoutsTableViewModel?.setLabels?.append("0")
      }
      tableViewController.tableView.reloadData()
   }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let workoutCount = workoutsTableViewModel?.workouts?.count else {
         return 0
      }
      return workoutCount
   }

   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      DispatchQueue.main.async(execute: {
         guard let workout = self.workoutsTableViewModel?.workouts?[indexPath.row] else {
            return
         }
         let editWorkoutVC = EditWorkoutViewController()
         editWorkoutVC.workout = workout
         self.navigationController?.pushViewController(editWorkoutVC, animated: true)
      })
   }


   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 70.0
   }

   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

      guard orientation == .right else { return nil }

      let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
         do {
            guard let workoutToDelete = self.workouts?[indexPath.row] else {
               return
            }
            self.view.window?.isUserInteractionEnabled = false
//            try Exercise.deleteExercise(exercise: exerciseToDelete)
            self.fetchData()
            self.view.window?.isUserInteractionEnabled = true
         } catch {
            self.view.window?.isUserInteractionEnabled = true
            print(error.localizedDescription)
         }
      }

      return [deleteAction]
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = SwipeTableViewCell(style: .default, reuseIdentifier: nil)
      cell.backgroundColor = .white

      let dateView = UIView()
      dateView.backgroundColor = .clear
      cell.addSubview(dateView)
      dateView.translatesAutoresizingMaskIntoConstraints = false
      dateView.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
      dateView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
      dateView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
      dateView.widthAnchor.constraint(equalToConstant: 70.0).isActive = true

      // TODO: Get the month and format all the part of the date you will need to do

      let dayLabel = UILabel()
      dayLabel.backgroundColor = .clear
      dateView.addSubview(dayLabel)
      dayLabel.text = ""
      dayLabel.textAlignment = .center
      dayLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
      dayLabel.translatesAutoresizingMaskIntoConstraints = false
      dayLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor).isActive = true
      dayLabel.trailingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
      dayLabel.centerYAnchor.constraint(equalTo: dateView.centerYAnchor).isActive = true
      dayLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

      let monthLabel = UILabel()
      monthLabel.backgroundColor = .clear
      dateView.addSubview(monthLabel)
      monthLabel.text = ""
      monthLabel.textAlignment = .center
      monthLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
      monthLabel.translatesAutoresizingMaskIntoConstraints = false
      monthLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor).isActive = true
      monthLabel.trailingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
      monthLabel.bottomAnchor.constraint(equalTo: dayLabel.topAnchor).isActive = true
      monthLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true

      let yearLabel = UILabel()
      yearLabel.backgroundColor = .clear
      dateView.addSubview(yearLabel)
      yearLabel.text = ""
      yearLabel.textAlignment = .center
      yearLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
      yearLabel.translatesAutoresizingMaskIntoConstraints = false
      yearLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor).isActive = true
      yearLabel.trailingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
      yearLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
      yearLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor).isActive = true

      let workoutLabel = UILabel()
      workoutLabel.backgroundColor = .clear
      cell.addSubview(workoutLabel)
      workoutLabel.text = workoutsTableViewModel?.workouts![indexPath.row].workoutName
      workoutLabel.textAlignment = .left
      workoutLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
      workoutLabel.translatesAutoresizingMaskIntoConstraints = false
      workoutLabel.leadingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
      workoutLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant: 7.5).isActive = true
      workoutLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
      workoutLabel.bottomAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true

      let workoutSetsLabel = UILabel()
      workoutSetsLabel.backgroundColor = .clear
      cell.addSubview(workoutSetsLabel)
      cell.addSubview(workoutSetsLabel)
      let exercisesLabel = workoutsTableViewModel?.setLabels![indexPath.row] ?? "0"
      workoutSetsLabel.text = "\(exercisesLabel) Exercises"
      workoutSetsLabel.textAlignment = .left
      workoutSetsLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 14.0)
      workoutSetsLabel.textColor = .lightGray
      workoutSetsLabel.translatesAutoresizingMaskIntoConstraints = false
      workoutSetsLabel.leadingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
      workoutSetsLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
      workoutSetsLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
      workoutSetsLabel.topAnchor.constraint(equalTo: workoutLabel.bottomAnchor).isActive = true

      if let workoutDate = workoutsTableViewModel?.workouts?[indexPath.row].workoutDate {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "dd"
         let dayString = dateFormatter.string(from: workoutDate)

         dateFormatter.dateFormat = "MMMM"
         let monthString = dateFormatter.string(from: workoutDate)

         dateFormatter.dateFormat = "YYYY"
         let yearString = dateFormatter.string(from: workoutDate)

         dayLabel.text = dayString
         monthLabel.text = monthString
         yearLabel.text = yearString

      }

      return cell
   }


   func setUpTableView()   {
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

}
