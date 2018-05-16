import UIKit
import PDFKit

@available(iOS 11.0, *)
class PrivacyPolicyViewController: UIViewController {
    
    var pdfView : PDFView?
    
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
        pdfView = PDFView()
        guard pdfView != nil else {
            return
        }
        view.addSubview(pdfView!)
        pdfView?.translatesAutoresizingMaskIntoConstraints = false
        pdfView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pdfView?.autoScales = true
        
        guard let path = Bundle.main.url(forResource: "PrivacyPolicy", withExtension: "pdf") else {
            return
        }
        if let document = PDFDocument(url: path) {
            pdfView?.document = document
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
