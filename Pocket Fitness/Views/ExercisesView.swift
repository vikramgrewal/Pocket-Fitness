//
//  ExercisesView.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 4/16/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import UIKit
import Material

class ExercisesView: UIView {

   var searchBar : SearchBar!
   var tableView : TableView!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

   override init(frame: CGRect) {
      super.init(frame: frame)

      setUpView()
   }

   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }

   func setUpView()  {

      backgroundColor = .white
      setUpSearchBar()
      setUpTableView()

   }


   func setUpSearchBar()   {
      searchBar = SearchBar()
      addSubview(searchBar)
      guard searchBar !== nil else {
         print("Error retrieving search bar")
         return
      }

      let trailing = searchBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
      let leading = searchBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
      let top = searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10)
      let height = NSLayoutConstraint(item: searchBar, attribute: .height,
                                      relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                      multiplier: 1.0, constant: 60)
      let constraints = [leading, top, trailing, height]
      searchBar.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate(constraints)
   }

   func setUpTableView()   {
      tableView = TableView()
      addSubview(tableView)
      guard tableView !== nil else {
         print("Error retrieving table view")
         return
      }
      let trailing = tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
      let leading = tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
      let top = tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10)
      let bottom = tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
      let constraints = [leading, top, trailing, bottom]
      tableView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate(constraints)
   }


}
