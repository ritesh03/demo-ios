//
//  NoDataCell.swift
//  synex
//
//  Created by Subhash Mehta on 29/03/24.
//

import UIKit

class NoDataCell: UITableViewCell {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
