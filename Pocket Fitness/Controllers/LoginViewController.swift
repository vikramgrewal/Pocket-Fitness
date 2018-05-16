import UIKit
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController {

   // View components
   var facebookLoginButton: UIButton!
   var titleLabel : UILabel!
   var preloadedExercisesLoading : Bool!
   var activityIndicatorView : UIActivityIndicatorView?
   var imageView : UIImageView?

   // Login manager for view controller
   var loginManager : LoginManager!

   override func viewDidLoad() {
        super.viewDidLoad()
         preloadedExercisesLoading = false
        // Do any additional setup after loading the view.
         setUpView()

    }

   override func viewDidAppear(_ animated: Bool) {
      // Check the credentials every single time the view appears, so that the user
      // will be redirected without having to click login
      if(!preloadedExercisesLoading) {
         checkCredentials()
      }
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   func setUpView()  {
      setUpHeader()
      setImage()
      setUpFacebookLoginButton()

   }

   func setUpFacebookLoginButton()  {
      facebookLoginButton = UIButton()
      // Handle changing all properties for facebook login button below
      facebookLoginButton.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
      facebookLoginButton.setTitle("Login with Facebook", for: .normal)
      facebookLoginButton.setTitleColor(.white, for: .normal)
      facebookLoginButton.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
      facebookLoginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
      // Set autoresizing mask into constraints to false since programatically created view
      facebookLoginButton.translatesAutoresizingMaskIntoConstraints = false
      // Add login button to view
      view.addSubview(facebookLoginButton)
      // Set constraints for button below
      if #available(iOS 11.0, *) {
         facebookLoginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                      constant: 20).isActive = true
         facebookLoginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                       constant: -20).isActive = true
         facebookLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                     constant: -20).isActive = true
      } else {
         facebookLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                      constant: 20).isActive = true
         facebookLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                       constant: -20).isActive = true
         facebookLoginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                     constant: -20).isActive = true
      }
      facebookLoginButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

   }

   func setUpHeader()   {

      titleLabel = UILabel()
      // Handle all property changes for label below
      titleLabel.text = "Pocket Fitness"
      titleLabel.textAlignment = .center
      titleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 40.0)
      titleLabel.textColor = .black
      // Set to false for view since view created programatically
      titleLabel.translatesAutoresizingMaskIntoConstraints = false
      // Add label to view
      view.addSubview(titleLabel)
      // Set up constraints for label below
      if #available(iOS 11.0, *) {
         titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
      } else {
         titleLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      }
      titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

   }

   func setImage()   {

      // Put guard statement to make sure dummbbell image exists
      guard let image = UIImage(named: "dumbbell") else {
         return
      }
      // Setup imageview with image below and set properties
      imageView = UIImageView(image: image)
      // Set to false for view since created progrmatically
      imageView?.translatesAutoresizingMaskIntoConstraints = false
      // Add imageview to view
      view.addSubview(imageView!)
      // Setup constraints for image view
      imageView?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
      imageView?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
      imageView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      imageView?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

   }

   // Displays spinner if user decides to load preloading existing exercises
   func displaySpinner()   {
      // Sets activity indicator view in center of view while loading exercises
      activityIndicatorView = UIActivityIndicatorView()
      // Set up properties for activity indicator view below here
      activityIndicatorView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
      activityIndicatorView?.center = view.center
      activityIndicatorView?.hidesWhenStopped = true
      activityIndicatorView?.activityIndicatorViewStyle =
         UIActivityIndicatorViewStyle.gray
      // Add the view to the subview
      view.addSubview(activityIndicatorView!)
      // Start animating view while execution of task
      activityIndicatorView!.startAnimating()
   }

   // Removes the spinner from the superview after executing task
   func removeSpinner() {
      activityIndicatorView?.stopAnimating()
      activityIndicatorView?.removeFromSuperview()
   }

   // Handles action for login button to connect to facebook login manager
   @objc func loginButtonClicked()  {
      // Instantiates login manager to redirect user to correct page
      loginManager = LoginManager()
      // Edit permissions to what information is needed from Facebook user
      // Must comply with app settings in facebook developers console
      loginManager.logIn(readPermissions: [.publicProfile], viewController: self)   { loginResult in
         // Receives a callback from function with the login results for user
         switch loginResult {
         // TODO: Implement logic to give feedback to user with alert of some kind
         case .failed(let error):
            print(error)
         // In the case of a successful login we get the token of the user
         // Token holds data including authentication token, refresh date of token,
         // expiration date of token, and facebookId of user
         case .success(_, _, let token):
            // Only required field since we are not posting on behalf of the user of the user
            let facebookId = token.userId!

            // These tokens must be implemented once we decide to share on behalf of the user
            // and request other data for the user throughout other view controllers of the app
//            let retrievedToken = token.authenticationToken
//            let refreshDate = token.refreshDate
//            let expirationDate = token.expirationDate


            // Checks the database to see if user exists with facebookId
            guard let user = User.getUserWithFacebookId(facebookId: facebookId) else {

               // TODO: Change to try catch to give feedback to user and clean
               // database functions
               guard let userToInsert = User.insertUser(facebookId: facebookId)  else {
                  return
               }

               // This initializes the boolean for the preloaded exercises to true
               // so that checkCredentials not fire user to the user entry view controller
               self.preloadedExercisesLoading = true

               // If a new user is detected, they can select to import our preloaded
               // exercises so that they do not have an empty slate
               let newUserAlert = UIAlertController(title: "Welcome!", message:
                  "Would you like to load our preloaded exercises?", preferredStyle: UIAlertControllerStyle.alert)

               // This adds an action to the alert to set the preloaded exercises
               // for the user
               newUserAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                  // Display the activity indicator view, so that the user knows\
                  // the process is beginning for the importing
                  self.displaySpinner()
                  DispatchQueue.main.async {
                     // Performs the import off the main thread, so that no
                     // freezes will happen
                     Exercise.preloadExercises()
                     // Set the preloading boolean to false to show import is complete
                     self.preloadedExercisesLoading = false
                     self.removeSpinner()
                     // Check the credentials after to redirect the user to the user
                     // entry view controller
                     self.checkCredentials()
                  }
               }))

               // This will automatically check the credentials of the user since the
               // viewwillappear method will not be fired
               newUserAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                  self.checkCredentials()
               }))

               // Present the user with the alert created
               self.present(newUserAlert, animated: true, completion: nil)

               // Login with the newly created user, so that they do not have to
               // login afterwards
               UserSession.login(user: userToInsert)

               // Halt execution so that user is not logged in twice
               return
            }

            // This is the only function that wil be executed in the case that the user is
            // already a registered user
            UserSession.login(user: user)

            // Switch case can be implemented below to show some kind of alert
            // to user to tell them that they have cancelled the login process
         case .cancelled:
            return
         }

      }
   }


   // Checks credentials of user to see if they are logged in presenting them
   // the correct entry view controller
   func checkCredentials() {

      if UserSession.isLoggedIn()   {

         // If the facebookId is not inside the keychain, we will not redirect
         // user to the entry view controller
         guard KeychainController.loadID() != nil else {
            return
         }

         // This will pop the view controller until the app entry view controller
         self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)

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
