import UIKit
import Eureka
import MessageUI

class SettingsViewController: FormViewController, MFMailComposeViewControllerDelegate {

   var activityIndicatorView : UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpView()    {
        title = "Settings"
         let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        form
        +++ Section(version) { section in
            section.tag = "settingsSection"
        }
        <<< ButtonRow() { row in
            row.title = "Profile"
            row.presentationMode = PresentationMode.show(
               controllerProvider: ControllerProvider.callback(builder: { return EditProfileViewController() }),
               onDismiss: nil
            )
        }.cellUpdate { cell, row in
            cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            cell.textLabel?.textColor = .black
            cell.textLabel?.textAlignment = .left
            cell.accessoryType = .disclosureIndicator
            cell.editingAccessoryType = cell.accessoryType
         }
//         .onCellSelection{ _,_ in
//            let editProfileVC = EditProfileViewController()
//            self.navigationController?.pushViewController(editProfileVC, animated: true)
//         }
        <<< ButtonRow() { row in
            row.title = "Terms of Service"
        }.cellUpdate { cell, row in
            cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            cell.textLabel?.textColor = .black
            cell.textLabel?.textAlignment = .left
            cell.accessoryType = .disclosureIndicator
            cell.editingAccessoryType = cell.accessoryType
        }.onCellSelection{ cell, row in
         if #available(iOS 11.0, *) {
            let termsOfServiceVC = TermsOfServiceViewController()
            self.navigationController?.pushViewController(termsOfServiceVC, animated: true)
         } else {
            var newUserAlert = UIAlertController(title: "Error!", message: "Upgrade to IOS 11", preferredStyle: UIAlertControllerStyle.alert)

            newUserAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
               // Don't do anything to the database here
            }))

            self.present(newUserAlert, animated: true, completion: nil)
         }
        }
        <<< ButtonRow() { row in
            row.title = "Privacy Policy"
        }.cellUpdate { cell, row in
            cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            cell.textLabel?.textColor = .black
            cell.textLabel?.textAlignment = .left
            cell.accessoryType = .disclosureIndicator
            cell.editingAccessoryType = cell.accessoryType
        }.onCellSelection{ cell, row in
         if #available(iOS 11.0, *) {
            let privacyPolicyVC = PrivacyPolicyViewController()
            self.navigationController?.pushViewController(privacyPolicyVC, animated: true)
         } else {
            var newUserAlert = UIAlertController(title: "Error!", message: "Upgrade to IOS 11", preferredStyle: UIAlertControllerStyle.alert)

            newUserAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
               // Don't do anything to the database here
            }))

            self.present(newUserAlert, animated: true, completion: nil)
         }
        }
        <<< ButtonRow() { row in
            row.title = "Contact Us"
        }.cellUpdate { cell, row in
            cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            cell.textLabel?.textColor = .black
            cell.textLabel?.textAlignment = .left
            cell.accessoryType = .disclosureIndicator
            cell.editingAccessoryType = cell.accessoryType
        }.onCellSelection{ cell, row in
            guard MFMailComposeViewController.canSendMail()   else {
                print("Cannot send mail from device")
                return
            }
            
            let composeMailVC = MFMailComposeViewController()
            composeMailVC.mailComposeDelegate = self
            
            composeMailVC.setToRecipients(["vik.grewal1992@gmail.com"])
            composeMailVC.setSubject("Contact Us")
            composeMailVC.setMessageBody("Hey Pocket Fitness, ", isHTML: false)
            
            self.present(composeMailVC, animated: true, completion: nil)
        }
         <<< ButtonRow() { row in
            row.title = "Preload Existing Exercises"
            }.cellUpdate { cell, row in
               cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
               cell.textLabel?.textColor = .black
               cell.textLabel?.textAlignment = .left
               cell.accessoryType = .disclosureIndicator
               cell.editingAccessoryType = cell.accessoryType
            }.onCellSelection { cell, row in
               self.displaySpinner()
               self.view.window?.isUserInteractionEnabled = false
               DispatchQueue.main.async {
                  Exercise.preloadExercises()
                  self.removeSpinner()
                  self.view.window?.isUserInteractionEnabled = true
               }
         }
        <<< ButtonRow() { row in
            row.title = "Log Out"
        }.cellUpdate { cell, row in
            cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            cell.textLabel?.textColor = .black
            cell.textLabel?.textAlignment = .left
            cell.accessoryType = .disclosureIndicator
            cell.editingAccessoryType = cell.accessoryType
         }.onCellSelection { cell, row in
            UserSession.logout()
            if !UserSession.isLoggedIn() {
               self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
            }
         }
         +++ Section()
         <<< ButtonRow() { row in
            row.title = "Warning: Delete data for all users!"
         }.cellUpdate { cell, row in
               cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
               cell.backgroundColor = .red
               cell.textLabel?.textColor = .white
               cell.textLabel?.textAlignment = .left
               cell.accessoryType = .disclosureIndicator
               cell.editingAccessoryType = cell.accessoryType
               cell.editingAccessoryView?.backgroundColor = .white
         }.onCellSelection{ _,_ in
            self.view.window?.isUserInteractionEnabled = false
            UserSession.logout()
            AppDatabase.dropEntireDatabase()
            AppDatabase.setUpSchema()
            self.view.window?.isUserInteractionEnabled = true
            if !UserSession.isLoggedIn() {
               self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
            }
         }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

   func displaySpinner()   {
      activityIndicatorView = UIActivityIndicatorView()
      activityIndicatorView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
      activityIndicatorView?.activityIndicatorViewStyle =
         UIActivityIndicatorViewStyle.white
      activityIndicatorView?.color = .black
      activityIndicatorView?.center = view.center
      activityIndicatorView?.layer.zPosition = 5
      activityIndicatorView?.hidesWhenStopped = true
      tableView.addSubview(activityIndicatorView!)
      activityIndicatorView!.startAnimating()
   }

   func removeSpinner() {
      activityIndicatorView?.layer.zPosition = 5
      activityIndicatorView?.stopAnimating()
      activityIndicatorView?.removeFromSuperview()
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
