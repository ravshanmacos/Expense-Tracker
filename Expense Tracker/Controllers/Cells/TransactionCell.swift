//
//  TransactionCell.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/24.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var imageWrapper: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageWrapper.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTitle(with title:String){
        self.title.text = title
    }
    
    func setTime(with time:Date){
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let timeString = formatter.string(from: time)
        self.time.text = timeString
    }
    
    func setAmount(with amount:Double, type:String){
        let formattedAmount = Helper.balanceFormatter(with: amount)!
        
        switch type{
        case "income":
            self.amount.text = "+ \(formattedAmount)"
            self.amount.textColor = UIColor(named: "green-light")
        case "expense":
            self.amount.text = "- \(formattedAmount)"
            self.amount.textColor = UIColor(named: "orange")
        default:
            self.amount.textColor = UIColor(named: "gray-dark")
        }
       
        
    }
    
}
