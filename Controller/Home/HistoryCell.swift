//
//  HistoryCell.swift
//  synex
//
//  Created by Ritesh chopra on 05/09/23.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    //MARK: - outlets
    @IBOutlet weak var mainViewTopContraint: NSLayoutConstraint!
    @IBOutlet weak var reportStatusView: UIView!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var reportStatusLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var leadLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var leadView: UIView!
    @IBOutlet weak var saveInCloudButton: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    @IBOutlet weak var graphButton: UIButton!
    var favButtonAction: ((Any) -> Void)?

        @objc func favButtonPressed(sender: Any) {
            self.favButtonAction?(sender)
        }
    
    var shareButtonAction: ((Any) -> Void)?

        @objc func shareButtonPressed(sender: Any) {
            self.shareButtonAction?(sender)
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leadView.cornerRadius = 8
        leadView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMaxYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
