import UIKit
import Firebase

class HomePageController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.perform(Selector:"navigatetobelongedpage", with: nil, afterDelay: 5.0)
        var timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: Selector("navigatetobelongedpage"), userInfo: nil, repeats: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func navigatetobelongedpage(){
        // Check if user has already signed in
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                
                // User is signed in.
                print("User already Logged in")
                
                // Retrieve from database
                let ref = FIRDatabase.database().reference()
                
                let userID = FIRAuth.auth()?.currentUser?.uid
                
                ref.child("BlindUser").child(userID!).observe(.value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let userType = value?["user_type"] as? String
                    
                    //Navigate to corresponds page, i.e. Blind Page or Sighted Page
                    if userType == "Blind"
                    {
                        self.performSegue(withIdentifier: "blindpage", sender: self)
                        print("Navigate to blind page")
                    }
                    else
                    {
                        self.performSegue(withIdentifier: "sightedpage", sender: self)
                        print("Navigate to sighted page")
                    }
                }) { (error) in
                    print(error.localizedDescription)
                    print("Check Internet Connection!!!")
                }
            } else {
                
                // No user is signed in.
                self.performSegue(withIdentifier: "loginView", sender: self)
            }
        }
    }
}
