//
//  AddIncomeViewController.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/22.
//

import UIKit
import CoreData

class AddIncomeViewController: UIViewController {
    
    @IBOutlet weak var incomeTitle: UITextField!
    @IBOutlet weak var incomeAmount: UITextField!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var weekdaysStack: UIStackView!
    @IBOutlet weak var incomeCategory: UIButton!
    @IBOutlet weak var calendarTitle: UILabel!
    let databaseHelper = DatabaseHelper()
    var calendarHelper = CalendarHelper()
    var weekUI = UIHelper()
    private var selectedIncome:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.layer.cornerRadius = 10
        weekUI.getWeeklyCalendarUI(weekdaysStack: weekdaysStack)
        UIHelper.setupMenuButton(button: incomeCategory, listOfItems: ["Shopping", "Food", "Payment"], buttonAction: incomeCategoryDidChanged)
        
    }
    
    private func incomeCategoryDidChanged(_ title: String){
        selectedIncome = title
    }
    
    @IBAction func addIncomeTapped(_ sender: Any) {
        let request:NSFetchRequest<CreditCard> = CreditCard.fetchRequest()
        let creditCards = databaseHelper.fetchAll(with: request)
        let card = creditCards.filter{$0.active}.first!
        let newIncome = Income(context: databaseHelper.context)
        newIncome.title = incomeTitle.text
        newIncome.amount = Double(incomeAmount.text!)!
        newIncome.category = selectedIncome
        newIncome.date = Date()
        newIncome.creditCard = card
        addNewTransaction(card: card)
        databaseHelper.saveContext(message: "Error while add new income")
        navigationController?.popViewController(animated: true)
    }
    
    func addNewTransaction(card: CreditCard){
        let newTransaction = Transaction(context: databaseHelper.context)
        newTransaction.title = incomeTitle.text
        newTransaction.type = "income"
        newTransaction.amount = Double(incomeAmount.text!)!
        newTransaction.category = selectedIncome
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
