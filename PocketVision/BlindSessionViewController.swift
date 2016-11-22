import UIKit
import Firebase


class BlindSessionViewController: UIViewController {

    @IBOutlet weak var helperLabel: UILabel!
    
    var checker = Timer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Check if the SightedUser end the session
        checker = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.checkfirebase), userInfo: nil, repeats: true)
        
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("BlindUser").child(userID!).observe(.value, with:{(snapshot) in
            
            // Get helper's firstname
            let value = snapshot.value as? NSDictionary
            let helperID = value?["helper"] as? String
            
            // If the helper didn't end session, then display the SightedUser's firstname on screen
            if helperID != ""{
            ref.child("SightedUser").child(helperID!).observe(.value, with:{(snapshot) in
                let value = snapshot.value as? NSDictionary
                let helpername = value?["firstname"] as? String
                self.helperLabel.text = helpername! + " on the way here"
            })
            }
        })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The func is about check if the SightedUser end the session, if yes, then back to the home page
    func checkfirebase() {
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        // Get current Helper's Value
        ref.child("BlindUser").child(userID!).observe(.value, with:{(snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let helper = value?["helper"] as? String
            
            if helper == "" {
                self.performSegue(withIdentifier: "backtohomepage", sender: self )
            }
        })
    }
    
    

}
