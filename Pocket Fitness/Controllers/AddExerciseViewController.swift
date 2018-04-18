//
//  AddExerciseViewController.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 4/16/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import UIKit

class AddExerciseViewController: UIViewController {

   var addExerciseView : AddExerciseView!

    override func viewDidLoad() {
        super.viewDidLoad()

      setView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   func setView() {
      let frame = view.frame
      addExerciseView = AddExerciseView(frame: frame)
      view.addSubview(addExerciseView)
      setDismissButton()
   }

   func setDismissButton() {
      guard let button = addExerciseView.dismissView else {
         return
      }
      button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
   }

   @objc func dismissView()  {
      willMove(toParentViewController: nil)
      view.removeFromSuperview()
      presentingViewController?.dismiss(animated: true, completion: nil)
   }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
