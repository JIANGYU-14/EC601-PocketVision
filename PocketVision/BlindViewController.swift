//
//  BlindViewController.swift
//  PocketVision
//
//  Created by JIANGYU  😈 on 2016/10/23.
//
//

import UIKit
import Firebase

class BlindViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
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
        let alert = UIAlertController(title: "Logout", message: "You sure to logout current account?", preferredStyle: .alert)
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
