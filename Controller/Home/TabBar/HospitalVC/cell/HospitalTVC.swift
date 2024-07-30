//
//  HospitalTVC.swift
//  synex
//
//  Created by Subhash Mehta on 05/04/24.
//

import UIKit

class HospitalTVC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var lblForTitla: UILabel!
    @IBOutlet weak var lblForSubTitle: UILabel!
    @IBOutlet weak var imgForHospital: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
