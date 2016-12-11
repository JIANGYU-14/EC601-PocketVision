import UIKit
import Firebase

class LoadPageController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Display load screen for 1.0 seconds
        _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.navigateToBelongedPage), userInfo: nil, repeats: false)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func navigateToBelongedPage(){
        
        // Check if user has already signed in
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                
                // Retrieve from database
                let ref = FIRDatabase.database().reference()
                
                let userID = FIRAuth.auth()?.currentUser?.uid
                
                ref.child("BlindUser").child(userID!).observe(.value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let userType = value?["user_type"] as? String
                    
                    //Navigate to appropriate page depending on user type (Blind or Sighted)
                    if userType == "Blind"
                    {
                        self.performSegue(withIdentifier: "blindPage", sender: self)
                        print("Navigated to blind user page")
                    }
                    else
                    {
                        self.performSegue(withIdentifier: "sightedPage", sender: self)
                        print("Navigated to sighted user page")
                    }
                }) { (error) in
                    print(error.localizedDescription)
                    print("Check Internet connection!!!")
                }
                
            } else {
                
                // No user is signed in.
                self.performSegue(withIdentifier: "loginView", sender: self)
            }
        }
    }
}
