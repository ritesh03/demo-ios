//
//  MyRecordsCallenderTVC.swift
//  synex
//
//  Created by Subhash Mehta on 23/03/24.
//

import UIKit
import FSCalendar

class MyRecordsCallenderTVC: UITableViewCell {

    @IBOutlet weak var btnForPre: UIButton!
    @IBOutlet weak var btnForNext: UIButton!
    
    @IBOutlet weak var calenderForRequest: FSCalendar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
