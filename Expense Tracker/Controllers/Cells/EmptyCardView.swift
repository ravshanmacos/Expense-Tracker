//
//  EmptyCardView.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/02/01.
//

import UIKit

class EmptyCardView: UIView {
    
    var navigation:UINavigationController?

    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func addCardTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let AddCardViewController = storyboard.instantiateViewController(identifier: "AddCardViewController")
        if let navigation{
            navigation.pushViewController(AddCardViewController, animated: true)
        }
        
    }
    
}
