//
//  ViewController.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 4/8/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   @IBOutlet weak var logoutButton: UIButton!

   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      setLogoutAction()
   }

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }

   func setLogoutAction()  {
      logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
   }

   @objc func logout()  {
      UserSession.logout()
      let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
      let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginView")
      DispatchQueue.main.async {
         self.present(loginViewController, animated: true, completion: nil)
      }
   }


}

