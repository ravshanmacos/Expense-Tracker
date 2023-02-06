//
//  AddCardViewController.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/25.
//

import UIKit
import CoreData

class AddCardViewController: UIViewController {
    
    
  //MARK: - Outlets
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var balanceField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var cardBckStack: UIStackView!
    @IBOutlet weak var chooseBckButton: UIButton!
    @IBOutlet weak var active: UISwitch!
    
    //MARK: - Properties
    private let databaseHelper = DatabaseHelper()
    private let reuseIdentifier = Constants.CellIdentifiers.imageCell
    private let imageStrings = ["cardImage-1","cardImage-2","cardImage-3","cardImage-4","cardImage-5"]
    private var selectedImage: String?
    private var selectedCardType = "None"
    private var collectionView: UICollectionView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.delegate = self
        warningLabel.isHidden = true
        UIHelper.setupMenuButton(button: typeButton, listOfItems: ["None","MasterCard", "Visa Card","PayPal","Uzcard","Humo"], buttonAction: cardTypeDidChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func cardTypeDidChanged(_ title: String){
        selectedCardType = title
    }
    
    //MARK: - IBActions
    
    @IBAction func saveCardTapped(_ sender: Any) {
        if let fullname = nameField.text, let balance = balanceField.text, let selectedImage{
            warningLabel.isHidden = true
            var data = ["type":selectedCardType,"fullname":fullname,"balance":Double(balance), "bckImage":selectedImage, "active": false] as [String : Any]
            if active.isOn{
                data["active"] = true
                updateCardsStatus()
                databaseHelper.create(entityName: "CreditCard", data: data)
            }else{
                databaseHelper.create(entityName: "CreditCard", data: data)
            }
            navigationController?.popViewController(animated: true)
        }else{
            warningLabel.isHidden = false
        }
        
    }
    
    private func updateCardsStatus(){
        let request: NSFetchRequest<CreditCard> = CreditCard.fetchRequest()
       let cards = databaseHelper.fetchAll(with: request, predicate: nil)
        if cards.isEmpty {return}
        cards.forEach { card in
            databaseHelper.update(object: card, data: ["active": false])
        }
    }
    
    @IBAction func chooseBackgroundTapped(_ sender: Any) {
        setupCollectionView()
    }
    
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout.init()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        if let collectionView{
            collectionView.delegate = self
            collectionView.dataSource = self
            layout.scrollDirection = .horizontal
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
            animateCollectionView(collectionView: collectionView)
            cardBckStack.addArrangedSubview(collectionView)
            collectionView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        }
        
    }
    
    private func animateCollectionView(collectionView:UICollectionView){
        collectionView.alpha = 0
        let offset = CGPoint(x: -self.view.frame.maxX, y: 0)
        let x: CGFloat = 0, y: CGFloat = 0
        collectionView.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        collectionView.isHidden = false
        UIView.animate(
            withDuration: 0.6, delay: 0.3, usingSpringWithDamping: 0.47, initialSpringVelocity: 2,
            options: .curveEaseOut, animations: {
                collectionView.transform = .identity
                collectionView.alpha = 1
        })

    }

}

extension AddCardViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
}

extension AddCardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = imageStrings[indexPath.row]
        
        let offset = CGPoint(x: self.view.frame.maxX, y: 0)
        let x: CGFloat = 0, y: CGFloat = 0
        UICollectionView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.47, initialSpringVelocity: 3,options: .curveEaseOut, animations: {
            collectionView.transform = .identity
            collectionView.transform = CGAffineTransform(translationX: -offset.x + x, y: offset.y + y)
            collectionView.alpha = 0
        }) { [self] _ in
            self.chooseBckButton.setTitle("Image chosen", for: .normal)
            self.chooseBckButton.setImage(UIImage.init(systemName: "checkmark.circle.fill"), for: .normal)
            self.collectionView!.removeFromSuperview()
            self.collectionView = nil
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        cell.setCellImage(with: imageStrings[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 100, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}
