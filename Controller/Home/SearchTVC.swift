//
//  SearchTVC.swift
//  synex
//
//  Created by Subhash Mehta on 28/03/24.
//

import UIKit

class SearchTVC: UITableViewCell {

    @IBOutlet weak var lblForDate: UILabel!
    @IBOutlet weak var lblForTime: UILabel!
    @IBOutlet weak var btnForfavorite: UIButton!
    @IBOutlet weak var lblForBPM: UILabel!
    @IBOutlet weak var lblForHeartRate: UILabel!
    @IBOutlet weak var lblForDescription: UILabel!
    @IBOutlet weak var btnForCheckRecord: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
