//
//  MainViewController.swift
//  MyWallet
//
//  Created by Tran Duy Tien on 6/30/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit
import Parchment
import DropDown
import Firebase

class MainViewController: UIViewController {
    // MARK: Properties
    var type = 1
    let dropdown = DropDown()
    var currentUser:User?
    let databaseAdapter = DatabaseAdapter.sharedInstance
    let authenticationAdapter = AuthenticationAdapter.sharedInstance
    @IBOutlet weak var btnMenu: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = databaseAdapter.getDatabaseReference()
        if let user = authenticationAdapter.currentUser() {
            databaseAdapter.observeWith(userID: user.uid, reference: ref) { (user) in
                self.currentUser = user
                if (self.currentUser?.amount.isEmpty)! {
                    self.performSegue(withIdentifier: "InitialWalletSegue", sender: self)
                } else {
                    self.title = Utilities.formatCurrency(string: (self.currentUser?.amount)!)
                }
            }
        }
        dropdown.anchorView = btnMenu
        dropdown.dataSource = ["Day", "Month", "Year"]

        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.dropdown.hide()
            if item == "Day" {
                self.type = 0
            } else if item == "Month" {
                self.type = 1
            } else {
                self.type = 2
            }
            self.viewWillAppear(true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if self.childViewControllers.count > 0{
            let viewControllers:[UIViewController] = self.childViewControllers
            for viewContoller in viewControllers{
                viewContoller.willMove(toParentViewController: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParentViewController()
            }
        }
        var date = Date()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewControllers:[UIViewController] = []
        var idx = 0
        // Get days in month
        if type == 0 {
            let dateStart = Calendar.current.startOfMonth(date)
            let dateEnd = Calendar.current.endOfMonth(date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let calendar = Calendar.current
            let component2 = calendar.component(.day, from: dateEnd)
            let number = component2
            for i in 1...number {
                if i == 1 {
                    date = dateStart
                } else {
                    date = date.getNextDate()!
                }
                if date.isInSameDay(date: Date()) {
                    idx = i - 1
                }
                let transactionTableViewController = storyboard.instantiateViewController(withIdentifier: "TransactionTableViewController") as? TransactionTableViewController
                transactionTableViewController?.date = date
                transactionTableViewController?.type = type
                transactionTableViewController?.title = dateFormatter.string(from: date)
                viewControllers.append(transactionTableViewController!)
            }
        } else if (type == 1){
            let monthStart = Calendar.current.startOfYear(date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL"
            for i in 1...12 {
                if i == 1 {
                    date = monthStart
                } else {
                    date = date.getNextMonth()!
                }
                if date.isInSameMonth(date: Date()) {
                    idx = i - 1
                }
                let transactionTableViewController = storyboard.instantiateViewController(withIdentifier: "TransactionTableViewController") as? TransactionTableViewController
                transactionTableViewController?.date = date
                transactionTableViewController?.type = type
                transactionTableViewController?.title = dateFormatter.string(from: date)
                viewControllers.append(transactionTableViewController!)
            }
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            date = formatter.date(from: "2000/01/01 20:00")!
            for i in 1...50 {
                if i > 1 {
                    date = date.getNextYear()!
                }
                if date.isInSameYear(date: Date()) {
                    idx = i - 1
                }
                let transactionTableViewController = storyboard.instantiateViewController(withIdentifier: "TransactionTableViewController") as? TransactionTableViewController
                transactionTableViewController?.date = date
                transactionTableViewController?.type = type
                formatter.dateFormat = "yyyy"
                transactionTableViewController?.title = formatter.string(from: date)
                viewControllers.append(transactionTableViewController!)
            }
        }

        // Do any additional setup after loading the view.
        let pagingViewController = FixedPagingViewController(viewControllers: viewControllers)
        addChildViewController(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParentViewController: self)
        pagingViewController.select(index: idx)
    }

    @IBAction func showMenu(_ sender: Any) {
        dropdown.show()
    }
    @IBAction func chartView(_ sender: Any) {
        performSegue(withIdentifier: "ChartViewSegue", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
