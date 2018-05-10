//
//  StrengthExerciseSetCell.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 5/8/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import Foundation
import Eureka

public class StrengthExerciseSetCell: Cell<String>, CellType {

   // Outlets to be connected with our nib file views.
   var weightsViewAmount : UITextField!
   var repsViewAmount : UITextField!

   // Computed property in order to access to the properties of our Row
   var strengthExerciseSetRow: _StrengthExerciseSetRow {
      return row as! _StrengthExerciseSetRow
   }

   // Since we will be updating the cell height depending on the hidden
   // state of the hintLabel, we need to have two height values available
   // and set the `height` closure of Eureka's cells with those.

   // Cell's constructor
   public required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
   }

   public required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }

   // MARK - Overrides

   // Here we will setup our cell's behavior and style.
   public override func setup() {
      super.setup()

      height = { 44 }
      selectionStyle = .none

      let weightsTextfieldLabel = UITextField()
      weightsTextfieldLabel.textColor = .gray
      weightsTextfieldLabel.text = "Weight"
      weightsTextfieldLabel.isUserInteractionEnabled = false
      weightsTextfieldLabel.translatesAutoresizingMaskIntoConstraints = false

      addSubview(weightsTextfieldLabel)

      weightsTextfieldLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23).isActive = true
      weightsTextfieldLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
      weightsTextfieldLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
      weightsTextfieldLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true

      weightsViewAmount = UITextField()
//      weightsViewAmount.keyboardType = .decimalPad
      weightsViewAmount.isUserInteractionEnabled = false
      weightsViewAmount.placeholder = "0"
      weightsViewAmount.translatesAutoresizingMaskIntoConstraints = false

      addSubview(weightsViewAmount)

      weightsViewAmount.leadingAnchor.constraint(equalTo: weightsTextfieldLabel.trailingAnchor).isActive = true
      weightsViewAmount.topAnchor.constraint(equalTo: topAnchor).isActive = true
      weightsViewAmount.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
      weightsViewAmount.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true

      let repsTextfieldLabel = UITextField()
      repsTextfieldLabel.textColor = .gray
      repsTextfieldLabel.text = "Reps"
      repsTextfieldLabel.isUserInteractionEnabled = false
      repsTextfieldLabel.translatesAutoresizingMaskIntoConstraints = false

      addSubview(repsTextfieldLabel)

      repsTextfieldLabel.leadingAnchor.constraint(equalTo: weightsViewAmount.trailingAnchor).isActive = true
      repsTextfieldLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
      repsTextfieldLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
      repsTextfieldLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true

      repsViewAmount = UITextField()
//      repsViewAmount.keyboardType = .numberPad
      repsViewAmount.isUserInteractionEnabled = false
      repsViewAmount.placeholder = "0"
      repsViewAmount.translatesAutoresizingMaskIntoConstraints = false

      addSubview(repsViewAmount)

      repsViewAmount.leadingAnchor.constraint(equalTo: repsTextfieldLabel.trailingAnchor).isActive = true
      repsViewAmount.topAnchor.constraint(equalTo: topAnchor).isActive = true
      repsViewAmount.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
      repsViewAmount.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23).isActive = true

      // set the validator to the strength view in order to
      // give it the chance to layout itself accordingly
   }

   override public func update() {
      super.update()

   }

   // MARK - Callbacks

   // MARK - Helpers


}
