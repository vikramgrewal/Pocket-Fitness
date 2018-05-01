//
//  WorkoutsViewController.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 4/24/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import UIKit
import SwipeCellKit
import Koyomi

class WorkoutsViewController: UIViewController {

   var searchController : UISearchController!
   var tableViewController : UITableViewController!
   var calendarHeightConstraint : NSLayoutConstraint!
   var calendarMonthLabel : UILabel!
   var koyomi : Koyomi!
   var calendarView : UIView!
   var workouts : [Workout]?

    override func viewDidLoad() {
        super.viewDidLoad()

      initializeTestData()
      setUpView()

      // Do any additional setup after loading the view.
    }

   override func viewWillAppear(_ animated: Bool) {
      if let index = tableViewController.tableView.indexPathForSelectedRow{
         tableViewController.tableView.deselectRow(at: index, animated: true)
      }
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   func initializeTestData()   {
      workouts = [Workout]()
      workouts!.append(Workout(name: "Chest", month: "Jan", day: "17", year: "2017"))
      workouts!.append(Workout(name: "Tris", month: "Jan", day: "16", year: "2017"))
      workouts!.append(Workout(name: "Legs", month: "Jan", day: "15", year: "2017"))
      workouts!.append(Workout(name: "Legs", month: "Jan", day: "14", year: "2017"))
      workouts!.append(Workout(name: "Arms", month: "Jan", day: "13", year: "2017"))
      workouts!.append(Workout(name: "Speed Work", month: "Jan", day: "12", year: "2017"))
      workouts!.append(Workout(name: "Hamstrings", month: "Jan", day: "11", year: "2017"))
      workouts!.append(Workout(name: "Basketball Training", month: "Jan", day: "10", year: "2017"))
   }

   func setUpView()  {
      title = "Workouts"
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
      searchController.searchBar.sizeToFit()
      navigationItem.titleView = searchController.searchBar
      navigationItem.leftBarButtonItem = UIBarButtonItem(title: "C", style: .plain, target: self, action: nil)
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: nil)
      searchController.hidesNavigationBarDuringPresentation = false
      navigationItem.leftBarButtonItem?.action = #selector(toggleCalendar)
      navigationItem.rightBarButtonItem?.action = #selector(addNewWorkout)
   }

   @objc func toggleCalendar()   {
      if(calendarHeightConstraint.constant == 0)  {
         calendarHeightConstraint.constant = 225
         koyomi.isHidden = false
         calendarMonthLabel.isHidden = false
      }  else  {
         calendarHeightConstraint.constant = 0
         let deadlineTime = DispatchTime.now() + .milliseconds(500)
         DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.koyomi.display(in: .current)
            self.resetLabelText()
            self.koyomi.isHidden = true
            self.calendarMonthLabel.isHidden = true
         }
      }
      UIView.animate(withDuration: 0.5){
         self.view.layoutIfNeeded()
      }
   }

   @objc func addNewWorkout() {
      DispatchQueue.main.async(execute: {
         let editWorkoutVC = EditWorkoutViewController()
         self.navigationController?.pushViewController(editWorkoutVC, animated: true)
      })
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

}

extension WorkoutsViewController {

   func setUpCalendar() {
      calendarView = UIView()
      view.addSubview(calendarView)
      calendarView.translatesAutoresizingMaskIntoConstraints = false
      calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
      calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
      calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
      calendarHeightConstraint = calendarView.heightAnchor.constraint(equalToConstant: 0)
      calendarHeightConstraint.isActive = true
      calendarMonthLabel = UILabel()
      calendarView.addSubview(calendarMonthLabel)
      calendarMonthLabel.textColor = .black
      calendarMonthLabel.font = UIFont(name: "Helvetica", size: 25)
      calendarMonthLabel.isHidden = true
      calendarMonthLabel.translatesAutoresizingMaskIntoConstraints = false
      calendarMonthLabel.topAnchor.constraint(equalTo: calendarView.topAnchor).isActive = true
      calendarMonthLabel.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor).isActive = true
      calendarMonthLabel.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor).isActive = true
      calendarMonthLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
      calendarMonthLabel.textAlignment = .center
      koyomi = Koyomi(frame: .zero, sectionSpace: 1.5, cellSpace: 0.5, inset: .init(top: 1, left: 1, bottom: 1, right: 1), weekCellHeight: 25)
      koyomi.isHidden = true
      koyomi.selectionMode = .sequence(style: .background)
      koyomi.selectedStyleColor = .lightGray
      koyomi.style = .tealBlue
      resetLabelText()
      calendarView.addSubview(koyomi)
      koyomi.translatesAutoresizingMaskIntoConstraints = false
      koyomi.topAnchor.constraint(equalTo: calendarView.topAnchor, constant:50.0).isActive = true
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
}

extension WorkoutsViewController : UITableViewDelegate, UITableViewDataSource {

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let workouts = self.workouts else {
         return 0
      }
      return workouts.count
   }

   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      DispatchQueue.main.async(execute: {
         let editWorkoutVC = EditWorkoutViewController()
         self.navigationController?.pushViewController(editWorkoutVC, animated: true)
      })
   }


   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 90.0
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
      cell.backgroundColor = .white

      let dateView = UIView()
      dateView.backgroundColor = .clear
      cell.addSubview(dateView)
      dateView.translatesAutoresizingMaskIntoConstraints = false
      dateView.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
      dateView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
      dateView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
      dateView.widthAnchor.constraint(equalToConstant: 90.0).isActive = true

      let dayLabel = UILabel()
      dayLabel.backgroundColor = .clear
      dateView.addSubview(dayLabel)
      dayLabel.text = workouts![indexPath.row].day
      dayLabel.textAlignment = .center
      dayLabel.font = UIFont(name: "Helvetica", size: 22)
      dayLabel.translatesAutoresizingMaskIntoConstraints = false
      dayLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor).isActive = true
//      dayLabel.topAnchor.constraint(equalTo: monthLabel.bottomAnchor).isActive = true
      dayLabel.trailingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
      dayLabel.centerYAnchor.constraint(equalTo: dateView.centerYAnchor)
      dayLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true

      let monthLabel = UILabel()
      monthLabel.backgroundColor = .clear
      dateView.addSubview(monthLabel)
      monthLabel.text = workouts![indexPath.row].month
      monthLabel.textAlignment = .center
      monthLabel.font = UIFont(name: "Helvetica", size: 16)
      monthLabel.translatesAutoresizingMaskIntoConstraints = false
      monthLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor).isActive = true
//      monthLabel.topAnchor.constraint(equalTo: dateView.topAnchor, constant: 5.0).isActive = true
      monthLabel.trailingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
      monthLabel.bottomAnchor.constraint(equalTo: dayLabel.topAnchor).isActive = true
      monthLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
      monthLabel.topAnchor.constraint(equalTo: dayLabel.topAnchor, constant: 15)

      let yearLabel = UILabel()
      yearLabel.backgroundColor = .clear
      dateView.addSubview(yearLabel)
      yearLabel.text = workouts![indexPath.row].year
      yearLabel.textAlignment = .center
      yearLabel.font = UIFont(name: "Helvetica", size: 16)
      yearLabel.translatesAutoresizingMaskIntoConstraints = false
      yearLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor).isActive = true
//      yearLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor).isActive = true
      yearLabel.trailingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
      yearLabel.bottomAnchor.constraint(equalTo: dateView.bottomAnchor, constant: -15.0).isActive = true
      yearLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
      yearLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor).isActive = true

      let workoutLabel = UILabel()
      workoutLabel.backgroundColor = .clear
      cell.addSubview(workoutLabel)
      workoutLabel.text = workouts![indexPath.row].name
      workoutLabel.textAlignment = .left
      workoutLabel.font = UIFont(name: "Helvetica", size: 25)
      workoutLabel.translatesAutoresizingMaskIntoConstraints = false
      workoutLabel.leadingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
      workoutLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant: 7.5).isActive = true
      workoutLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
      workoutLabel.bottomAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true

      let workoutSetsLabel = UILabel()
      workoutSetsLabel.backgroundColor = .clear
      cell.addSubview(workoutSetsLabel)
      cell.addSubview(workoutSetsLabel)
      workoutSetsLabel.text = "5 Sets"
      workoutSetsLabel.textAlignment = .left
      workoutSetsLabel.font = UIFont(name: "Helvetica", size: 16)
      workoutSetsLabel.textColor = .lightGray
      workoutSetsLabel.translatesAutoresizingMaskIntoConstraints = false
      workoutSetsLabel.leadingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
      workoutSetsLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
      workoutSetsLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
      workoutSetsLabel.topAnchor.constraint(equalTo: workoutLabel.bottomAnchor).isActive = true

      return cell
   }


   func setUpTableView()   {
      tableViewController = UITableViewController(style: .plain)
      tableViewController.tableView.estimatedRowHeight = 90.0
      tableViewController.tableView.rowHeight = UITableViewAutomaticDimension
      tableViewController.tableView.backgroundColor = .clear
      tableViewController.tableView.delegate = self
      tableViewController.tableView.dataSource = self
      tableViewController.tableView.separatorStyle = .singleLine
      tableViewController.tableView.separatorInset = UIEdgeInsets(top: 0, left: 90, bottom: 0, right: 0)
      tableViewController.tableView.tableFooterView = UIView()
      tableViewController.tableView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(tableViewController.tableView)
      tableViewController.tableView.leadingAnchor.constraint(equalTo:
         view.safeAreaLayoutGuide.leadingAnchor).isActive = true
      tableViewController.tableView.topAnchor.constraint(equalTo:
         calendarView.bottomAnchor).isActive = true
      tableViewController.tableView.trailingAnchor.constraint(equalTo:
         view.safeAreaLayoutGuide.trailingAnchor).isActive = true
      tableViewController.tableView.bottomAnchor.constraint(equalTo:
         view.safeAreaLayoutGuide.bottomAnchor).isActive = true

   }



}

struct Workout {
   var name, month, day, year : String
}
