import UIKit
import Firebase

class LoginViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Tap anywhere to dismiss the keyboard
        let taptodismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismisskeyboard))
        
        view.addGestureRecognizer(taptodismiss)
        
        // Set the background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        // Set layer for emailtextfield
        let emailborder = CALayer()
        let emailwidth = CGFloat(2.0)
        emailborder.borderColor = UIColor.darkGray.cgColor
        emailborder.frame = CGRect(x: 0, y: emailTextField.frame.size.height - emailwidth, width:  emailTextField.frame.size.width, height: emailTextField.frame.size.height)
        emailborder.borderWidth = emailwidth
        
        // Set layer for passwordtextfield
        let passwordborder = CALayer()
        let passwordwidth = CGFloat(2.0)
        passwordborder.borderColor = UIColor.darkGray.cgColor
        passwordborder.frame = CGRect(x: 0, y: passwordTextField.frame.size.height - passwordwidth, width:  passwordTextField.frame.size.width, height: passwordTextField.frame.size.height)
        passwordborder.borderWidth = passwordwidth
        
        // Apply layer to textfield
        emailTextField.layer.addSublayer(emailborder)
        passwordTextField.layer.addSublayer(passwordborder)
        
        // Set icon for emailtextfield
        let emailimageView = UIImageView()
        let emailimage = UIImage(named: "email.png")
        emailimageView.image = emailimage
        emailimageView.frame = CGRect(x: 0, y: 0, width: emailTextField.frame.height, height: emailTextField.frame.height)
        emailTextField.leftView = emailimageView
        emailTextField.leftViewMode = UITextFieldViewMode.always
        
        // Set icon for passwordtextfield
        let passwordimageView = UIImageView()
        let passwordimage = UIImage(named: "password.png")
        passwordimageView.image = passwordimage
        passwordimageView.frame = CGRect(x: 0, y: 0, width: passwordTextField.frame.height, height: passwordTextField.frame.height)
        passwordTextField.leftView = passwordimageView
        passwordTextField.leftViewMode = UITextFieldViewMode.always
 
        
        
    }
    
    func dismisskeyboard(){
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default)
                    
                    alertFail.addAction(okAction)
                    
                    self.present(alertFail, animated: true, completion: nil)
                    
                    return
                    
                } else {
                
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
                            self.performSegue(withIdentifier: "loginToBlind", sender: self)
                            print("Navigated to blind user page")
                        }
                        else
                        {
                            self.performSegue(withIdentifier: "loginToSighted", sender: self)
                            print("Navigated to sighted user page")
                        }
                    }) { (error) in
                        print(error.localizedDescription)
                        print("Check Internet connection!!!")
                    }

                }
                
            }
            
        }
        

    }
}

