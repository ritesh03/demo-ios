//
//  HomeHeaderCell.swift
//  synex
//
//  Created by Ritesh chopra on 05/09/23.
//

import UIKit

class HomeHeaderCell: UITableViewCell {

    @IBOutlet weak var recordEKGLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var recordEKGButton: UIButton!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reportStatusLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var bpmValueLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
