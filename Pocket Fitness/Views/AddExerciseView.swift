//
//  AddExerciseView.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 4/17/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import UIKit
import Material

class AddExerciseView: UIView {

   var dismissView : Button!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

   override init(frame: CGRect) {
      super.init(frame: frame)

      setUpView()
   }

   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }

   func setUpView()  {
      backgroundColor = .white

      setUpButton()
   }

   func setUpButton()   {
      dismissView = Button()
      dismissView.backgroundColor = .blue
      dismissView.titleLabel?.text = "Dismiss view"
      dismissView.titleLabel?.textAlignment = .center
      addSubview(dismissView)
      let top = dismissView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
      let leading = dismissView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
      let trailing = dismissView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
      let height = NSLayoutConstraint(item: dismissView, attribute: .height, relatedBy: .equal, toItem: nil,
                                      attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
      let constraints = [top, leading, trailing, height]
      dismissView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate(constraints)

   }

}
