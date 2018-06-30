//
//  AddExpenseViewController.swift
//  MyWallet
//
//  Created by Tien Huynh on 6/17/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit

class AddExpenseViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    
    var myCategory:Category? = nil
    var amount:String?
    var strDate:String?
    let datePicker = UIDatePicker()
    var myExpense:Expense? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtCategory.delegate = self
        txtPrice.delegate = self
        txtDate.delegate = self
        txtPrice.addTarget(self, action: #selector(textFieldChanged), for: UIControlEvents.editingChanged)
        txtDate.addTarget(self, action: #selector(createDatePicker), for: UIControlEvents.touchDown)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if (myExpense != nil)
        {
            txtPrice.text = myExpense?.price
            imgCategory.image = myExpense?.photo
            txtCategory.text = myExpense?.transaction
            txtNote.text = myExpense?.note
            txtDate.text = myExpense?.date
        }
        if (myCategory != nil)
        {
            txtCategory.text = myCategory?.nameCategory
            imgCategory.image = myCategory?.photo
        }
        txtPrice.becomeFirstResponder()
    }
    // MARK: Text field delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField === txtCategory {
            txtCategory.resignFirstResponder()
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let categoryViewController = mainStoryboard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
            self.navigationController?.pushViewController(categoryViewController, animated: true)
        }
        return true
    }
    @objc func textFieldChanged(textField: UITextField) {
        amount = textField.text?.replacingOccurrences(of: ",", with: "")
        var str = amount
        var count = 0
        for (index, _) in (str?.enumerated().reversed())!  {
            count = count + 1
            if count == 4 {
                let idx = str?.index((str?.startIndex)!, offsetBy: index + 1)
                str?.insert(",", at: idx!)
                count = 1
            }
        }
        textField.text = str
    }
    
    
    
    @objc func createDatePicker()
    {
        datePicker.datePickerMode = .date
        txtDate.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //add done button
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        txtDate.inputAccessoryView = toolbar
    }
    
    @objc func donePressed()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        txtDate.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: Actions
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
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
