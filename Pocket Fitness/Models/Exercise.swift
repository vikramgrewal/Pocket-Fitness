//
//  Exercise.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 5/10/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import Foundation

class Exercise {

   var exerciseId : Int64, exerciseName : String,
   exerciseMuscle : String, exerciseType : String

   init(exerciseId : Int64, exerciseName : String, exerciseMuscle : String, exerciseType : String) {
      self.exerciseId = exerciseId
      self.exerciseName = exerciseName
      self.exerciseMuscle = exerciseMuscle
      self.exerciseType = exerciseType
   }
}

extension Exercise : Equatable {
   
   static func == (lhs: Exercise, rhs: Exercise) -> Bool {
      return lhs.exerciseName == rhs.exerciseName
   }

}
