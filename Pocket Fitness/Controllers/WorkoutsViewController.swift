//
//  WorkoutsViewController.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 4/24/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import UIKit
import SwipeCellKit

class WorkoutsViewController: UIViewController {

   var searchController : UISearchController!
   var tableViewController : UITableViewController!
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
      let contentView = UIView()
      contentView.translatesAutoresizingMaskIntoConstraints = false
      cell.addSubview(contentView)
      cell.selectionStyle = .none
      cell.backgroundColor = .clear
      contentView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 15.0).isActive = true
      contentView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 15.0).isActive = true
      contentView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
      contentView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -15.0).isActive = true
      contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
      contentView.layer.shadowColor = UIColor.black.cgColor
      contentView.layer.shadowRadius = 3
      contentView.layer.shadowOpacity = 0.25
      contentView.backgroundColor = .white
      let dateView = UIView()
      dateView.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(dateView)
      dateView.backgroundColor = .blue
      dateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
      dateView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
      dateView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
      dateView.widthAnchor.constraint(equalToConstant: 90.0).isActive = true
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
         view.safeAreaLayoutGuide.topAnchor).isActive = true
      tableViewController.tableView.trailingAnchor.constraint(equalTo:
         view.safeAreaLayoutGuide.trailingAnchor).isActive = true
      tableViewController.tableView.bottomAnchor.constraint(equalTo:
         view.safeAreaLayoutGuide.bottomAnchor).isActive = true

   }



}

struct Workout {
   var name, month, day, year : String
}
