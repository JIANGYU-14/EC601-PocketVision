import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var emailAddress: UITextField!
    
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

        // Set layer for emailaddress
        let emailaddressborder = CALayer()
        let emailaddresswidth = CGFloat(2.0)
        emailaddressborder.borderColor = UIColor(red: 149,green: 165, blue: 166).cgColor
        emailaddressborder.frame = CGRect(x: 0, y: emailAddress.frame.size.height - emailaddresswidth, width:  emailAddress.frame.size.width, height: emailAddress.frame.size.height)
        emailaddressborder.borderWidth = emailaddresswidth
        
        // Customize placeholder in emailaddress
        emailAddress.attributedPlaceholder = NSAttributedString(string:"Email Address",attributes:[NSForegroundColorAttributeName: UIColor(red: 241,green: 241, blue:241)])
        emailAddress.textAlignment = NSTextAlignment.left
        emailAddress.font = emailAddress.font?.withSize(20)
        
        // Apply layer to textfield
        emailAddress.layer.addSublayer(emailaddressborder)
        
        // Set icon for emailaddress
        let emailaddressimageView = UIImageView()
        let emailaddressimage = UIImage(named: "ResetPassword.png")
        emailaddressimageView.image = emailaddressimage
        emailaddressimageView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        emailAddress.leftView = emailaddressimageView
        emailAddress.leftViewMode = UITextFieldViewMode.always
        

    }
    
    func dismisskeyboard(){
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func resetPasswordAction(_ sender: AnyObject) {
        if self.emailAddress.text!.isEmpty
        {
            let alert = UIAlertController(title: "Error", message: "Please enter an email address", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()?.sendPasswordReset(withEmail: self.emailAddress.text!, completion: { (error) in
                if error != nil
                {
                    let alert = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    let alert = UIAlertController(title: "Success", message: "Password reset email sent", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: {
                        action in self.dismiss(animated: true, completion: nil)})
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    

                }
            })
        }
    }
    
    func backhomepage(){
        self.dismiss(animated: true, completion: nil)
    }
    

}
