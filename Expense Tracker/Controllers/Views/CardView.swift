//
//  CardView.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/02/01.
//

import UIKit

class CardView: UIView {

    @IBOutlet weak private var balanceLabel: UILabel!
    @IBOutlet weak private var cardBckImage: UIImageView!
    @IBOutlet weak private var logoImage: UIImageView!
    @IBOutlet private weak var holderName: UILabel!
    
    let cardLogos = ["paypal", "mastercard","humo","uzcard","visa"]
    
    func setHolderName(with name: String){
        holderName.text = name
    }
    
    func setBalance(with balance:Double){
        let formattedString = Helper.balanceFormatter(with: balance)
        balanceLabel.text = formattedString
    }
    
    func setCardBckImage(with bckImage: String?){
        if let bckImage{
            cardBckImage.image = UIImage(named: bckImage)
        }else{
            print("Image does not exist")
        }
        
    }
    
    func setLogoImage(with type:String){
        logoImage.layer.cornerRadius = 5
        cardLogos.forEach { logoString in
            if logoString.contains(type.lowercased()){
                logoImage.image = UIImage(named: logoString)
            }
          
        }
        
    }

}
