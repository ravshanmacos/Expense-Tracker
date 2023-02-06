//
//  HomeViewController.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/20.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var cardViewStack: UIStackView!
    
    
    //MARK: - Properties
    private lazy var emptyCardView:EmptyCardView = {
        return (UINib(nibName: "EmptyCardView", bundle: nil).instantiate(withOwner: nil).first as! EmptyCardView)
    }()
    private lazy var cardView:CardView = {
        return UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: nil).first as! CardView
    }()
    private let transactionReuseIdentifier = Constants.CellIdentifiers.transactionCell
    private let loadingReuseIdentifier = Constants.CellIdentifiers.loadingCell
    private let emptyReuseIdentifier = Constants.CellIdentifiers.emptyCell
    private let menuImage = UIImage.init(systemName: "circle.grid.2x2.fill")
    private let notifyImage = UIImage.init(systemName: "bell.fill")
    private var currentCard:CreditCard?
    private var transactions:[String] = []
    private var loading = true
    private var isAdded = false
    
    //MARK: - Instances
    private var databaseHelper = DatabaseHelper()
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    
    //MARK: - Overriding
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController = databaseHelper.setObserver(entityName: "CreditCard")
        fetchedResultsController!.delegate = self
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 70
        tableview.register(UINib(nibName: "TransactionCell", bundle: nil), forCellReuseIdentifier: transactionReuseIdentifier)
        tableview.register(UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: loadingReuseIdentifier)
        tableview.register(UINib(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: emptyReuseIdentifier)
        loadCurrentCard()
        initCardView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavButtons()
    }
    
    //MARK: - button Actions
    

    @objc private func butttonTapped(){
        print("butttonTapped")
    }
    @objc private func notifyTapped(){
        performSegue(withIdentifier: Constants.Segues.homeToNotification, sender: self)
    }
}

//MARK: - UI Related

extension HomeViewController{
    
    //Init Empty CardView or Card view according data state
    private func initCardView(){
         cardViewStack.removeFullyAllArrangedSubviews()
            cardViewStack.layer.cornerRadius = 10
            cardViewStack.backgroundColor = UIColor(named: "blue-light")
            emptyCardView.navigation = navigationController
        
        if let currentCard{
            
            cardView.setHolderName(with: currentCard.fullname!)
            cardView.setLogoImage(with: currentCard.type!)
            cardView.setBalance(with: currentCard.balance)
            cardView.setCardBckImage(with: currentCard.bckImage)
            cardViewStack.addArrangedSubview(cardView)
        } else {
            cardViewStack.removeArrangedSubview(cardView)
            cardViewStack.addArrangedSubview(emptyCardView)
        }
    }
    
    private func initNavButtons(){
        guard let navItem = tabBarController?.navigationItem else {return}
        tabBarController?.navigationItem.title = "Home"
        //menu Button
         let menuButton = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(butttonTapped))
         menuButton.tintColor = UIColor(named: "gray-dark")
         navItem.leftBarButtonItem = menuButton
         
         //notifyButton
         let notifyButton = UIBarButtonItem(image: notifyImage, style: .plain, target: self, action: #selector(notifyTapped))
         notifyButton.tintColor = UIColor(named: "gray-dark")
         navItem.rightBarButtonItem = notifyButton
    }
}


//MARK: - Database Related

extension HomeViewController{
    
    private func loadCurrentCard(){
        do {
            try fetchedResultsController!.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        if fetchedResultsController!.fetchedObjects != nil {
           let creditCards = fetchedResultsController!.fetchedObjects!.map({$0 as! CreditCard})
            if let card = creditCards.filter({$0.active}).first{
                currentCard = card
                loading = false
            }
            
        }
        
    }
}

//MARK: - NSFetchedResultsControllerDelegate

extension HomeViewController: NSFetchedResultsControllerDelegate{
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            loadCurrentCard()
            initCardView()
        case .delete:
            print("delete happen Home View Controller")
        case .move:
            print("move happen Home View Controller")
        case .update:
            isAdded.toggle()
           loadCurrentCard()
            if !isAdded {initCardView()}
        default:
            tableview.reloadData()
        }
    }
}

//MARK: - TableView DataSource and Delegate

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if transactions.isEmpty{
            return 1
        }
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentCard != nil {
            if loading{
                let cell = tableview.dequeueReusableCell(withIdentifier: loadingReuseIdentifier, for: indexPath) as! LoadingTableViewCell
                return cell
            }else{
                let cell = tableview.dequeueReusableCell(withIdentifier: emptyReuseIdentifier, for: indexPath) as! EmptyTableViewCell
                return cell
            }
           
        }
        let cell = tableview.dequeueReusableCell(withIdentifier: transactionReuseIdentifier, for: indexPath) as! TransactionCell
        return cell
    }
    
    
}

extension UIStackView {
    
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
    
}
