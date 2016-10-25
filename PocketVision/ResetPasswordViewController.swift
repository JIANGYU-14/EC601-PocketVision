import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var emailAddress: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func canelReset(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
