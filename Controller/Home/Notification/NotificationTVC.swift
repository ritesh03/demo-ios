//
//  NotificationTVC.swift
//  synex
//
//  Created by Subhash Mehta on 02/04/24.
//

import UIKit

class NotificationTVC: UITableViewCell {

    @IBOutlet weak var lblForName: UILabel!
    @IBOutlet weak var lblForSubTitle: UILabel!
    @IBOutlet weak var btnForUpdate: UIButton!
    @IBOutlet weak var imgViewForIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
