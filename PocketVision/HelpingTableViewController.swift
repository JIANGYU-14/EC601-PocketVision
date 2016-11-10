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
        
        // Pull to refresh the data
        self.refreshControl?.addTarget(self, action: #selector(HelpingTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
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
                
                let locationSighted = CLLocation(latitude: self.locationManager.location!.coordinate.latitude, longitude: self.locationManager.location!.coordinate.longitude)
                let locationBlind = CLLocation(latitude: latitude!, longitude: longitude!)
                let distance = locationBlind.distance(from: locationSighted)
                
                self.requests.insert(Request(requester: firstname!, latitude: latitude!, longitude: longitude!, distance: distance/1000)!, at: 0)
                
                self.tableView.reloadData()
            }
        })
        {
            (error) in
            print(error.localizedDescription)
        }    }
    
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
        
        let sorted = requests.sorted(by: {$0.distance < $1.distance})
        
        let request = sorted[indexPath.row]
        
        cell.requesterName.text = request.requester
        
        let coordinateSighted = CLLocation(latitude: self.locationManager.location!.coordinate.latitude, longitude: self.locationManager.location!.coordinate.longitude)
        let coordinateBlind = CLLocation(latitude: request.latitude, longitude: request.longitude)
        
        // Calculate distance between sighted user and blind user
        let distanceInMeters = coordinateBlind.distance(from: coordinateSighted)
        
        cell.distanceAway.text = String(format: "%.2f", (distanceInMeters/1000)) + " km"
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "locateBlind") {
            
            let nav = segue.destination as! UINavigationController
            
            let locateBlindVC = nav.topViewController as! locateBlindViewController
            
            // Get the cell that generated this segue.
            if let selectedRequestCell = sender as? RequestTableViewCell {
                
                let indexPath = tableView.indexPath(for: selectedRequestCell)!
                
                let sorted = requests.sorted(by: {$0.distance < $1.distance})
                
                let selectedPerson = sorted[indexPath.row]
                
                locateBlindVC.person = selectedPerson

            }

    }
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl){
        
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
                let locationSighted = CLLocation(latitude: self.locationManager.location!.coordinate.latitude, longitude: self.locationManager.location!.coordinate.longitude)
                let locationBlind = CLLocation(latitude: latitude!, longitude: longitude!)
                let distance = locationBlind.distance(from: locationSighted)
                
                self.requests.insert(Request(requester: firstname!, latitude: latitude!, longitude: longitude!,distance: distance/1000)!, at: 0)
            }
        })
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    @IBAction func refresh(_ sender: AnyObject) {
        
        
        
        print("Refresh the list")
        /*
        requests = [Request]()
        
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
                let locationSighted = CLLocation(latitude: self.locationManager.location!.coordinate.latitude, longitude: self.locationManager.location!.coordinate.longitude)
                let locationBlind = CLLocation(latitude: latitude!, longitude: longitude!)
                let distance = locationBlind.distance(from: locationSighted)
                
                self.requests.insert(Request(requester: firstname!, latitude: latitude!, longitude: longitude!,distance: distance/1000)!, at: 0)
                self.tableView.reloadData()
                
            }
            })
        {
            (error) in
            print(error.localizedDescription)
        }
        */

    }
    
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}
