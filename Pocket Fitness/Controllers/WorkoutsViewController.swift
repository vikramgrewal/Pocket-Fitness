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
   var koyomi : Koyomi!
   var workouts : [Workout]?

    override func viewDidLoad() {
        super.viewDidLoad()

      initializeTestData()
      setUpView()

      // Do any additional setup after loading the view.
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
   }

   @objc func toggleCalendar()   {
      if(calendarHeightConstraint.constant == 0)  {
         calendarHeightConstraint.constant = 200
      }  else  {
         calendarHeightConstraint.constant = 0
      }
      UIView.animate(withDuration: 0.5){
         self.view.layoutIfNeeded()
      }
   }

}

extension WorkoutsViewController {

   func setUpCalendar() {
      koyomi = Koyomi(frame: .zero, sectionSpace: 1.5, cellSpace: 0.5, inset: .init(top: 1, left: 1, bottom: 1, right: 1), weekCellHeight: 25)
      koyomi.selectionMode = .sequence(style: .background)
      koyomi.selectedStyleColor = .lightGray
      koyomi.style = .tealBlue
      view.addSubview(koyomi)
      koyomi.translatesAutoresizingMaskIntoConstraints = false
      koyomi.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
      koyomi.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
      koyomi.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
      calendarHeightConstraint = NSLayoutConstraint(item: koyomi, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
      calendarHeightConstraint.isActive = true
   }
}

extension WorkoutsViewController : UITableViewDelegate, UITableViewDataSource {

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let workouts = self.workouts else {
         return 0
      }
      return workouts.count
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
      cell.layer.shadowOffset = CGSize(width: 1, height: 1)
      cell.layer.shadowColor = UIColor.black.cgColor
      cell.layer.shadowRadius = 3
      cell.layer.shadowOpacity = 0.25

      let dateView = UIView()
      cell.addSubview(dateView)
      dateView.translatesAutoresizingMaskIntoConstraints = false
      dateView.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
      dateView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
      dateView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
      dateView.widthAnchor.constraint(equalToConstant: 90.0).isActive = true

      let monthLabel = UILabel()
      dateView.addSubview(monthLabel)
      monthLabel.text = workouts![indexPath.row].month
      monthLabel.textAlignment = .center
      monthLabel.font = UIFont(name: "Helvetica", size: 20)
      monthLabel.translatesAutoresizingMaskIntoConstraints = false
      monthLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor).isActive = true
      monthLabel.topAnchor.constraint(equalTo: dateView.topAnchor, constant: 5.0).isActive = true
      monthLabel.trailingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
      monthLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true

      let dayLabel = UILabel()
      dateView.addSubview(dayLabel)
      dayLabel.text = workouts![indexPath.row].day
      dayLabel.textAlignment = .center
      dayLabel.font = UIFont(name: "Helvetica", size: 30)
      dayLabel.translatesAutoresizingMaskIntoConstraints = false
      dayLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor).isActive = true
      dayLabel.topAnchor.constraint(equalTo: monthLabel.bottomAnchor).isActive = true
      dayLabel.trailingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
      dayLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true

      let yearLabel = UILabel()
      dateView.addSubview(yearLabel)
      yearLabel.text = workouts![indexPath.row].year
      yearLabel.textAlignment = .center
      yearLabel.font = UIFont(name: "Helvetica", size: 20)
      yearLabel.translatesAutoresizingMaskIntoConstraints = false
      yearLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor).isActive = true
      yearLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor).isActive = true
      yearLabel.trailingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
      yearLabel.bottomAnchor.constraint(equalTo: dateView.bottomAnchor, constant: -5.0).isActive = true
      yearLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true

      let workoutLabel = UILabel()
      cell.addSubview(workoutLabel)
      workoutLabel.text = workouts![indexPath.row].name
      workoutLabel.textAlignment = .left
      workoutLabel.font = UIFont(name: "Helvetica", size: 30)
      workoutLabel.translatesAutoresizingMaskIntoConstraints = false
      workoutLabel.leadingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
      workoutLabel.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
      workoutLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
      workoutLabel.bottomAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true

      return cell
   }

   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 90.0
   }


   func setUpTableView()   {
      tableViewController = UITableViewController(style: .plain)
      tableViewController.tableView.estimatedRowHeight = 90.0
      tableViewController.tableView.rowHeight = UITableViewAutomaticDimension
      tableViewController.tableView.delegate = self
      tableViewController.tableView.dataSource = self
      tableViewController.tableView.separatorStyle = .none
      tableViewController.tableView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(tableViewController.tableView)
      tableViewController.tableView.leadingAnchor.constraint(equalTo:
         view.safeAreaLayoutGuide.leadingAnchor).isActive = true
      tableViewController.tableView.topAnchor.constraint(equalTo:
         koyomi.bottomAnchor, constant: 5.0).isActive = true
      tableViewController.tableView.trailingAnchor.constraint(equalTo:
         view.safeAreaLayoutGuide.trailingAnchor).isActive = true
      tableViewController.tableView.bottomAnchor.constraint(equalTo:
         view.safeAreaLayoutGuide.bottomAnchor).isActive = true

   }



}

struct Workout {
   var name, month, day, year : String
}
