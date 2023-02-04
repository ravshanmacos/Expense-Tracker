//
//  NotificationCell.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/24.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var imageWrapper: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageWrapper.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
