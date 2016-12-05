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
        
        ref.child("SightedUser").child(userID!).observe(.value, with: { (snapshot) in
            
            // Get user value
            let value = snapshot.value as? NSDictionary
            let firstname = value?["firstname"] as? String
            
            // Replace default labels
            self.nameLabel.text = firstname
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Retrieve from storage
        let storage = FIRStorage.storage()
        let storageRef = FIRStorage.storage().reference(forURL: "gs://pocketvision-b0f1e.appspot.com")
        
        storageRef.child(userID!).data(withMaxSize: 1*1000*1000) { (data, error) in
            if error == nil {
                self.profilePicture.image = UIImage(data: data!)
            } else {
                print(error?.localizedDescription)
            }
            
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
                print("User didn't logout")
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

        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        profilePicture.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
        // Firebase user
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        // Firebase storage
        let storage = FIRStorage.storage()
        let storageRef = FIRStorage.storage().reference(forURL: "gs://pocketvision-b0f1e.appspot.com")
        
        let imagesRef = storageRef.child(userID!)
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload the file to the path
        let uploadTask = imagesRef.put(UIImageJPEGRepresentation(selectedImage, 0.8)!, metadata: metadata) { metadata, error in
            if (error != nil) {
                print(error?.localizedDescription)
            } else {
                print("Upload successful")
            }
        }
        
    }

}
