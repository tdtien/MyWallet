//
//  ExpenseTableViewController.swift
//  MyWallet
//
//  Created by Tien Huynh on 6/10/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class TransactionTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //@IBOutlet weak var tblView: UITableView!
    var transactions = [Transaction]()
    var transactionsDate = [Transaction]()
    var transactionChoosen:Transaction?
    var user:User?
    var isBtnAddPressed:Bool = false
    var date:Date?
    var type:Int?
    //Adapter
    let databaseAdapter = DatabaseAdapter.sharedInstance
    let authenticationAdapter = AuthenticationAdapter.sharedInstance
    let transactionAdapter = TransactionAdapter.sharedInstance
    //Business
    let transactionBusiness = TransactionBusiness.sharedInstance
    
    
    // MARK: Properties
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblTienVao: UILabel!
    @IBOutlet weak var lblTienRa: UILabel!
    @IBOutlet weak var lblTongTien: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        /*tblView.estimatedRowHeight = 104
        tblView.rowHeight = UITableViewAutomaticDimension*/
        // Load data

        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        if  !(userID?.isEmpty)! {
            self.databaseAdapter.observeWith(userID: userID!, reference: ref) { (user) in
                self.user = user
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        transactions.removeAll()
        if let savedTransactions = transactionBusiness.loadAllTransactionsFromDevice() {
            transactions += savedTransactions
        }
        filterByDate()
        updateGeneral()
        tblView.reloadData()
    }
    
    // MARKS: Private methods
    private func filterByDate() {
        transactionsDate.removeAll()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        for item in transactions {
            let dateItem = dateFormatter.date(from: item.date)
            var flag = false
            if type == 0 {
                flag = (dateItem?.isInSameDay(date: date!))!
            }
            if type == 1 {
                flag = (dateItem?.isInSameMonth(date: date!))!
            }
            if type == 2 {
                flag = (dateItem?.isInSameYear(date: date!))!
            }
            if flag {
                transactionsDate.append(item)
            }
        }
    }
    
    private func updateGeneral() {
        var tienVao = 0
        var tienRa = 0
        for item in transactionsDate {
            if item.type == 0 {
                tienRa += Int(item.price) ?? 0
            } else {
                tienVao += Int(item.price) ?? 0
            }
        }
        let tongTien = tienVao - tienRa
        lblTienVao.text = Utilities.formatCurrency(string: "\(tienVao)")
        lblTienRa.text = Utilities.formatCurrency(string: "\(tienRa)")
        if tongTien >= 0 {
            lblTongTien.text = Utilities.formatCurrency(string: "\(abs(tongTien))")
        } else {
            lblTongTien.text = "-\(Utilities.formatCurrency(string: "\(abs(tongTien))"))"
        }
    }
    
    // MARK: Actions
    @IBAction func unwindtoTransactionTableViewController(segue:UIStoryboardSegue) {
        if let sourceViewController = segue.source as? AddTransactionViewController, let transaction = sourceViewController.myTransaction {
            if let selectedIndexPath = tblView.indexPathForSelectedRow {
                //Update existing transaction
                var currentAmount = Int((user?.amount)!)!
                if transactionsDate[selectedIndexPath.row].type == 0 {
                    currentAmount = currentAmount + Int(transactionsDate[selectedIndexPath.row].price)!
                } else {
                    currentAmount = currentAmount - Int(transactionsDate[selectedIndexPath.row].price)!
                }
                transactions[transactions.index(of: transactionsDate[selectedIndexPath.row])!] = transaction
                if transaction.type == 0 {
                    currentAmount = currentAmount - Int(transaction.price)!
                } else {
                    currentAmount = currentAmount + Int(transaction.price)!
                }
                let ref = databaseAdapter.getDatabaseReference()
                if let curUser = authenticationAdapter.currentUser() {
                    databaseAdapter.updateChildValues(user: curUser, amount: String(currentAmount), reference: ref)
                }
                self.transactionBusiness.deleteAllTransactions()
                for item in transactions {
                    self.transactionBusiness.saveTransaction(transaction: item)
                }
                viewWillAppear(true)
            } else {
                //Add a new transaction
                //let newIndexPath = IndexPath(row: transactions.count, section: 0)
                var currentAmount = Int((user?.amount)!)!
                if transaction.type == 0 {
                    currentAmount = currentAmount - Int(transaction.price)!
                } else {
                    currentAmount = currentAmount + Int(transaction.price)!
                }
                let ref = databaseAdapter.getDatabaseReference()
                if let curUser = authenticationAdapter.currentUser() {
                    databaseAdapter.updateChildValues(user: curUser, amount: String(currentAmount), reference: ref)
                }
                self.transactionBusiness.saveTransaction(transaction: transaction)
                transactions.append(transaction)
                //tblView.insertRows(at: [newIndexPath], with: .automatic)
                viewWillAppear(true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnAddPressed(_ sender: UIButton) {
        isBtnAddPressed = true
        performSegue(withIdentifier: "ShowOrAddTransaction", sender: self)
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsDate.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as? TransactionTableViewCell else {
            fatalError("The dequeued cell is not an instance of TransactionTableViewCell.")
        }
        
        let transaction = transactionsDate[indexPath.row]
        
        cell.categoryImage.image = transaction.photo
        cell.categoryNameLbl.text = transaction.category
        cell.transactionNameLbl.text = transaction.note
        if transaction.type == 0 {
            cell.priceLbl.text = "-\(Utilities.formatCurrency(string: transaction.price))"
            cell.priceLbl.textColor = UIColor.red
        } else {
            cell.priceLbl.text = "+\(Utilities.formatCurrency(string: transaction.price))"
            cell.priceLbl.textColor = UIColor.blue
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = transactionsDate[indexPath.row]
        transactionChoosen = transaction
        isBtnAddPressed = false
        performSegue(withIdentifier: "ShowOrAddTransaction", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }
    
    //function support editting table view
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var currentAmount = Int((user?.amount)!)!
            if transactionsDate[indexPath.row].type == 0 {
                currentAmount = currentAmount + Int(transactionsDate[indexPath.row].price)!
            } else {
                currentAmount = currentAmount - Int(transactionsDate[indexPath.row].price)!
            }
            let ref = Database.database().reference()
            if let curUser = Auth.auth().currentUser {
                let childUpdate = ["/users/\(curUser.uid)/amount": String(currentAmount)]
                ref.updateChildValues(childUpdate)
            }
            let index = transactions.index(of: transactionsDate[indexPath.row])!
            transactions.remove(at: index)
            self.transactionBusiness.deleteTransaction(idx: index)
            viewWillAppear(true)
        }
    }
    /*
    //function support rearranging the table view
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = transactions.remove(at: sourceIndexPath.row)
        transactions.insert(todo, at: destinationIndexPath.row)
        //Update in db
    }
     */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigation = segue.destination as! UINavigationController
        let addTransactionViewController = navigation.topViewController as! AddTransactionViewController
        if (isBtnAddPressed) {
            addTransactionViewController.myTransaction = nil
        } else {
            addTransactionViewController.myTransaction = transactionChoosen
            addTransactionViewController.myCategory = Category(photo: transactionChoosen?.photo, nameCategory: (transactionChoosen?.category)!, type: (transactionChoosen?.type)!)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
