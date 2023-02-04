//
//  EditViewController.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/29.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var OldPassword: UITextField!
    @IBOutlet weak var NewPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Username.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

}
