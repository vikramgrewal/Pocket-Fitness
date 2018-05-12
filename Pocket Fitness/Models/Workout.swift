//
//  Workout.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 5/11/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import Foundation

public class Workout {
   var workoutId : Int64?
   var workoutName : String?
   var workoutDate : Date?
   var workoutNotes : String?
   var userId : Int64?
   var userWeight : Double?

   init(workoutId : Int64?, workoutName : String?, workoutDate: Date?,
      workoutNotes : String?, userId :Int64?, userWeight : Double?)   {
      self.workoutId = workoutId
      self.workoutName = workoutName
      self.workoutDate = workoutDate
      self.workoutNotes = workoutNotes
      self.userId = userId
      self.userWeight = userWeight
   }
}
