//
//  ExpenseTableViewController.swift
//  MyWallet
//
//  Created by Tien Huynh on 6/10/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit
import Firebase

class TransactionTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //@IBOutlet weak var tblView: UITableView!
    var transactions = [Transaction]()
    var transactionChoosen:Transaction?
    var user:User?
    var isBtnAddPressed:Bool = false
    
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
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observe(DataEventType.value) { (snapshot) in
            self.user = User(snapshot: snapshot)
            if (self.user?.amount.isEmpty)! {
                self.performSegue(withIdentifier: "InitialWalletViewSegue", sender: self)
            } else {
                self.lblTienVao.text = self.formatCurrency(string: (self.user?.amount)!)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if user != nil {
            lblTienVao.text = formatCurrency(string: (self.user?.amount)!)
        }
    }
    // MARKS: Private methods
    private func formatCurrency(string: String) -> String {
        var str = string
        var count = 0
        for (index, _) in str.enumerated().reversed() {
            count = count + 1
            if count == 4 {
                let idx = str.index(str.startIndex, offsetBy: index + 1)
                str.insert(",", at: idx)
                count = 1
            }
        }
        str = str + " ₫"
        return str
    }
    // MARK: Actions
    @IBAction func unwindtoTransactionTableViewController(segue:UIStoryboardSegue) {
        if let sourceViewController = segue.source as? AddTransactionViewController, let transaction = sourceViewController.myTransaction {
            if let selectedIndexPath = tblView.indexPathForSelectedRow {
                //Update existing transaction
                transactions[selectedIndexPath.row] = transaction
                tblView.reloadRows(at: [selectedIndexPath], with: .none)
                //Xu ly coredata o day
            } else {
                //Add a new transaction
                let newIndexPath = IndexPath(row: transactions.count, section: 0)
                //saveTransaction core data

                transactions.append(transaction)
                tblView.insertRows(at: [newIndexPath], with: .automatic)
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
        return transactions.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as? TransactionTableViewCell else {
            fatalError("The dequeued cell is not an instance of TransactionTableViewCell.")
        }
        
        let transaction = transactions[indexPath.row]
        
        cell.categoryImage.image = transaction.photo
        cell.categoryNameLbl.text = transaction.category
        cell.transactionNameLbl.text = transaction.note
        if transaction.type == 0 {
            cell.priceLbl.text = "-\(formatCurrency(string: transaction.price))"
            cell.priceLbl.textColor = UIColor.red
        } else {
            cell.priceLbl.text = "+\(formatCurrency(string: transaction.price))"
            cell.priceLbl.textColor = UIColor.blue
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = transactions[indexPath.row]
        transactionChoosen = transaction
        isBtnAddPressed = false
        performSegue(withIdentifier: "ShowOrAddTransaction", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    //function support editting table view
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            transactions.remove(at: indexPath.row)
            //delete in db
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //function support rearranging the table view
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = transactions.remove(at: sourceIndexPath.row)
        transactions.insert(todo, at: destinationIndexPath.row)
        //Update in db
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row <= transactions.count) {
             return 104
        }
        else {
            return 60
        }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigation = segue.destination as! UINavigationController
        let addTransactionViewController = navigation.topViewController as! AddTransactionViewController
        if (isBtnAddPressed)
        {
            addTransactionViewController.myTransaction = nil
        }
        else
        {
             addTransactionViewController.myTransaction = transactionChoosen
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    private func loadSampleTransaction()
    {
        let photo1 = UIImage(named: "IconAnUong")
        let photo2 = UIImage(named: "IconDiChuyen")
        
        guard let transaction1 = Transaction(photo: photo1, category: "Ăn uống", nameTransaction: "Bún bò", price: "20.000",note: "Delicious", date: "29/06/2018")
            else {
                fatalError("Unable to instantiate expense1")
        }
        
        guard let transaction2 = Transaction(photo: photo2, category: "Di chuyển", nameTransaction: "Đổ xăng", price: "50.000",note: "OK", date: "29/06/2018")
            else {
                fatalError("Unable to instantiate expense2")
        }
        
        transactions+=[transaction1,transaction2]
    }
    */
}
