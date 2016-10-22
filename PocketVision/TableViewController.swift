//
//  TableViewController.swift
//  PocketVision
//
//  Created by JIANGYU  😈 on 2016/10/21.
//
//

import UIKit
import Firebase

class TableViewController: UIViewController {

    @IBOutlet weak var nameTextField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = FIRAuth.auth()?.currentUser
        {
            self.nameTextField.text = user.email
        }
        else
        {
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logoutAction(_ sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        let alertController = UIAlertController(title: "Logout", message: "Are you sure logout current account?", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Yes", style: .cancel, handler: {
            action in
            self.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
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
