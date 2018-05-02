//
//  ExerciseSetCustomCell.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 5/2/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import UIKit
import Eureka

final class ExerciseSetCustomCell: Cell<ExerciseSet>, CellType, UIPickerViewDelegate, UIPickerViewDataSource {

   var weightPicker, setsPicker : UIPickerView!

   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }

   required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
      fatalError("init(style:reuseIdentifier:) has not been implemented")
   }

   override func setup() {
      weightPicker = UIPickerView()
      contentView.addSubview(weightPicker)
   }

   func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 2
   }

   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return 1000
   }
}

final class ExerciseSetCustomRow: Row<ExerciseSetCustomCell>, RowType {
   required init(tag: String?) {
      super.init(tag: tag)
   }
}

class ExerciseSet : Equatable {
   static func == (lhs: ExerciseSet, rhs: ExerciseSet) -> Bool {
      if (lhs.id == rhs.id) { return true }

      return false
   }

   var weight, set : Int?
   var id : String!
   var superset : Bool!
}
