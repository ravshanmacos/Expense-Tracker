//
//  Language.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/29.
//

import Foundation

class Language{
    let name:String
    var isChosen:Bool
    init(name: String, isChosen: Bool = false) {
        self.name = name
        self.isChosen = isChosen
    }
}
