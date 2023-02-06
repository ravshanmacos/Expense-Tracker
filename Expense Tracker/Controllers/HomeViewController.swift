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
    
    //Constants
    private let transactionCell = Constants.Xibs.TableViewCells.transactionCell
    private let loadingCell = Constants.Xibs.StateCells.loadingCell
    private let emptyCell = Constants.Xibs.StateCells.emptyCell
    private let menuImage = Constants.Images.menuIcon
    private let notifyImage = Constants.Images.notificationIcon
    private let transactionReuseIdentifier = Constants.CellIdentifiers.transactionCell
    private let loadingReuseIdentifier = Constants.CellIdentifiers.loadingCell
    private let emptyReuseIdentifier = Constants.CellIdentifiers.emptyCell
    
    //Variables
    private var activeCard:CreditCard?
    private var transactions:[Transaction] = []
    
    //Instances
    private var databaseHelper = DatabaseHelper()
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    
    //MARK: - Overriding
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController = databaseHelper.setObserver(entityName: "CreditCard")
        fetchedResultsController!.delegate = self
        initTableview()
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
    
    //init TableView
    private func initTableview(){
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 70
        tableview.register(UINib(nibName: transactionCell, bundle: nil), forCellReuseIdentifier: transactionReuseIdentifier)
        tableview.register(UINib(nibName: loadingCell, bundle: nil), forCellReuseIdentifier: loadingReuseIdentifier)
        tableview.register(UINib(nibName: emptyCell, bundle: nil), forCellReuseIdentifier: emptyReuseIdentifier)
    }
    
    //Init Empty CardView or Card view according data state
    private func initCardView(){
         cardViewStack.removeFullyAllArrangedSubviews()
            cardViewStack.layer.cornerRadius = 10
            cardViewStack.backgroundColor = UIColor(named: "blue-light")
            emptyCardView.navigation = navigationController
        
        if let activeCard{
            cardView.setHolderName(with: activeCard.fullname!)
            cardView.setLogoImage(with: activeCard.type!)
            cardView.setBalance(with: activeCard.balance)
            cardView.setCardBckImage(with: activeCard.bckImage)
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
        guard let creditCards = databaseHelper.performFetch(with: fetchedResultsController!) else {return}
        if let activeCard = databaseHelper.getCurrentCard(with: creditCards), let transactions = databaseHelper.getTransactions(with: activeCard){
            self.activeCard = activeCard
            self.transactions = transactions
        }
        tableview.reloadData()
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
           loadCurrentCard()
           initCardView()
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
        if transactions.isEmpty {
            if databaseHelper.loading{
                let cell = tableview.dequeueReusableCell(withIdentifier: loadingReuseIdentifier, for: indexPath) as! LoadingTableViewCell
                return cell
            }else{
                let cell = tableview.dequeueReusableCell(withIdentifier: emptyReuseIdentifier, for: indexPath) as! EmptyTableViewCell
                return cell
            }
           
        }
        let cell = tableview.dequeueReusableCell(withIdentifier: transactionReuseIdentifier, for: indexPath) as! TransactionCell
        cell.setTitle(with: transactions[indexPath.row].title!)
        cell.setTime(with: transactions[indexPath.row].date!)
        cell.setAmount(with: transactions[indexPath.row].amount, type: transactions[indexPath.row].type!)
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
