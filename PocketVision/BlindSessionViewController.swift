import UIKit
import Firebase


class BlindSessionViewController: UIViewController {

    @IBOutlet weak var helperLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("BlindUser").child(userID!).observe(.value, with:{(snapshot) in
            
            // Get helper's firstname
            let value = snapshot.value as? NSDictionary
            let helperID = value?["helper"] as? String
            
            // If the helper didn't end the session, display the his firstname
            if helperID != ""{
            ref.child("SightedUser").child(helperID!).observe(.value, with:{(snapshot) in
                let value = snapshot.value as? NSDictionary
                let helpername = value?["firstname"] as? String
                self.helperLabel.text = helpername! + " is on the way here"
            })
            }
        })
        
        checkFirebase()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Navigate back to homepage if SightedUser ended the session
    func checkFirebase() {
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        // Check "helper" value
        ref.child("BlindUser").child(userID!).observe(.value, with: {(snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let helper = value?["helper"] as? String
            
            if helper == "" {
                //self.performSegue(withIdentifier: "endBlindSession", sender: self )
                //self.dismiss(animated: true, completion: nil)
                self.presentingViewController?.dismiss(animated: false, completion: nil)
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    
    

}
