//
//  MainViewController.swift
//  MyWallet
//
//  Created by Tran Duy Tien on 6/30/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit
import Parchment

class MainViewController: UIViewController {
    var type:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        var date = Date()
        type = 1
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
                transactionTableViewController?.title = dateFormatter.string(from: date)
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
