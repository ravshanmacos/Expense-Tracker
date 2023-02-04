//
//  ImageCollectionViewCell.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/26.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCellImage(with imageString:String){
        cellImage.image = UIImage(named: imageString)
    }
    
}
