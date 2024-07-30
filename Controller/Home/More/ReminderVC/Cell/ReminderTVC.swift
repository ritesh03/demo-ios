//
//  ReminderTVC.swift
//  synex
//
//  Created by Subhash Mehta on 13/04/24.
//

import UIKit

class ReminderTVC: UITableViewCell {

    @IBOutlet weak var switchForOnOff: UISwitch!
    @IBOutlet weak var btnForEdit: UIButton!
    @IBOutlet weak var btnForDelete: UIButton!
    @IBOutlet weak var lblForDays: UILabel!
    @IBOutlet weak var lblForAMPM: UILabel!
    @IBOutlet weak var lblForTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
