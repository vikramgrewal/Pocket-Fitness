import UIKit
import Eureka
import MessageUI

class SettingsViewController: FormViewController, MFMailComposeViewControllerDelegate {

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
        form
        +++ Section() { section in
            section.header?.height = { 74 }
            section.tag = "settingsSection"
        }
        <<< ButtonRow() { row in
            row.title = "Profile"
        }.cellUpdate { cell, row in
            cell.textLabel?.textColor = .black
            cell.textLabel?.textAlignment = .left
            cell.accessoryType = .disclosureIndicator
            cell.editingAccessoryType = cell.accessoryType
        }
        <<< ButtonRow() { row in
            row.title = "Terms of Service"
        }.cellUpdate { cell, row in
            cell.textLabel?.textColor = .black
            cell.textLabel?.textAlignment = .left
            cell.accessoryType = .disclosureIndicator
            cell.editingAccessoryType = cell.accessoryType
        }.onCellSelection{ cell, row in
            let termsOfServiceVC = TermsOfServiceViewController()
            self.navigationController?.pushViewController(termsOfServiceVC, animated: true)
        }
        <<< ButtonRow() { row in
            row.title = "Privacy Policy"
        }.cellUpdate { cell, row in
            cell.textLabel?.textColor = .black
            cell.textLabel?.textAlignment = .left
            cell.accessoryType = .disclosureIndicator
            cell.editingAccessoryType = cell.accessoryType
        }.onCellSelection{ cell, row in
            let privacyPolicyVC = PrivacyPolicyViewController()
            self.navigationController?.pushViewController(privacyPolicyVC, animated: true)
        }
        <<< ButtonRow() { row in
            row.title = "Contact Us"
        }.cellUpdate { cell, row in
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
            row.title = "Log Out"
        }.cellUpdate { cell, row in
            cell.textLabel?.textColor = .black
            cell.textLabel?.textAlignment = .left
            cell.accessoryType = .disclosureIndicator
            cell.editingAccessoryType = cell.accessoryType
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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
