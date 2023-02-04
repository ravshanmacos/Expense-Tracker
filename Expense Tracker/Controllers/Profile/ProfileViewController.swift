//
//  ProfileViewController.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/20.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.layer.cornerRadius = 30
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "Profile"
        let image = UIImage.init(systemName: "pencil")
        let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(editTapped))
        tabBarController?.navigationItem.rightBarButtonItem = barButton
        
    }
    
    @objc private func editTapped(){
        performSegue(withIdentifier: Constants.Segues.profileToEdit, sender: self)
    }
    

}
