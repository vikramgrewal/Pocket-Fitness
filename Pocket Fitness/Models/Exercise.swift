//
//  Exercises.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 4/12/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import Foundation

struct Exercise : Decodable {
   
   var exerciseName, exerciseBodyPart, exerciseType : String

   private enum CodingKeys : String, CodingKey {
      case exerciseName = "name", exerciseBodyPart = "muslce", exerciseType = "type"
   }

}
