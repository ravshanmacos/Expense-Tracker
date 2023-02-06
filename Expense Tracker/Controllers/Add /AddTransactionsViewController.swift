//
//  AddItemViewController.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/20.
//

import UIKit
import CoreData

class AddTransactionsViewController: UIViewController {
    //outlets
    @IBOutlet weak var tableview: UITableView!
    //constants
    private let reuseIdentifier = Constants.CellIdentifiers.transactionCell
    private let transactionCell = Constants.Xibs.TableViewCells.transactionCell
    //variables
    private var databaseHelper = DatabaseHelper()
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    private var transactions:[Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController = databaseHelper.setObserver(entityName: "CreditCard")
        fetchedResultsController!.delegate = self
        initTableview()
        loadCreditCards()
    }
    
    private func initTableview(){
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 70
        tableview.register(UINib(nibName: transactionCell, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "Add"
        tabBarController?.navigationItem.rightBarButtonItem = .none
    }
    
    func loadCreditCards(){
        guard let creditCards = databaseHelper.performFetch(with: fetchedResultsController!) else {return}
        if let activeCard = databaseHelper.getCurrentCard(with: creditCards), let transactions = databaseHelper.getTransactions(with: activeCard){
            self.transactions = transactions
        }
        tableview.reloadData()
    }

}

//MARK: - NSFetchedResultsControllerDelegate

extension AddTransactionsViewController: NSFetchedResultsControllerDelegate{
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            print("insert happen AddITemView Controller")
        case .delete:
            print("delete happen AddITemView Controller")
        case .move:
            print("move happen AddITemView Controller")
        case .update:
           loadCreditCards()
        default:
            print("default happen AddITemView Controller")
        }
       
    }
    
}

//MARK: - UITableViewDelegate and UITableViewDataSource

extension AddTransactionsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TransactionCell
        cell.setTitle(with: transactions[indexPath.row].title!)
        cell.setTime(with: transactions[indexPath.row].date!)
        cell.setAmount(with: transactions[indexPath.row].amount, type: transactions[indexPath.row].type!)
        return cell
    }
    
    
}

