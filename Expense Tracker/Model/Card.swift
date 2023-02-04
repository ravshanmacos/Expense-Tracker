//
//  Card.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/28.
//

import Foundation
import UIKit

class Card{
    let cardHolder:String
    let cardBalance:String
    let cardBckImage:UIImage
    let cardLogoImage:UIImage
    private var active = false

    init(cardHolder: String, cardBalance: String, cardBckImage: UIImage, cardLogoImage: UIImage) {
        self.cardHolder = cardHolder
        self.cardBalance = cardBalance
        self.cardBckImage = cardBckImage
        self.cardLogoImage = cardLogoImage
    }

    func setCardStatus(active:Bool){
        self.active = active
    }

    func getCardStatus()->Bool{
        return self.active
    }
}
