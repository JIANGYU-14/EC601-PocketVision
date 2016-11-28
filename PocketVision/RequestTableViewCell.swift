//
//  RequestTableViewCell.swift
//  PocketVision
//
//  Created by Sherman Sze on 10/27/16.
//
//

import UIKit

class RequestTableViewCell: UITableViewCell {
    
    // MARK: Properties

    @IBOutlet weak var requesterName: UILabel!
    @IBOutlet weak var distanceAway: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
