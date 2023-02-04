//
//  AddExpenseViewController.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/22.
//

import UIKit
import CoreData

class AddExpenseViewController: UIViewController {
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var weekdaysStack: UIStackView!
    @IBOutlet weak var expenseTitle: UITextField!
    @IBOutlet weak var expenseAmount: UITextField!
    @IBOutlet weak var ExpenseCatergory: UIButton!
    
    var weekUI = UIHelper()
    let databaseHelper = DatabaseHelper()
    var selectedExpense:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.layer.cornerRadius = 10
        weekUI.getWeeklyCalendarUI(weekdaysStack: weekdaysStack)
        UIHelper.setupMenuButton(button: ExpenseCatergory, listOfItems: ["Shopping", "Food", "Payment"], buttonAction: expenseCategoryDidChanged)
    }
    
    private func expenseCategoryDidChanged(_ title: String){
        selectedExpense = title
    }
    
    @IBAction func addIncomeTapped(_ sender: Any) {
        let request:NSFetchRequest<CreditCard> = CreditCard.fetchRequest()
        let creditCards = databaseHelper.fetchAll(with: request)
        let card = creditCards.filter{$0.active}.first!
        let newExpense = Expense(context: databaseHelper.context)
        newExpense.title = expenseTitle.text
        newExpense.amount = Double(expenseAmount.text!)!
        newExpense.category = selectedExpense
        newExpense.date = Date()
        newExpense.creditCard = card
        addNewTransaction(card: card)
        databaseHelper.saveContext(message: "Error while add new expense")
        navigationController?.popViewController(animated: true)
    }
    
    func addNewTransaction(card: CreditCard){
        let newTransaction = Transaction(context: databaseHelper.context)
        newTransaction.title = expenseTitle.text
        newTransaction.type = "expense"
        newTransaction.amount = Double(expenseAmount.text!)!
        newTransaction.category = selectedExpense
        newTransaction.date = Date()
        newTransaction.creditCard = card
        
    }
    
}
