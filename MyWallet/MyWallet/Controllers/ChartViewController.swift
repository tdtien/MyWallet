//
//  ChartViewController.swift
//  MyWallet
//
//  Created by Tien Huynh on 6/30/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit
import Charts
import CoreData

class ChartViewController: UIViewController, UITextFieldDelegate {

    //Mark: Property
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var txtDateFrom: UITextField!
    @IBOutlet weak var txtDateTo: UITextField!
    let dateFromPicker = UIDatePicker()
    let dateToPicker = UIDatePicker()
    var dateFrom:Date? = nil    //New
    var dateTo:Date? = nil      //New
    var strDateFrom:String = "30/06/2018"
    var strDateTo: String = "01/07/2018"
    var transactions = [Transaction]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtDateFrom.delegate = self
        txtDateTo.delegate = self
        txtDateFrom.addTarget(self, action: #selector(createDateFromPicker), for: UIControlEvents.touchDown)
        txtDateTo.addTarget(self, action: #selector(createDateToPicker), for: UIControlEvents.touchDown)
        /*let categories = ["Food", "Transportation", "Healthy", "Education", "Salary", "Entertainment", "Other"]
        let values = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 8.0]*/
        
        //set dateFrom and dateTo from two string date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFrom = dateFormatter.date(from: strDateFrom)
        dateTo = dateFormatter.date(from: strDateTo)
        txtDateFrom.text = strDateFrom
        txtDateTo.text = strDateTo
        
        // Load data
        if let savedTransactions = loadTransactions() {
            transactions += savedTransactions
        }
        if transactions.count > 0 {
            setChart(transactions: transactions)
        } else {
            let alert = UIAlertController(title: "Error!", message: "No data", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                if let ownNavigationController = self.navigationController {
                    ownNavigationController.popViewController(animated: true)
                }
            }))
            present(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: Pie Chart
    func setChart(transactions: [Transaction])
    {
        let dataPoints = getValueOfChart(transactions: transactions).0  //default: dataPoints.count = 7
        let values = getValueOfChart(transactions: transactions).1
        var dataEntities: [PieChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry()
            dataEntry.y = values[i]
            dataEntry.label = dataPoints[i]
            dataEntities.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(values: dataEntities, label: "")
        var colors: [UIColor] = []
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        
        pieChartDataSet.colors = colors
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        //Some set up to Pie Chart
        let description = Description()
        description.text = ""
        pieChartView.chartDescription = description
        pieChartView.noDataText = "No data available"
        pieChartView.centerText = "Pie Chart"
    }
    
    //get dataPoints and values from data transaction.date: date from -> date to
    func getValueOfChart(transactions: [Transaction]) -> ([String], [Double])
    {
        var categories = [String]()
        var values = [Double]()
        var tempCategories = [String]()
        var tempValues = [Double]()
        for i in 0..<transactions.count {
            let indexCategory = checkCategoryIsInList(categories: tempCategories, aTransaction: transactions[i])
            if (indexCategory == -1)
            {
                tempCategories.append(transactions[i].category)
                tempValues.append(formatStrMoneyToDouble(strMoney: transactions[i].price))
            }
            else {
                tempValues[indexCategory] += formatStrMoneyToDouble(strMoney: transactions[i].price)
            }
        }
        tempCategories = sortCategories(tempCategories: tempCategories, tempValues: tempValues).0
        tempValues = sortCategories(tempCategories: tempCategories, tempValues: tempValues).1
        if (tempCategories.count <= 7)
        {
            categories = tempCategories
            values = tempValues
        } else
        {
            var sumOther:Double = 0
            for i in 0...5
            {
                categories.append(tempCategories[i])
                values.append(tempValues[i])
            }
            categories.append("Others")
            for i in 6..<tempCategories.count
            {
                sumOther += tempValues[i]
            }
            values.append(sumOther)
        }
        return (categories, values)
    }
    
    //sort categories from biggest to smallest
    func sortCategories(tempCategories: [String], tempValues: [Double]) -> ([String], [Double])
    {
        var categories = tempCategories
        var values = tempValues
        
        for i in 0..<(categories.count - 1)
        {
            for j in (i+1)..<categories.count
            {
                if (values[i] < values[j])
                {
                    let tempStr:String = categories[i]
                    categories[i] = categories[j]
                    categories[j] = tempStr
                    
                    let tempValue:Double = values[i]
                    values[i] = values[j]
                    values[j] = tempValue
                }
            }
        }
        return (categories, values)
    }
   
    //check a category is in the list category
    func checkCategoryIsInList(categories: [String], aTransaction: Transaction) -> Int
    {
        if (categories.count == 0)
        {
            return -1
        }
        for i in 0..<categories.count
        {
            if (aTransaction.category == categories[i])
            {
                return i
            }
        }
        return -1
    }
    
    //format: 250,000đ -> 250000
    func formatStrMoneyToDouble(strMoney: String) ->Double
    {
        var result:String = ""
        for char in strMoney {
            if (char == "0" || char == "1" || char == "2" || char == "3" || char == "4" || char == "5" || char == "6" || char == "7" || char == "8" || char == "9")
            {
                result.append(char)
            }
        }
        return Double(result)!
    }
    
    
    @objc func createDateFromPicker()
    {
        dateFromPicker.datePickerMode = .date
        dateFromPicker.locale = Locale(identifier: "en_GB")
        //dateFromPicker.setDate(Date(), animated: false)
        dateFromPicker.setDate(dateFrom!, animated: false)
        dateFromPicker.backgroundColor = UIColor.white
        txtDateFrom.inputView = dateFromPicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //add done button
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneFromPressed))
        toolbar.setItems([doneButton], animated: true)
        txtDateFrom.inputAccessoryView = toolbar
    }
    
    @objc func doneFromPressed()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy")
        
        //Check validation of dateFrom and dateTo
        dateFrom = dateFromPicker.date
        if (dateFrom! > dateTo!)
        {
            let alertView = UIAlertController(title: "Error", message: "Date From must smaller than Date To", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "OK", style: .destructive) { (action) in print("Error")
            }
            alertView.addAction(yesAction)
            self.present(alertView, animated: true, completion: nil)
        } else {
            let dateString = dateFormatter.string(from: dateFromPicker.date)
            txtDateFrom.text = dateString
            self.view.endEditing(true)
            
            //draw a new pie chart with new dateFrom
            transactions.removeAll()
            if let savedTransactions = loadTransactions() {
                transactions += savedTransactions
            }
            setChart(transactions: transactions)
        }
    }
    
    @objc func createDateToPicker()
    {
        dateToPicker.datePickerMode = .date
        dateToPicker.locale = Locale(identifier: "en_GB")
        //dateToPicker.setDate(Date(), animated: false)
        dateToPicker.setDate(dateTo!, animated: false)
        dateToPicker.backgroundColor = UIColor.white
        txtDateTo.inputView = dateToPicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //add done button
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneToPressed))
        toolbar.setItems([doneButton], animated: true)
        txtDateTo.inputAccessoryView = toolbar
    }
    
    @objc func doneToPressed()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy")
        
        //Check validation of dateFrom and dateTo
        dateTo = dateToPicker.date
        if (dateTo! < dateFrom!)
        {
            let alertView = UIAlertController(title: "Error", message: "Date To must bigger than Date From", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "OK", style: .destructive) { (action) in print("Error")
            }
            alertView.addAction(yesAction)
            self.present(alertView, animated: true, completion: nil)
        }
        else {
            let dateString = dateFormatter.string(from: dateToPicker.date)
            txtDateTo.text = dateString
            self.view.endEditing(true)
            
            //draw a new pie chart with new dateTo
            transactions.removeAll()
            if let savedTransactions = loadTransactions() {
                transactions += savedTransactions
            }
            setChart(transactions: transactions)
        }
    }
    
    //Mark: Load Transaction
    private func loadTransactions() -> [Transaction]? {
        var list = [TransactionEntity]()
        var listTransaction = [Transaction]()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let transactionFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TransactionEntity")
        do {
            list = try context.fetch(transactionFetch) as! [TransactionEntity]
        } catch {
            print("Fetching failed")
        }
        for item in list {
            let date = item.date!
            
            if (dateFrom! <= date && date <= dateTo!)
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                let dateString = formatter.string(from: date)
                let transaction = Transaction(photo: UIImage(data: item.photo!, scale: 1.0), category: item.category!, type: Int(item.type), price: item.price!, note: item.note!, date: dateString)
                listTransaction.append(transaction!)
            }
        }
        return listTransaction
    }
    
    private func deleteAll() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let transactionFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TransactionEntity")
        let deletereq = NSBatchDeleteRequest(fetchRequest: transactionFetch)
        do {
            try context.execute(deletereq)
        } catch {
            print("Failed deleting all")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
