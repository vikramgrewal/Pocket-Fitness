//
//  Date.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 5/13/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import Foundation

extension Date {
   public static func getDateFromString(date : String) -> Date? {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
      let workoutDate = dateFormatter.date(from: date)
      return workoutDate
   }
}
