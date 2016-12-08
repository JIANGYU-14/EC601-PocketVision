import UIKit
import Firebase
import MapKit

class BlindViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var nameLabel: UILabel!

    
    let requestlocation = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask user for location service on this page
        self.requestlocation.requestWhenInUseAuthorization()
        
        // Hide navigation bar but keep navigation bar button
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        // Set the background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        // Retrieve from database
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("BlindUser").child(userID!).observe(.value, with: { (snapshot) in
            
            // Get user value
            let value = snapshot.value as? NSDictionary
            let firstname = value?["firstname"] as? String

            // Customize Font & Colors in Label (Do not set anything in Storyboard)
            let MutableString: NSMutableAttributedString = NSMutableAttributedString(string: firstname! as String, attributes: [NSFontAttributeName:UIFont(name:"Noteworthy-Light", size: 48)!])
            self.nameLabel.attributedText = MutableString
            self.nameLabel.textColor = UIColor(red: 100,green: 251, blue: 178)
          
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    
    
    @IBAction func logoutAction(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Logout", message: "Log out of Pocket Vision?", preferredStyle: .alert)
        // Logout current account
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:
            {
                action in
                try! FIRAuth.auth()?.signOut()
                self.performSegue(withIdentifier: "logoutAccount", sender: self)
                print("User did logout")
        }))
        // Cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:
            {
                action in
                print("User didnt logout")
        }))
        self.present(alert, animated: true, completion: nil)
    }


}
