//
//  HomeFooterCell.swift
//  synex
//
//  Created by Ritesh chopra on 05/09/23.
//

import UIKit

class HomeFooterCell: UITableViewCell {

    //MARK: - outlets
    
    @IBOutlet weak var getStartedLabel: UILabel!
    @IBOutlet weak var addBloodPressureLabel: UILabel!
    @IBOutlet weak var bloodPressureView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomView.cornerRadius = 8
        bottomView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
