//
//  ExercisesNavigationController.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 4/16/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import UIKit

class ExercisesNavigationController: UINavigationController {

    override func viewDidLoad() {
      super.viewDidLoad()
      let exerciseVC = ExercisesViewController()
      self.present(exerciseVC, animated: true, completion: nil)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
