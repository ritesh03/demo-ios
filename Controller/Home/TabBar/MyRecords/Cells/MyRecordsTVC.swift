//
//  MyRecordsTVC.swift
//  synex
//
//  Created by Subhash Mehta on 23/03/24.
//

import UIKit

class MyRecordsTVC: UITableViewCell {
    @IBOutlet weak var viewForStatus: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var lblForTitle: UILabel!
    @IBOutlet weak var lblForTime: UILabel!
    
    @IBOutlet weak var lblForBPM: UILabel!
    @IBOutlet weak var lblForHeartRateValue: UILabel!
    @IBOutlet weak var lblForDescription: UILabel!
    
    @IBOutlet weak var btnForCheckRecord: UIButton!
    @IBOutlet weak var lblForStar: UILabel!
    @IBOutlet weak var btnForStar: UIButton!
    @IBOutlet weak var lblForShare: UILabel!
    @IBOutlet weak var btnForShare: UIButton!
    @IBOutlet weak var lblForNotes: UILabel!
    @IBOutlet weak var btnForNotes: UIButton!
    @IBOutlet weak var starredImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
