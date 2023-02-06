//
//  OverviewViewController.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/01/20.
//

import UIKit
import Charts
import CoreData

class OverviewViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var blueBox: UIView!
    @IBOutlet weak var orangeBox: UIView!
    @IBOutlet weak var barViewWrapper: UIStackView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    let barChartView = BarChartView()
    let reuseIdentifier = Constants.CellIdentifiers.transactionCell
    let weeks = ["week-1", "week-2", "week-3", "week-4"]
    let chartDataincomes = [2500.00, 1200.00, 1900.00, 2000.00]
    let chartDataexpenses = [1500.00, 900.00, 1100.00, 1100.00]
    
    private var databaseHelper = DatabaseHelper()
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    private var transactions: [Transaction] = []
    private var incomes:[Transaction] = []
    private var expenses:[Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController = databaseHelper.setObserver(entityName: "CreditCard")
        fetchedResultsController!.delegate = self
        barChartView.delegate = self
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "TransactionCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableview.rowHeight = 70
        loadCreditCards()
        initializeBarChart()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        blueBox.layer.cornerRadius = 10
        orangeBox.layer.cornerRadius = 10
         tabBarController?.navigationItem.title = "Overview"
         tabBarController?.navigationItem.rightBarButtonItem = .none
    }
    
    func loadCreditCards(){
        
        do {
            try fetchedResultsController!.performFetch()
        } catch {
            print("Could not fetch \(error)")
        }
        
        if fetchedResultsController!.fetchedObjects != nil {
            let creditCards = fetchedResultsController!.fetchedObjects!.map({$0 as! CreditCard})
            guard let card = creditCards.filter({$0.active}).first else { return }
            transactions = (card.transactions?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: false)]).map({ $0 as! Transaction}))!
            if segmentControl.selectedSegmentIndex == 0{
                incomes = transactions.filter({$0.type == "income"})
            }else{
                expenses = transactions.filter({$0.type == "expense"})
            }
            tableview.reloadData()
        }
        
    }
    
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        loadCreditCards()
    }
    
}



extension OverviewViewController: NSFetchedResultsControllerDelegate{
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

extension OverviewViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segmentControl.selectedSegmentIndex == 0 ? incomes.count : expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        as! TransactionCell
        if segmentControl.selectedSegmentIndex == 0{
            cell.setTitle(with: incomes[0].title!)
            cell.setAmount(with: incomes[0].amount, type: incomes[0].type!)
            return cell
        }
        cell.setTitle(with: expenses[0].title!)
        cell.setAmount(with: expenses[0].amount, type: expenses[0].type!)
        return cell
    }
    
    
}


extension OverviewViewController{
    private func initializeBarChart(){
     
        barViewWrapper.addArrangedSubview(barChartView)
        barChartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 10)
        barChartView.noDataText = "You need to provide data for the chart."
      //  barChartView.chartDescription.text = "sales vs bought "


        //legend
        let legend = barChartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;


        let xaxis = barChartView.xAxis
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.weeks)
        xaxis.granularity = 1


        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1

        let yaxis = barChartView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false

        barChartView.rightAxis.enabled = false
       //axisFormatDelegate = self
         barViewWrapper.addArrangedSubview(barChartView)
        setChart()
      
    }
    
    func setChart() {
            barChartView.noDataText = "You need to provide data for the chart."
            var dataEntries: [BarChartDataEntry] = []
            var dataEntries1: [BarChartDataEntry] = []

            for i in 0..<self.weeks.count {
                
                let dataEntry1 = BarChartDataEntry(x: Double(i) , y: self.self.chartDataincomes[i])
                dataEntries1.append(dataEntry1)

                let dataEntry = BarChartDataEntry(x: Double(i) , y: self.chartDataexpenses[i])
                dataEntries.append(dataEntry)

                //stack barchart
                //let dataEntry = BarChartDataEntry(x: Double(i), yValues:  [self.unitsSold[i],self.unitsBought[i]], label: "groupChart")
            }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "expenses")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "income")

            let dataSets: [BarChartDataSet] = [chartDataSet1,chartDataSet]
            chartDataSet.colors = [
                
                NSUIColor(cgColor: UIColor(named: "orange")!.cgColor),
            ]
        chartDataSet1.colors = [
            NSUIColor(cgColor: UIColor(named: "pink-dark")!.cgColor),
        ]
            //let chartData = BarChartData(dataSet: chartDataSet)

            let chartData = BarChartData(dataSets: dataSets)


            let groupSpace = 0.3
            let barSpace = 0.05
            let barWidth = 0.3
            // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"

            let groupCount = self.weeks.count
            let startYear = 0


            chartData.barWidth = barWidth;
            barChartView.xAxis.axisMinimum = Double(startYear)
            let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
            print("Groupspace: \(gg)")
            barChartView.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)

            chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
            //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
            barChartView.notifyDataSetChanged()

            barChartView.data = chartData
            //chart animation
            barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)


        }
}
