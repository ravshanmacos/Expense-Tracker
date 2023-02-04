//
//  GeneralTableViewCell.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/24.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    var cellImage: UIImage?
    var imageWrapper:UIView = {
       let wrapper = UIView()
        wrapper.backgroundColor = .blue
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        return wrapper
    }()
    var cellTitle:UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageWrapper.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImageBackgroundColor(color:UIColor){
        imageWrapper.backgroundColor = color
    }
    
    func setCellImage(image:UIImage){
        cellImage = image
    }
    
    func setCellTitle(title:String){
        cellTitle.text = title
    }
    
}
//chevron.forward
