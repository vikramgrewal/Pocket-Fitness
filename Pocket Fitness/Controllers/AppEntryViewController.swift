//
//  AppEntryViewController.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 5/13/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import UIKit

class AppEntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   override func viewDidAppear(_ animated: Bool) {
      let viewController = getVCToPresent()
      present(viewController, animated: true, completion: nil)
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   func getVCToPresent() -> UIViewController   {

      if UserSession.isLoggedIn() {
         let tabBarController = UITabBarController()
         tabBarController.tabBar.barTintColor = .groupTableViewBackground
         let workoutsVC = WorkoutsViewController()
         let workoutsNavigationController = UINavigationController(rootViewController: workoutsVC)

         let exerciseVC = ExercisesViewController()
         let exerciseNavigationController = UINavigationController(rootViewController: exerciseVC)

         let settingsVC = SettingsViewController()
         let settingsNavigationController = UINavigationController(rootViewController: settingsVC)

         let tabBarControllers = [workoutsNavigationController, exerciseNavigationController, settingsNavigationController]
         tabBarControllers[0].title = "Workouts"
         tabBarControllers[1].title = "Exercises"
         tabBarControllers[2].title = "Settings"
         tabBarController.viewControllers = tabBarControllers

         return tabBarController
      }  else {
         let loginVC = LoginViewController()
         return loginVC
      }

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
