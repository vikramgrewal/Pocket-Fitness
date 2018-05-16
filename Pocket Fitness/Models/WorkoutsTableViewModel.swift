//
//  WorkoutsViewModel.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 5/14/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import Foundation

public class WorkoutsTableViewModel {
   var workouts : [Workout]?
   var setLabels : [String]?

   init()   {
      workouts = [Workout]()
      setLabels = [String]()
   }
}
