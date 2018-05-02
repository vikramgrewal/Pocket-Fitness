//
//  ExerciseFilter.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 4/15/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import Foundation

class ExerciseFilter {

   var exercises : [Exercise]!

   var sortCases : [String : Int] = [ : ]
   var appliedFilters : [Int]!

   init(exercises : [Exercise]) {
      self.exercises = exercises
      setDefaultSortCases()
   }

   func setDefaultSortCases()   {
      sortCases = [:]
      var startFilterCase : Int = 0
      for exercise in exercises  {
         let muscle = exercise.exerciseBodyPart
         if(sortCases[muscle] == nil)   {
            sortCases[muscle] = startFilterCase
            startFilterCase += 1
         }
      }
   }

   func addExerciseToFilter(exercise : Exercise)   {
      exercises.append(exercise)
      var max : Int = 0
      for keys in sortCases.keys {
         let value = sortCases[keys]!
         max = value > max ? value : max
      }
      let muscle = exercise.exerciseBodyPart
      if(sortCases[muscle] == nil)  {
         sortCases[muscle] = max + 1
      }
   }

}
