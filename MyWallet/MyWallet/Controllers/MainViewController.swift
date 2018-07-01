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
    @IBOutlet weak var btnMenu: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference()
        if let user = Auth.auth().currentUser {
            ref.child("users").child(user.uid).observe(.value) { (snapshot) in
                self.currentUser = User(snapshot: snapshot)
                if (self.currentUser?.amount.isEmpty)! {
                    self.performSegue(withIdentifier: "InitialWalletSegue", sender: self)
                } else {
                    self.title = self.formatCurrency(string: (self.currentUser?.amount)!)
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
extension Date {
    func getNextMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)
    }
    func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
    func getNextDate() -> Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
    func getNextYear() -> Date? {
        return Calendar.current.date(byAdding: .year, value: 1, to: self)
    }
    func getPreviousDate() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
    func isInSameWeek(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .weekOfYear)
    }
    func isInSameMonth(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
    func isInSameYear(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .year)
    }
    func isInSameDay(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
    }
}
extension Calendar {
    func startOfMonth(_ date: Date) -> Date {
        return self.date(from: self.dateComponents([.year, .month], from: date))!
    }

    func endOfMonth(_ date: Date) -> Date {
        return self.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(date))!
    }
    func startOfYear(_ date: Date) -> Date {
        return self.date(from: self.dateComponents([.year], from: date))!
    }

    func endOfYear(_ date: Date) -> Date {
        return self.date(from: DateComponents(year: self.component(.year, from: date), month: 12, day: 31))!
    }
}
