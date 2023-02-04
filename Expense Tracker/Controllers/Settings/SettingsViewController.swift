//
//  SettingsViewController.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/29.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var changeCurrencyBtn: UIButton!
    @IBOutlet weak var changeLanguageBtn: UIButton!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var FaceIDSwitch: UISwitch!
    @IBOutlet weak var BackupSwitch: UISwitch!
    @IBOutlet weak var DarkModeSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIHelper.setupMenuButton(button: changeCurrencyBtn, listOfItems: ["Sum","Dollar", "Ruble"], buttonAction: currencyDidChanged)
        UIHelper.setupMenuButton(button: changeLanguageBtn, listOfItems: ["English", "Uzbek", "Russian"], buttonAction: languageDidChanged)
    }
    
    private func currencyDidChanged(_ title: String){
        print(title)
    }
    
    private func languageDidChanged(_ title: String){
        print(title)
    }
    
    @IBAction func notificationTapped(_ sender: UISwitch) {
        print(sender.isOn)
    }
    
    @IBAction func FaceIDTapped(_ sender: UISwitch) {
        print(sender.isOn)
    }
    
    @IBAction func BackupTapped(_ sender: UISwitch) {
        print(sender.isOn)
    }
    
    @IBAction func DarkModeTapped(_ sender: UISwitch) {
        print(sender.isOn)
    }
    

    @IBAction func clearDataTapped(_ sender: Any) {
    }
    
    @IBAction func deleteAccountTapped(_ sender: Any) {
    }
    
}
