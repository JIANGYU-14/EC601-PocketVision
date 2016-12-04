import UIKit
import Firebase
import MapKit

class SightedViewController: UIViewController, CLLocationManagerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    let recognizer = UITapGestureRecognizer()
    
    let requestlocation = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable touch on image
        recognizer.addTarget(self, action: #selector(SightedViewController.profileImageHasBeenTapped))
        profilePicture.addGestureRecognizer(recognizer)
        
        
        // Ask user for location service on this page
        self.requestlocation.requestWhenInUseAuthorization()
        
        // Retrieve from database
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        // ref.child("SightedUser").child(userID!).child("status").setValue("Available")
        
        ref.child("SightedUser").child(userID!).observe(.value, with: { (snapshot) in
            
            // Get user value
            let value = snapshot.value as? NSDictionary
            let firstname = value?["firstname"] as? String
            
            // Replace default labels
            self.nameLabel.text = firstname
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let alert = UIAlertController(title: "Logout", message: "Log out of Pocket Vision?", preferredStyle: .alert)
        
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
    
    func profileImageHasBeenTapped(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
   /*
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        profilePicture.image = image
        self.dismiss(animated: true, completion: nil);
    }
 */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        profilePicture.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

}
