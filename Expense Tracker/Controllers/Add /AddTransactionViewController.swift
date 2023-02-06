//
//  AddIncomeViewController.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/22.
//

import UIKit
import CoreData

class AddTransactionViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var transactionTypeBtn: UIButton!
    @IBOutlet weak var transactionTitle: UITextField!
    @IBOutlet weak var transactionAmount: UITextField!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var weekdaysStack: UIStackView!
    @IBOutlet weak var transactionCategoryBtn: UIButton!
    @IBOutlet weak var calendarTitle: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    //instances
    private var weekUI = UIHelper()
    private let databaseHelper = DatabaseHelper()
    private var calendarHelper = CalendarHelper()
    
    //properties
    private let transactionTypes = Constants.categories.transactionTypes
    private let incomeCategories = Constants.categories.incomes
    private let expenseCategories = Constants.categories.expenses
   
    //Optional Variables
    private var selectedTransactionType:String?
    private var selectedTransactionCategory:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    private func initUI(){
        calendarView.layer.cornerRadius = 10
        addBtn.layer.cornerRadius = 10
        weekUI.getWeeklyCalendarUI(weekdaysStack: weekdaysStack)
        UIHelper.setupMenuButton(button: transactionTypeBtn, listOfItems: transactionTypes, buttonAction: transactionTypeDidChange)
        UIHelper.setupMenuButton(button: transactionCategoryBtn, listOfItems: incomeCategories, buttonAction: transactionCategoryDidChange)
        selectedTransactionType = transactionTypes[0]
        selectedTransactionCategory = incomeCategories[0]
    }
    
    private func transactionTypeDidChange(_ title: String){
        if title == "income"{
            
            addBtn.backgroundColor = UIColor(named: "pink-dark")
            addBtn.setTitle("Add Income", for: .normal)
            UIHelper.setupMenuButton(button: transactionCategoryBtn, listOfItems: incomeCategories, buttonAction: transactionCategoryDidChange)
        }else{
            addBtn.backgroundColor = UIColor(named: "orange")
            addBtn.setTitle("Add Expense", for: .normal)
            UIHelper.setupMenuButton(button: transactionCategoryBtn, listOfItems: expenseCategories, buttonAction: transactionCategoryDidChange)
        }
        
        selectedTransactionType = title
    }
    
    private func transactionCategoryDidChange(_ title: String){
        selectedTransactionCategory = title
    }
    
    @IBAction func addIncomeTapped(_ sender: Any) {
        let request:NSFetchRequest<CreditCard> = CreditCard.fetchRequest()
        let creditCards = databaseHelper.fetchAll(with: request, predicate: nil)
        let card = creditCards.filter{$0.active}.first!
        addNewTransaction(card: card)
        databaseHelper.saveContext(message: "Error while add new income")
        navigationController?.popViewController(animated: true)
    }
    
    func addNewTransaction(card: CreditCard){
        let newTransaction = Transaction(context: databaseHelper.context)
        newTransaction.title = transactionTitle.text
        newTransaction.type = selectedTransactionType
        newTransaction.amount = Double(transactionAmount.text!)!
        newTransaction.category = selectedTransactionCategory
        newTransaction.date = Date()
        newTransaction.creditCard = card
        
    }
    
    
    @IBAction func previousTapped(_ sender: Any) {
        weekdaysStack.removeFullyAllArrangedSubviews()
        calendarHelper.previousWeek()
        weekUI.getWeeklyCalendarUI(weekdaysStack: weekdaysStack)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        weekdaysStack.removeFullyAllArrangedSubviews()
        calendarHelper.nextWeek()
        weekUI.getWeeklyCalendarUI(weekdaysStack: weekdaysStack)
    }
    
    
}
