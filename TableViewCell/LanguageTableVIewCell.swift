//
//  LanguageTableVIewCell.swift
//  synex
//
//  Created by Ritesh Chopra on 18/01/23.
//


import UIKit

class LanguageTableViewCell: UITableViewCell {

    @IBOutlet weak var langLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
