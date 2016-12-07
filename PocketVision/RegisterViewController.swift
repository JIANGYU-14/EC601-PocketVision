import UIKit
import Firebase

class RegisterViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var typelabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize backbutton image and size
        let backButton = UIButton(frame: CGRect(x: 0, y: 20, width: 30, height: 30))
        backButton.setBackgroundImage(UIImage(named: "Back.png"), for: .normal)
        backButton.addTarget(self, action: #selector(RegisterViewController.backhomepage), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        // Hide navigation bar but keep navigation bar button
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        //Tap anywhere to dismiss the keyboard
        let taptodismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismisskeyboard))
        
        view.addGestureRecognizer(taptodismiss)
        
        // Set the background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        // Customize Font & Colors in Label (Do not set anything in Storyboard)
        let labeltext: NSString = "You Are"
        let MutableString: NSMutableAttributedString = NSMutableAttributedString(string: labeltext as String, attributes: [NSFontAttributeName:UIFont(name:"Noteworthy-Light", size: 25)!])
        MutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 100,green: 251, blue: 178), range: NSRange(location:0, length:1))
        MutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location:1, length:1))
        MutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 100,green: 251, blue: 178), range: NSRange(location:2, length:1))
        MutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location:4, length:1))
        MutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 100,green: 251, blue: 178), range: NSRange(location:5, length:1))
        MutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location:6, length:1))
        typelabel.attributedText = MutableString
        
        // Set layer for firstnametextfield
        let firstnameborder = CALayer()
        let firstnamewidth = CGFloat(2.0)
        firstnameborder.borderColor = UIColor(red: 149,green: 165, blue: 166).cgColor
        firstnameborder.frame = CGRect(x: 0, y: firstnameTextField.frame.size.height - firstnamewidth, width:  firstnameTextField.frame.size.width, height: firstnameTextField.frame.size.height)
        firstnameborder.borderWidth = firstnamewidth
        
        // Customize placeholder in firstnametextfield
        firstnameTextField.attributedPlaceholder = NSAttributedString(string:"First Name",attributes:[NSForegroundColorAttributeName: UIColor(red: 241,green: 241, blue:241)])
        firstnameTextField.textAlignment = NSTextAlignment.left
        firstnameTextField.font = firstnameTextField.font?.withSize(20)
        
        // Set layer for emailtextfield
        let emailborder = CALayer()
        let emailwidth = CGFloat(2.0)
        emailborder.borderColor = UIColor(red: 149,green: 165, blue: 166).cgColor
        emailborder.frame = CGRect(x: 0, y: emailTextField.frame.size.height - emailwidth, width:  emailTextField.frame.size.width, height: emailTextField.frame.size.height)
        emailborder.borderWidth = emailwidth
        
        // Customize placeholder in emailtextfield
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Email Address",attributes:[NSForegroundColorAttributeName: UIColor(red: 241,green: 241, blue:241)])
        emailTextField.textAlignment = NSTextAlignment.left
        emailTextField.font = emailTextField.font?.withSize(20)
        
        // Set layer for passwordtextfield
        let passwordborder = CALayer()
        let passwordwidth = CGFloat(2.0)
        passwordborder.borderColor = UIColor(red: 149,green: 165, blue: 166).cgColor
        passwordborder.frame = CGRect(x: 0, y: passwordTextField.frame.size.height - passwordwidth, width:  passwordTextField.frame.size.width, height: passwordTextField.frame.size.height)
        passwordborder.borderWidth = passwordwidth
        
        // Customize placeholder in passwordtextfield
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password",attributes:[NSForegroundColorAttributeName: UIColor(red: 241,green: 241, blue:241)])
        passwordTextField.textAlignment = NSTextAlignment.left
        passwordTextField.font = passwordTextField.font?.withSize(20)
        
        // Apply layer to textfield
        firstnameTextField.layer.addSublayer(firstnameborder)
        emailTextField.layer.addSublayer(emailborder)
        passwordTextField.layer.addSublayer(passwordborder)
        
        // Set icon for firstnametextfield
        let firstnameimageView = UIImageView()
        let firstnameimage = UIImage(named: "firstname.png")
        firstnameimageView.image = firstnameimage
        firstnameimageView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        firstnameTextField.leftView = firstnameimageView
        firstnameTextField.leftViewMode = UITextFieldViewMode.always
        
        // Set icon for emailtextfield
        let emailimageView = UIImageView()
        let emailimage = UIImage(named: "email.png")
        emailimageView.image = emailimage
        emailimageView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        emailTextField.leftView = emailimageView
        emailTextField.leftViewMode = UITextFieldViewMode.always
        
        // Set icon for passwordtextfield
        let passwordimageView = UIImageView()
        let passwordimage = UIImage(named: "password.png")
        passwordimageView.image = passwordimage
        passwordimageView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        passwordTextField.leftView = passwordimageView
        passwordTextField.leftViewMode = UITextFieldViewMode.always
        
        

    }
    
    func dismisskeyboard(){
        view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func createAccountAction(_ sender: AnyObject) {
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
                    
                    // Store first name and user type in database
                    
                    let firstname : [String : String] = ["firstname" : self.firstnameTextField.text!]
                    
                    switch self.segmentControl.selectedSegmentIndex
                    {
                    case 0:
                        ref.child("BlindUser").child(user!.uid).setValue(firstname)
                        ref.child("BlindUser").child(user!.uid).child("user_type").setValue("Blind")
                        ref.child("BlindUser").child(user!.uid).child("helper").setValue("")
                        
                    case 1:
                        ref.child("SightedUser").child(user!.uid).setValue(firstname)
                        ref.child("SightedUser").child(user!.uid).child("user_type").setValue("Sighted")
                        
                        ref.child("SightedUser").child(user!.uid).child("help_count").setValue(0)
                        ref.child("SightedUser").child(user!.uid).child("rating_sum").setValue(0)
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
    func backhomepage(){
        self.dismiss(animated: true, completion: nil)
    }
}




