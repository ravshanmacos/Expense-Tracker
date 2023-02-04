//
//  Helper.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/02/02.
//

import Foundation

struct Helper{
    static func balanceFormatter(with balance: Double)-> String?{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        let formattedString = formatter.string(from: NSNumber(value: UInt(balance)))
        return formattedString
    }
}
