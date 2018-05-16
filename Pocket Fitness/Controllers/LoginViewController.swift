import UIKit
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController {

   var facebookLoginButton: UIButton!
   var preloadedExercisesLoading : Bool!
   var activityIndicatorView : UIActivityIndicatorView?

   override func viewDidLoad() {
        super.viewDidLoad()

         preloadedExercisesLoading = false
        // Do any additional setup after loading the view.
         setUpView()
         setImage()
         setupFacebookLogin()
         setUpHeader()

    }

   override func viewDidAppear(_ animated: Bool) {
      if(!preloadedExercisesLoading) {
         checkCredentials()
      }

   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   func setUpView()  {
      facebookLoginButton = UIButton()
      facebookLoginButton.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
      view.addSubview(facebookLoginButton)
      facebookLoginButton.translatesAutoresizingMaskIntoConstraints = false
      facebookLoginButton.setTitle("Login with Facebook", for: .normal)
      facebookLoginButton.setTitleColor(.white, for: .normal)
      facebookLoginButton.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
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

      // Create progress spinner

   }

   func displaySpinner()   {
      activityIndicatorView = UIActivityIndicatorView()
      activityIndicatorView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
      activityIndicatorView?.center = view.center
      activityIndicatorView?.hidesWhenStopped = true
      activityIndicatorView?.activityIndicatorViewStyle =
         UIActivityIndicatorViewStyle.gray
      view.addSubview(activityIndicatorView!)
      activityIndicatorView!.startAnimating()
   }

   func removeSpinner() {
      activityIndicatorView?.stopAnimating()
      activityIndicatorView?.removeFromSuperview()
   }

   func setupFacebookLogin() {
      facebookLoginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
   }

   func setUpHeader()   {

      let pocketTitle = UILabel()
      pocketTitle.text = "Pocket Fitness"
      pocketTitle.textAlignment = .center
      pocketTitle.font = UIFont(name:"HelveticaNeue-Bold", size: 40.0)
      pocketTitle.translatesAutoresizingMaskIntoConstraints = false
      pocketTitle.textColor = .black
      view.addSubview(pocketTitle)
      if #available(iOS 11.0, *) {
         pocketTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
      } else {
         pocketTitle.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      }
      pocketTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true


   }


   func setImage()   {

      guard let image = UIImage(named: "dumbbell") else {
         return
      }
      let imageView = UIImageView(image: image)
      imageView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(imageView)
      imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
      imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
      imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
      imageView.contentMode = .scaleAspectFit
   }

   @objc func loginButtonClicked()  {
      let loginManager = LoginManager()
      loginManager.logIn(readPermissions: [.publicProfile], viewController: self)   { loginResult in
         switch loginResult {
         case .failed(let error):
            print(error)
         case .success(let grantedPermissions, let declinedPermissions, let token):
            let retrievedToken = token.authenticationToken
            let refreshDate = token.refreshDate
            let expirationDate = token.expirationDate
            let facebookId = token.userId!

            guard let user = User.getUserWithFacebookId(facebookId: facebookId) else {
               guard let userToInsert = User.insertUser(facebookId: facebookId)  else {
                  return
               }

               self.preloadedExercisesLoading = true

               var newUserAlert = UIAlertController(title: "Welcome!", message: "Would you like to load our preloaded exercises?", preferredStyle: UIAlertControllerStyle.alert)

               newUserAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                  self.displaySpinner()
                  DispatchQueue.main.async {
                     Exercise.preloadExercises()
                     self.preloadedExercisesLoading = false
                     self.removeSpinner()
                     self.checkCredentials()
                  }
                  // Handle loading exercises into database here
               }))

               newUserAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                  self.checkCredentials()
               }))

               self.present(newUserAlert, animated: true, completion: nil)
               print("Successfully created new user")
               DispatchQueue.main.async {
                  UserSession.login(user: userToInsert)
               }
               return
            }

            print("Successfully logged in as a previous user")
            DispatchQueue.main.async {
               UserSession.login(user: user)
            }
            
         case .cancelled:
            print("User cancelled log in")
         }

      }
   }


   func checkCredentials() {

      if UserSession.isLoggedIn()   {

         guard let facebookId = KeychainController.loadID() else {
            return
         }
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
