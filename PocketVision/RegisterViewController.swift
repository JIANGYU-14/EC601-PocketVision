import UIKit
import Firebase

class RegisterViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func createaccountAction(_ sender: AnyObject) {
        let firstname = self.firstnameTextField.text
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        
        if firstname != "" && email != "" && password != ""
        {
            FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                if error == nil
                {
                    // Create database reference
                    
                    let ref = FIRDatabase.database().reference()
                    
                    // Store first name in database
                    
                    let firstname : [String : String] = ["firstname" : self.firstnameTextField.text!]
                    
                    switch self.segmentControl.selectedSegmentIndex
                    {
                    case 0:
                        ref.child("BlindUser").child(user!.uid).setValue(firstname)
                    case 1:
                        ref.child("SightedUser").child(user!.uid).setValue(firstname)
                    default:
                        break;
                    }
                    
                    // Store user type in database
                    
                    switch self.segmentControl.selectedSegmentIndex
                    {
                    case 0:
                        ref.child("BlindUser").child(user!.uid).child("user_type").setValue("Blind")
                    case 1:
                        ref.child("SightedUser").child(user!.uid).child("user_type").setValue("Sighted")
                    default: 
                        break; 
                    }
                    
                    // Sign out and navigate to login page
                    
                    try! FIRAuth.auth()!.signOut()
                    
                    let congrats = UIAlertController(title: "Congratulations!", message: "You have successfully signed up!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .cancel, handler: {
                    action in
                        self.dismiss(animated: true, completion: nil)
                    })
                    congrats.addAction(action)
                    self.present(congrats, animated: true, completion: nil)
                }
                else
                {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Please enter all required info", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func cancelRegistration(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
