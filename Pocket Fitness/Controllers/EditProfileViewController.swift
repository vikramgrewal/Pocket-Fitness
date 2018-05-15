//
//  EditProfileViewController.swift
//  Pocket Fitness
//
//  Created by Vikram Work/School on 5/14/18.
//  Copyright © 2018 Vikram Work/School. All rights reserved.
//

import UIKit
import Eureka

class EditProfileViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

         setUpView()
         fetchUserInfo()
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   func setUpView()  {
      form
      +++ Section()   { section in
         section.header?.height = { 44 }
      }
      <<< TextRow() {
         $0.title = "First Name"
         $0.placeholder = "e.g. John"
         $0.tag = "firstNameRow"
         }.cellUpdate { cell, row in
            cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
            cell.textField.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
      }
      <<< TextRow() {
         $0.title = "Last Name"
         $0.placeholder = "e.g. Doe"
         $0.tag = "lastNameRow"
      }.cellUpdate { cell, row in
         cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
         cell.textField.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
      }
      <<< TextRow() {
         $0.title = "Email"
         $0.placeholder = "e.g. johndoe@gmail.com"
         $0.tag = "emailRow"
      }.cellUpdate { cell, row in
         cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
         cell.textField.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
      }
      <<< DecimalRow() {
         $0.title = "Weight"
         $0.placeholder = "e.g. 150.0"
         $0.tag = "userWeightRow"
         }.cellUpdate { cell, row in
            cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
            cell.textField.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
         }
      }

   func fetchUserInfo() {

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
