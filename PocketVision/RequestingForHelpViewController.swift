import UIKit
import MapKit
import Firebase

class RequestingForHelpViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var blindnameLabel: UILabel!

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide navigation bar but keep navigation bar button
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        // Set Navigationbar Title
        self.navigationItem.title = "Requesting Help"
        
        // Set the background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        // Create database reference
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid

        // Get current BlindUser's name
        ref.child("BlindUser").child(userID!).observe(.value, with: {(snapshot) in
            
            // Get BlindUser value
            let value = snapshot.value as? NSDictionary
            let currentblindname = value?["firstname"] as? String
            
            // Customize Font & Colors in Label (Do not set anything in Storyboard)
            let MutableString: NSMutableAttributedString = NSMutableAttributedString(string: currentblindname! as String, attributes: [NSFontAttributeName:UIFont(name:"Noteworthy-Light", size: 48)!])
            self.blindnameLabel.attributedText = MutableString
            self.blindnameLabel.textColor = UIColor(red: 100,green: 251, blue: 178)
            
        })
        
        checkFirebase()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled() {
            
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined:
                print("No access")
            case .denied:
                print("Location services turned off for PocketVision")
                let alert = UIAlertController(title: "Location services disabled", message: "Please turn on location services in order to use PocketVision", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case .restricted:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access granted")
                
                self.locationManager.delegate = self
                
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                
                self.locationManager.requestWhenInUseAuthorization()
                
                self.locationManager.startUpdatingLocation()
                
                // self.currentLocation.showsUserLocation = true
                
                // Create database reference
                
                let ref = FIRDatabase.database().reference()
                
                let userID = FIRAuth.auth()?.currentUser?.uid
                
                let blindlocation = ["latitude" : self.locationManager.location!.coordinate.latitude,
                                       "longitude" : self.locationManager.location!.coordinate.longitude]
                
                // Store location for BlindUser in database
                ref.child("BlindUser").child(userID!).child("location").setValue(blindlocation)

          
            }
        } else {
            print("Location services are not enabled")
            
            // Prompt user to turn on location services
            let alert = UIAlertController(title: "Location services disabled", message: "To enable location services: Settings -> Privacy -> Location Services", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        // self.currentLocation.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func checkFirebase() {

        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        // Check "helper" value
        ref.child("BlindUser").child(userID!).observe(.value, with:{(snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let helper = value?["helper"] as? String
            
            if helper != "" {
                self.performSegue(withIdentifier: "helperComing", sender: self )
            }
        })
            
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors: " + error.localizedDescription)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelRequest(_ sender: AnyObject) {

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.message = "Are you sure you want to cancel the request?"
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:{
            
            action in
            
            // Retrieve from database
            let ref = FIRDatabase.database().reference()
            let userID = FIRAuth.auth()?.currentUser?.uid
            
            ref.child("BlindUser").child(userID!).child("request").setValue("Inactive")
            ref.child("BlindUser").child(userID!).child("requesttype").setValue("")
            
            self.performSegue(withIdentifier: "cancelrequest", sender: self)
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler:{
            action in
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }



}
