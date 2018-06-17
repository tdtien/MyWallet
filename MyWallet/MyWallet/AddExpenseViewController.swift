//
//  AddExpenseViewController.swift
//  MyWallet
//
//  Created by Tien Huynh on 6/17/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit

class AddExpenseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func addDoneButton(to controll: UITextField)
    {
        let doneToolBar = UIToolbar()
        doneToolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: controll, action: nil), UIBarButtonItem(title: "Done", style: .done, target: controll, action: #selector(UITextField.resignFirstResponder))]
        doneToolBar.sizeToFit()
        controll.inputAccessoryView = doneToolBar
    }
    
    let cellList = ["PriceTableViewCellID", "CategoryTableViewCellID", "NoteTableViewCellID", "CalendarTableViewCellID"]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell0 = tableView.dequeueReusableCell(withIdentifier: cellList[indexPath.row], for: indexPath) as! PriceTableViewCell
            //Cho` xu ly sua thong tin
            //...
            addDoneButton(to: cell0.txtPrice)
            return cell0
        case 1:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: cellList[indexPath.row], for: indexPath) as! CategoryTableViewCell
            //Cho` xu ly sua thong tin
            //...
            
            return cell1
        case 2:
            let cell2 = tableView.dequeueReusableCell(withIdentifier: cellList[indexPath.row], for: indexPath) as! NoteTableViewCell
            //Cho` xu ly sua thong tin
            //...
           
            return cell2
        default:
            let cell3 = tableView.dequeueReusableCell(withIdentifier: cellList[indexPath.row], for: indexPath) as! CalendarTableViewCell
            //Cho` xu ly sua thong tin
            //...
           
            return cell3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 94
        } else
        {
            return 79
        }
    }
    
    @IBOutlet weak var tblDetailExpense: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func btnCancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
