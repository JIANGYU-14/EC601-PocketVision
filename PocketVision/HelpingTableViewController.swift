import UIKit
import CoreLocation
import Firebase

class HelpingTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    // List cells in table section
    var requests = [Request]()

    override func viewDidLoad() {
        super.viewDidLoad()
 
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
            }
        }
        
        // Retrieve from database
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("BlindUser").queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            
            // Get user value
            let value = snapshot.value as? NSDictionary
            let firstname = value?["firstname"] as? String
            let location = value?["location"] as? NSDictionary
            let latitude = location?["latitude"] as? Double
            let longitude = location?["longitude"] as? Double
            
            // Do not load data into cell if location does not exist
            if location != nil {
                self.requests.insert(Request(requester: firstname!, latitude: latitude!, longitude: longitude!)!, at: 0)
                self.tableView.reloadData()
                
            }
            
            
            })
        {
            (error) in
            print(error.localizedDescription)
        }
    }
 
 
        
    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
    // MARK: - Table view data source
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    */

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "RequestTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RequestTableViewCell
        
        // Fetches the appropriate request for the data source layout.
        let request = requests[indexPath.row]
        
        cell.requesterName.text = request.requester
        
        let coordinateSighted = CLLocation(latitude: self.locationManager.location!.coordinate.latitude, longitude: self.locationManager.location!.coordinate.longitude)
        let coordinateBlind = CLLocation(latitude: request.latitude, longitude: request.longitude)
        
        let distanceInMeters = coordinateBlind.distance(from: coordinateSighted)
        
        cell.distanceAway.text = String(distanceInMeters) + " m"
        
        return cell
    }
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
 */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "locateBlind") {
            
            let nav = segue.destination as! UINavigationController
            let locateBlindVC = nav.topViewController as! locateBlindViewController
            
            // Get the cell that generated this segue.
            if let selectedRequestCell = sender as? RequestTableViewCell {
                let indexPath = tableView.indexPath(for: selectedRequestCell)!
                
                let selectedPerson = requests[indexPath.row]
                locateBlindVC.person = selectedPerson

            }

    }
    }

    
    @IBAction func cancelAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}
