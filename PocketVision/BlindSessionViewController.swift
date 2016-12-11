import UIKit
import Firebase
import CoreLocation


class BlindSessionViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var helperLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set the background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        // Hide navigation bar but keep navigation bar button
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

        // Set Navigationbar Title
        self.navigationItem.title = "Help Accepted"
        
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("BlindUser").child(userID!).observe(.value, with:{(snapshot) in
            
            // Get helper's firstname
            let value = snapshot.value as? NSDictionary
            let helperID = value?["helper"] as? String
            
            // If the helper didn't end the session, display the his firstname
            if helperID != ""{
                ref.child("SightedUser").child(helperID!).observe(.value, with:{(snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let helpername = value?["firstname"] as? String
                    
                    let location = value?["location"] as? NSDictionary
                    let helperlatitude = location?["latitude"] as? Double
                    let helperlongitude = location?["longitude"] as? Double
                    
                    let locationRequester = CLLocation(latitude: self.locationManager.location!.coordinate.latitude, longitude: self.locationManager.location!.coordinate.longitude)
                    
                    let locationHelper = CLLocation(latitude: helperlatitude!, longitude: helperlongitude!)
                    
                    // let distance = locationHelper.distance(from: locationRequester)
                    
                    // Customize Font & Colors in Label (Do not set anything in Storyboard)
                    let MutableString: NSMutableAttributedString = NSMutableAttributedString(string: helpername! + " is on the way!" as String, attributes: [NSFontAttributeName:UIFont(name:"Noteworthy-Light", size: 35)!])
                    self.helperLabel.attributedText = MutableString
                    self.helperLabel.textColor = UIColor(red: 100,green: 251, blue: 178)
                    
                    
                })
            }
        })
        
        checkFirebase()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Navigate back to homepage if SightedUser ended the session
    func checkFirebase() {
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        // Check "helper" value
        ref.child("BlindUser").child(userID!).observe(.value, with: {(snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let helper = value?["helper"] as? String
            
            if helper == "" {
                self.performSegue(withIdentifier: "endBlindSession", sender: self )
                //self.dismiss(animated: true, completion: nil)
                //self.presentingViewController?.dismiss(animated: false, completion: nil)
                //self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        })
    }
    @IBAction func cancelAction(_ sender: Any) {
        
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("BlindUser").child(userID!).observe(.value, with:{(snapshot) in
            
            // Get helper's firstname
            let value = snapshot.value as? NSDictionary
            let helperID = value?["helper"] as? String
            
            // If the helper didn't end the session, display the his firstname
            if helperID != ""{
                ref.child("SightedUser").child(helperID!).observe(.value, with:{(snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let helpername = value?["firstname"] as? String
                    
                    let location = value?["location"] as? NSDictionary
                    let helperlatitude = location?["latitude"] as? Double
                    let helperlongitude = location?["longitude"] as? Double
                    
                    let locationRequester = CLLocation(latitude: self.locationManager.location!.coordinate.latitude, longitude: self.locationManager.location!.coordinate.longitude)
                    
                    let locationHelper = CLLocation(latitude: helperlatitude!, longitude: helperlongitude!)
                    
                    let distance = locationHelper.distance(from: locationRequester)
                    
                    
                    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                    alert.message = "Your helper, " + helpername! + ", is only " + String(format: "%.2f", (distance/1000)) + " kilometers away from you. Are you sure you want to cancel?"
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:{
                        
                        action in
                        
                        self.performSegue(withIdentifier: "endBlindSession", sender: self)
                        //self.presentingViewController?.dismiss(animated: false, completion: nil)
                        //self.presentingViewController?.dismiss(animated: true, completion: nil)
                        
                        // Set request value to "Cancel"
                        let ref = FIRDatabase.database().reference()
                        let userID = FIRAuth.auth()?.currentUser?.uid
                        
                        ref.child("BlindUser").child(userID!).child("request").setValue("Inactive")
                        ref.child("BlindUser").child(userID!).child("helper").setValue("")
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "No", style: .default, handler:{
                        action in
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                    
                })
            }
        })
        
        /*
         let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
         alert.message = "Are you sure you want to cancel the request?"
         alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:{
         
         action in
         
         // Retrieve from database
         let ref = FIRDatabase.database().reference()
         let userID = FIRAuth.auth()?.currentUser?.uid
         
         ref.child("BlindUser").child(userID!).child("request").setValue("Inactive")
         
         self.dismiss(animated: true, completion: nil)
         
         }))
         
         alert.addAction(UIAlertAction(title: "No", style: .default, handler:{
         action in
         }))
         self.present(alert, animated: true, completion: nil)
         */
    }
    
    
    
}
