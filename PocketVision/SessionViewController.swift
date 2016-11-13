import UIKit
import MapKit
import Firebase


class SessionViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var sessionMap: MKMapView!
    
    var person: Request!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var needHelp = person.requester
        var helpLatitude = person.latitude
        var helpLongitude = person.longitude
        
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
                
                // Plot sighted user location on map
                
                self.sessionMap.showsUserLocation = true
                
                // Create database reference
                
                let ref = FIRDatabase.database().reference()
                
                let userID = FIRAuth.auth()?.currentUser?.uid
                
                let sightedlocation = ["latitude" : self.locationManager.location!.coordinate.latitude,
                                       "longitude" : self.locationManager.location!.coordinate.longitude]
                
                // Store location for Sighteduser in database
                ref.child("SightedUser").child(userID!).child("location").setValue(sightedlocation)
                
                // Plot blind user locaiton on map
                let location = CLLocationCoordinate2DMake(helpLatitude, helpLongitude)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = needHelp
                
                self.sessionMap.addAnnotation(annotation)
            }
            
        } else {
            print("Location services are not enabled")
            
            // Prompt user to turn location service
            let alert = UIAlertController(title: "Location services disabled", message: "GPS access is restricted. In order to use tracking, please enable GPS in the Settigs app under Privacy, Location Services.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
        
        self.sessionMap.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors: " + error.localizedDescription)
    }


}
