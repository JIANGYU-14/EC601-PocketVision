//
//  helptypeViewController.swift
//  PocketVision
//
//  Created by JIANGYU  😈 on 2016/12/7.
//
//

import UIKit
import Firebase

class helptypeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func type1(_ sender: Any) {
        
        // Set help type in database
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("BlindUser").child(userID!).child("requesttype").setValue("WALKING")
        ref.child("BlindUser").child(userID!).child("request").setValue("Active")
        
        performSegue(withIdentifier: "sendrequesting", sender: self)
    }
    @IBAction func type2(_ sender: Any) {
        // Set help type in database
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("BlindUser").child(userID!).child("requesttype").setValue("MOVING")
        ref.child("BlindUser").child(userID!).child("request").setValue("Active")
        
        performSegue(withIdentifier: "sendrequesting", sender: self)
    }
    @IBAction func type3(_ sender: Any) {
        // Set help type in database
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("BlindUser").child(userID!).child("requesttype").setValue("OTHER")
        ref.child("BlindUser").child(userID!).child("request").setValue("Active")
        
        performSegue(withIdentifier: "sendrequesting", sender: self)
    }
    


}
