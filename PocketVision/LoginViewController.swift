import UIKit
import Firebase

class LoginViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem .setHidesBackButton(true, animated: false)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func loginAction(_ sender: AnyObject) {
        
        if (emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty) {
            
            let alert = UIAlertController(title: "Error", message: "Please enter an email and a password", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            guard let email = emailTextField.text, let password = passwordTextField.text else { return }
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    
                    let alertFail = UIAlertController(title: "Alert", message:
                        error.localizedDescription, preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default) {
                        
                        (Action) in print("Ok button tapped")
                        
                    }
                    
                    alertFail.addAction(okAction)
                    
                    self.present(alertFail, animated: true, completion: nil)
                    
                    return
                    
                } else {
                
                self.dismiss(animated: true, completion: nil)
                }
                
            }
            
        }
        

    }
}

