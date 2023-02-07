//
//  UpdateCardViewController.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/02/06.
//

import UIKit
import CoreData

class UpdateCardViewController: UIViewController {
    
    
  //MARK: - Outlets
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var balanceField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var cardBckStack: UIStackView!
    @IBOutlet weak var chooseBckButton: UIButton!
    @IBOutlet weak var active: UISwitch!
    
    //MARK: - Properties
    
    //constants
    private let reuseIdentifier = Constants.CellIdentifiers.imageCell
    private var cardTypes = Constants.Categories.cardTypes
    private let cardBckImgStrings = Constants.Images.cardBackgroundImagesStrings
   
    //variables
    private var databaseHelper = DatabaseHelper()
    private var selectedCardType = "None"
    private var collectionView: UICollectionView?
    private var selectedImage: String?
    
    var selectedCard: CreditCard?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.delegate = self
        warningLabel.isHidden = true
       
        initUIWithSelectedCard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func cardTypeDidChanged(_ title: String){
        selectedCardType = title
    }
    
    //MARK: - IBActions
    
    @IBAction func saveCardTapped(_ sender: Any) {
        let image = selectedImage == nil ? selectedCard?.bckImage : selectedImage
        if let fullname = nameField.text, let balance = balanceField.text{
            
            warningLabel.isHidden = true
            var data:[String:Any] = ["type":selectedCardType,"fullname":fullname,"balance":Double(balance), "bckImage":image, "active": false]
            if active.isOn{
                data["active"] = true
                updateCardsStatus()
                databaseHelper.update(object: selectedCard!, data: data)
            }else{
                databaseHelper.update(object: selectedCard!, data: data)
            }
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func chooseBackgroundTapped(_ sender: Any) {
        setupCollectionView()
    }

}

//MARK: - UI Related
extension UpdateCardViewController{
    
    private func initUIWithSelectedCard(){
        guard let card = selectedCard else{return}
        nameField.text = card.fullname
        balanceField.text = String(card.balance)
        active.isOn = card.active
        selectedCardType = card.type!
        if let cardTypeIndex = cardTypes.firstIndex(of: card.type!){
            cardTypes.swapAt(cardTypeIndex, 0)
            UIHelper.setupMenuButton(button: typeButton, listOfItems: cardTypes, buttonAction: cardTypeDidChanged)
        }else{
            UIHelper.setupMenuButton(button: typeButton, listOfItems: cardTypes, buttonAction: cardTypeDidChanged)
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
    
    //setting up collection view
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
    
    //animation
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

//MARK: - Database Related

extension UpdateCardViewController{

}

//MARK: - UITextFieldDelegate

extension UpdateCardViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - UICollectionViewDataSource

extension UpdateCardViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cardBckImgStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        cell.setCellImage(with: cardBckImgStrings[indexPath.row])
        return cell
    }
    
   
}

//MARK: - UICollectionViewDelegateFlowLayout
extension UpdateCardViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 100, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
//MARK: - UICollectionViewDelegate
extension UpdateCardViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = cardBckImgStrings[indexPath.row]
        
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
}
