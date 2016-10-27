import UIKit
import MapKit
import Firebase

class locateBlindViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var currentlocation: MKMapView!
    
    var person: Request!

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let person = person {
            print(person.requester)
        }
        
        

        if CLLocationManager.locationServicesEnabled() {
            
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined:
                print("No access")
            case .denied:
                print("User turned off the location services for PocketVision")
                let alert = UIAlertController(title: "Location services disabled", message: "Please turn on location services in order to use Pocket Vision", preferredStyle: .alert)
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
                
                self.currentlocation.showsUserLocation = true
                
                // Create database reference
                
                let ref = FIRDatabase.database().reference()
                
                let userID = FIRAuth.auth()?.currentUser?.uid
                
                // The user must be Sighted
                
                ref.child("SightedUser").child(userID!).observe(.value, with: { (snapshot) in
                    
                    // Get user value
                    let value = snapshot.value as? NSDictionary

                    // Store location for SightedUser in database
                        
                    let location = ["latitude" : self.locationManager.location!.coordinate.latitude,
                                    "longitude" : self.locationManager.location!.coordinate.longitude]
                        
                    ref.child("SightedUser").child(userID!).child("location").setValue(location)
                    
                }) { (error) in
                    print(error.localizedDescription)
                    print("Check Internet Connection!!!")
                }
                
                // Retrieve location from database
                /*
                 ref.child("users").child(userID!).child("location").observe(.value, with: { (snapshot) in
                 // Get user value
                 let value = snapshot.value as? NSDictionary
                 let latitude = value?["latitude"] as! Double
                 let longitude = value?["longitude"] as! Double
                 
                 // Plot locaiton on map
                 
                 let location = CLLocationCoordinate2DMake(latitude, longitude)
                 
                 let annotation = MKPointAnnotation()
                 annotation.coordinate = location
                 annotation.title = "Test location"
                 
                 self.currentLocation.addAnnotation(annotation)
                 
                 
                 }) { (error) in
                 print(error.localizedDescription)
                 }
                 */
                
            }
        } else {
            print("Location services are not enabled")
            
            // Prompt user to turn location service
            /*let alert = UIAlertController(title: "Location services disabled", message: "GPS access is restricted. In order to use tracking, please enable GPS in the Settigs app under Privacy, Location Services.", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
             self.present(alert, animated: true, completion: nil)*/
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        self.currentlocation.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors: " + error.localizedDescription)
    }
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}
