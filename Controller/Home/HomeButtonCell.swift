//
//  HomeButtonCell.swift
//  synex
//
//  Created by Ritesh chopra on 07/09/23.
//

import UIKit

class HomeButtonCell: UITableViewCell {
    
    //MARK: - outlets
    @IBOutlet weak var insightButtonText: UILabel!
    @IBOutlet weak var insightButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
