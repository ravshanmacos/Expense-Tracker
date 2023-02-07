//
//  MyCardsViewController.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/20.
//

import UIKit
import CoreData

class MyCardsViewController: UIViewController {
    
   //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
   
    //MARK: - Properties
    private let mycardToUpdateCard = Constants.Segues.mycardToUpdateCard
    private let reuseIdentifier = Constants.CellIdentifiers.cardCell
    private let addButtonImage = UIImage.init(systemName: "plus")
    
    private var creditCards: [CreditCard] = []
    private var selectedCard: CreditCard?
    
    
    //MARK: - Instances
    private var databaseHelper = DatabaseHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseHelper.loading.toggle()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        loadCreditCards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navItem = tabBarController?.navigationItem
        navItem?.title = "My Cards"
        //Add Card Button
        let addButton = UIBarButtonItem(image: addButtonImage, style: .plain, target: self, action: #selector(addTapped))
        addButton.tintColor = UIColor(named: "gray-dark")
        navItem?.rightBarButtonItem = addButton
        loadCreditCards()
    }
    
    @objc private func addTapped(){
        performSegue(withIdentifier: Constants.Segues.mycardToAddcard, sender: self)
    }
}

//MARK: - Custom Methods
extension MyCardsViewController{
    private func loadCreditCards(){
        let request: NSFetchRequest<CreditCard> = CreditCard.fetchRequest()
        creditCards = databaseHelper.fetchAll(with: request, predicate: nil)
        databaseHelper.loading.toggle()
        collectionView.reloadData()
    }
    
    func creditCardModifier(creditCard:CreditCard)-> (type:String, fulname:String, balance:String, bckImage:UIImage, status: Bool){
        let card: (type:String, fulname:String, balance:String, bckImage:UIImage, status: Bool)
        card.type = creditCard.type!
        card.fulname = creditCard.fullname!
        let formattedString = Helper.balanceFormatter(with: creditCard.balance)
        card.balance = formattedString!
        card.bckImage = UIImage(named: creditCard.bckImage!)!
        card.status = creditCard.active
        return card
    }
}



//MARK: - UICollectionViewDataSource
extension MyCardsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        creditCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CardCollectionViewCell
        let card = creditCardModifier(creditCard: creditCards[indexPath.row])
        cell.setCurrentBalance(with: card.balance)
        cell.setBackgroundImage(with: card.bckImage)
        cell.setCardHolder(with: card.fulname)
        cell.setCurrentMark(active: card.status)
        cell.setLogoImage(with: card.type)
        cell.delegate = self
        cell.currentIndexPath = indexPath
        return cell
    }
    
   
    
    
}

//MARK: - UICollectionViewDelegate
extension MyCardsViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        for (index,card) in creditCards.enumerated(){
            if index == indexPath.row{
                databaseHelper.update(object: card, data: ["active":true])
            }else{
                databaseHelper.update(object: card, data: ["active":false])
            }
        }
        loadCreditCards()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == mycardToUpdateCard{
            let destinationVC = segue.destination as! UpdateCardViewController
            destinationVC.selectedCard = self.selectedCard
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MyCardsViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 350, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}

extension MyCardsViewController: CardDetails{
    func cardDetails(indexPath: IndexPath) {
        selectedCard = creditCards[indexPath.row]
        performSegue(withIdentifier: mycardToUpdateCard, sender: self)
    }
}


protocol CardDetails{
    func cardDetails(indexPath:IndexPath)
}


