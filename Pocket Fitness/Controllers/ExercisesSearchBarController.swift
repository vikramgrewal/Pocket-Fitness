//
//  ExercisesSearchBarController.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 4/12/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import UIKit
import Material

class ExercisesSearchBarController : SearchBarController {

   open override func prepare() {
      super.prepare()
      prepareStatusBar()
   }

   private func prepareStatusBar()  {
      statusBarStyle = .lightContent
   }

}
