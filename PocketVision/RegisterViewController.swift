import UIKit
import Firebase

class RegisterViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
                    let congrats = UIAlertController(title: "Congratulations!", message: "You have successfully registered!", preferredStyle: .alert)
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
            let alert = UIAlertController(title: "Error", message: "Please Enter All Required Info", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func cancelAction(_ sender: AnyObject) {
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
