//
//  StrengthExerciseSetRow.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 5/8/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import Foundation
import Eureka

public class _StrengthExerciseSetRow: Row<StrengthExerciseSetCell> {

   public required init(tag: String?) {

      super.init(tag: tag)

      if section != nil {
         print(section?.tag)
      }

      if tag != nil {
         print(tag)
      }

      // The cellProvider is what we use to "connect" the nib file with our custom design
      // GenericPasswordCell must be the class of the UITableViewCell contained in the GenericPasswordCell.xib file

   }

   init(tag : String?, workoutId : String, workoutExerciseId : String) {
      super.init(tag: tag)
   }

   public func changeValue(workoutExerciseSetId : String, weightAmount : Float)  {

   }

}

public final class StrengthExerciseSetRow: _StrengthExerciseSetRow, RowType { }
