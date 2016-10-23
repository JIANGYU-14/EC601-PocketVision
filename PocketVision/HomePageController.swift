import UIKit
import Firebase

class HomePageController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Check if user has already signed in
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.

                // Retrieve from database
                
                let ref = FIRDatabase.database().reference()
                
                let userID = FIRAuth.auth()?.currentUser?.uid
                
                ref.child("users").child(userID!).observe(.value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let firstname = value?["firstname"] as? String
                    let userType = value?["user_type"] as? String
                    
                    // Replace default labels
                    
                    self.nameLabel.text = firstname
                    self.userTypeLabel.text = userType
 
                    
                }) { (error) in
                    print(error.localizedDescription)
                }

                
            } else {
                // No user is signed in.
                
                self.performSegue(withIdentifier: "loginView", sender: self)
                
            }
        }
        
        
        
    }
    
    
    // MARK: Actions
    
    @IBAction func logoutAction(_ sender: AnyObject) {
        
        let logOutAlert = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            try! FIRAuth.auth()?.signOut()
        })
        logOutAlert.addAction(yesAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in self.dismiss(animated: true, completion: nil)})
        logOutAlert.addAction(cancelAction)
        
        self.present(logOutAlert, animated: true, completion: nil)
        
    }
    
    

}
