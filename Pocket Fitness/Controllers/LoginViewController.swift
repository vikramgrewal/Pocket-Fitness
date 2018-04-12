//
//  LoginViewController.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 4/11/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController {

   @IBOutlet weak var facebookLoginButton: UIButton!

   override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         setupFacebookLogin()

    }

   override func viewDidAppear(_ animated: Bool) {
      checkCredentials()
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   func setupFacebookLogin() {
      facebookLoginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
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
            let userId = token.userId!

            let user = User(userId: userId, retrievedToken: retrievedToken, refreshDate: refreshDate, expirationDate: expirationDate)

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
         DispatchQueue.main.async {
            self.performSegue(withIdentifier: "loggedInSegue", sender: self)
         }
      }  else  {
         print("Not logged in")
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
