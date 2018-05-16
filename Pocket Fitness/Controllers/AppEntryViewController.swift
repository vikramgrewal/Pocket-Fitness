import UIKit

// Entry view controlle for application will present user with correct entry point
class AppEntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

   // Run function to get proper view controller
   override func viewDidAppear(_ animated: Bool) {
      let viewController = getVCToPresent()
      present(viewController, animated: true, completion: nil)
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   // Method returns the proper view controller. This will either return a
   // login view controller or a tab bar controller holding navigation controllers
   // for each view viewc controller, so that routing can be performed throughout
   // the application consistently
   func getVCToPresent() -> UIViewController   {

      // Check if the user is logged in and present them the tab bar controller
      if UserSession.isLoggedIn() {

         // TODO: Instantiate data model for all view controllers and send data to
         // view controllers of application

         let tabBarController = UITabBarController()
         // Handle designing of tab bar below
         tabBarController.tabBar.tintColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 141.0/255.0, alpha: 1.0)
         tabBarController.tabBar.barTintColor = .groupTableViewBackground

         // Handle instantiation of all view controllers below
         let workoutsVC = WorkoutsViewController()
         let workoutsNavigationController = UINavigationController(rootViewController: workoutsVC)
         // Handle designing of workout navigation controller below
         workoutsNavigationController.navigationBar.tintColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 141.0/255.0, alpha: 1.0)

         let exerciseVC = ExercisesViewController()
         let exerciseNavigationController = UINavigationController(rootViewController: exerciseVC)
         // Handle designing of exercise navigation controller below
         exerciseNavigationController.navigationBar.tintColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 141.0/255.0, alpha: 1.0)

         let settingsVC = SettingsViewController()
         let settingsNavigationController = UINavigationController(rootViewController: settingsVC)
         // Handle designing of settings navigation controller below
         settingsNavigationController.navigationBar.tintColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 141.0/255.0, alpha: 1.0)

         // Handle settings the tab bar controller below
         let tabBarControllers = [workoutsNavigationController, exerciseNavigationController, settingsNavigationController]
         // Handle all property changes of tab bar controller below
         tabBarControllers[0].title = "Workouts"
         tabBarControllers[1].title = "Exercises"
         tabBarControllers[2].title = "Settings"
         tabBarControllers[0].tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
         tabBarControllers[1].tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
         tabBarControllers[2].tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)

         // Set the tab bar controllers to the array of tab bar controllers
         tabBarController.viewControllers = tabBarControllers

         return tabBarController

      }  else {

         // Instantiate the login view controller and return to user
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
