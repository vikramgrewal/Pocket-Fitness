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

   var button : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

         setUpNavigation()
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
            cell.tintColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 141.0/255.0, alpha: 1.0)
      }
      <<< TextRow() {
         $0.title = "Last Name"
         $0.placeholder = "e.g. Doe"
         $0.tag = "lastNameRow"
      }.cellUpdate { cell, row in
         cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
         cell.textField.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
         cell.tintColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 141.0/255.0, alpha: 1.0)
      }
      <<< TextRow() {
         $0.title = "Email"
         $0.placeholder = "e.g. johndoe@gmail.com"
         $0.tag = "emailRow"
      }.cellUpdate { cell, row in
         cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
         cell.textField.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
         cell.tintColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 141.0/255.0, alpha: 1.0)
      }
      navigationAccessoryView.tintColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 141.0/255.0, alpha: 1.0)
   }

   func setUpNavigation()  {
      navigationController?.navigationBar.barStyle = .default

      let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
      navigationItem.rightBarButtonItem = saveButton
      let rightBarOffset = UIOffset(horizontal: -16.0, vertical: 0.0)
      navigationItem.rightBarButtonItem?.setTitlePositionAdjustment(rightBarOffset, for: .default)

      navigationItem.rightBarButtonItem?.action = #selector(saveInformation)
   }

   @objc func saveInformation() {
//         view.endEditing(true)
//
//         guard let firstNameRow = form.rowBy(tag: "firstNameRow") as? TextRow,
//         let lastNameRow = form.rowBy(tag: "lastNameRow") as? TextRow,
//         let emailRow = form.rowBy(tag: "emailRow") as? TextRow else {
//            return
//         }
//
//         let firstName = firstNameRow.value == nil ? "" : firstNameRow.value!
//         let lastName = lastNameRow.value == nil ? "" : lastNameRow.value!
//         let email = emailRow.value == nil ? "" : emailRow.value!
//
//         let user = User(userId: nil, facebookId: nil, firstName: firstName,
//                         lastName: lastName, email: email, bodyWeight: nil, createdAt: nil)
//         do {
//            try UserTable.updateExistingUser(user: user)
//         } catch {
//            print(error.localizedDescription)
//         }

   }

   func fetchUserInfo() {
//      do {
//         let user = try UserTable.getCurrentUser()
//         let firstName = user.firstName == nil ? "" : user.firstName!
//         let lastName = user.lastName == nil ? "" : user.lastName!
//         let email = user.email == nil ? "" : user.email!
//
//         guard let firstNameRow = form.rowBy(tag: "firstNameRow") as? TextRow,
//            let lastNameRow = form.rowBy(tag: "lastNameRow") as? TextRow,
//            let emailRow = form.rowBy(tag: "emailRow") as? TextRow else {
//               return
//         }
//
//         firstNameRow.value = firstName
//         lastNameRow.value = lastName
//         emailRow.value = email
//      } catch {
//         print(error.localizedDescription)
//      }
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
