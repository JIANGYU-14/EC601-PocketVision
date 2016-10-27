import UIKit
import Firebase

// Create data structure
/*
struct blindFirstnames {
    let firstname: String!
}

struct blindLocation {
    let latitude: Double!
    let longitude: Double!
}
 */

class HelpingTableViewController: UITableViewController {
    
    // List cells in table section
    var requests = [Request]()
    
    // var requestLocation = [blindLocation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Retrieve from database
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("BlindUser").queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            
            // Get user value
            let value = snapshot.value as? NSDictionary
            let firstname = value?["firstname"] as? String

            /*
            // Insert user value into data structure
            self.requests.insert(blindFirstnames(firstname: firstname), at: 0)
            self.tableView.reloadData()
            */
            
            self.requests.insert(Request(requester: firstname!)!, at: 0)
            
            
        })
        {
            (error) in
            print(error.localizedDescription)
        }
        
        /*
        // Retrieve from database for location
        
        ref.child("BlindUser").queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            
            // Get user value
            let value = snapshot.value as? NSDictionary
            let location = value?["location"] as? [Double:Double]
            
            // Insert user value into data structure
            self.requestLocation.insert(blindLocation(latitude: location![0], longitude: location![1]), at: 0)
            })
        {
            (error) in
            print(error.localizedDescription)
        }
 
 */

 
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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Load data into cell
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")

        let label = cell?.viewWithTag(1) as! UILabel
        label.text = requests[indexPath.row].firstname
        
        
        return cell!
    }
 */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "RequestTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RequestTableViewCell
        
        // Fetches the appropriate request for the data source layout.
        let request = requests[indexPath.row]
        
        cell.requesterName.text = request.requester
        
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
