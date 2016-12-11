import UIKit
import MapKit
import Firebase


class SightedSessionViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var sessionMap: MKMapView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer = Timer()
    var seconds = 0
    var minutes = 0
    
    var person: Request!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Navigationbar Title
        self.navigationItem.title = "Current Help Session"
        
        // Hide navigation bar but keep navigation bar button
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        // Set the background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)

        // Updateing time every seconds
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        
        checkcancel()
    }
    
    func checkcancel(){
        let ref = FIRDatabase.database().reference()
        
        // Check if the Requester cancel the help
        ref.child("BlindUser").child(self.person.blindID).observe(.value, with: {(snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let request = value?["request"] as? String
            
            if request == "Inactive" {
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                alert.message = "The requester had to cancel this session. We hope to see you again!"
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{
                    
                    action in
                    
                    self.performSegue(withIdentifier: "endSession", sender: self)
                }))
                self.present(alert, animated: true, completion: nil)

            }
        })

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
    
    func updateTime() {
        
        seconds += 1
        
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        
        let strMins = String(format: "%02d", minutes)
        let strSecs = String(format: "%02d", seconds)

        timerLabel.text = "\(strMins):\(strSecs)"
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
    
    @IBAction func endSession(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.message = "Are you sure you want to help end the session?"
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:{
            
            action in
            
            let ref = FIRDatabase.database().reference()
            
            let userID = FIRAuth.auth()?.currentUser?.uid
            
            ref.child("BlindUser").child(self.person.blindID).child("helper").setValue("")
            ref.child("BlindUser").child(self.person.blindID).child("request").setValue("Inactive")
            
            
            self.performSegue(withIdentifier: "endSession", sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Not yet", style: .default, handler:{
            action in
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    


}
