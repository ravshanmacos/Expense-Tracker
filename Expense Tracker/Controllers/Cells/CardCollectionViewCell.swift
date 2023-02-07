//
//  CardCollectionViewCell.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/25.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardBckImage: UIImageView!
    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var cardHolder: UILabel!
    @IBOutlet weak var cardWrapper: UIView!
    @IBOutlet weak var blackBackground: UIView!
    @IBOutlet weak var cardLogoImage: UIImageView!
    @IBOutlet weak var currentMark: UILabel!
    
    let cardLogos = ["paypal", "mastercard","humo","uzcard","visa"]
    var delegate: CardDetails!
    var currentIndexPath: IndexPath!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardBckImage.layer.cornerRadius = 10
        blackBackground.layer.cornerRadius = 10
        cardWrapper.layer.cornerRadius = 10
        cardLogoImage.layer.cornerRadius = 5
    }
    
    func setBackgroundImage(with bckImage:UIImage){
        cardBckImage.image = bckImage
    }
    
    func setLogoImage(with type:String){
        cardLogos.forEach { logoString in
            if logoString.contains(type.lowercased()){
                cardLogoImage.image = UIImage(named: logoString)
            }
          
        }
        
    }
    
    func setCurrentBalance(with balance: String){
        currentBalance.text = balance
    }
    
    func setCardHolder(with name: String){
        cardHolder.text = name
    }
    
    func setCurrentMark(active:Bool){
        currentMark.isHidden = !active
    }
    
    @IBAction func detailsBtn(_ sender: Any) {
        
        delegate.cardDetails(indexPath: currentIndexPath)
    }
    

}
