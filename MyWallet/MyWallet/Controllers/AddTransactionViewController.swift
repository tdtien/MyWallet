//
//  AddTransactionViewController.swift
//  MyWallet
//
//  Created by Tien Huynh on 6/17/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit
import os.log

class AddTransactionViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    var myCategory:Category? = nil
    var amount:String?
    var strDate:String?
    let datePicker = UIDatePicker()
    var myTransaction:Transaction? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtCategory.delegate = self
        txtPrice.delegate = self
        txtDate.delegate = self
        txtNote.delegate = self
        txtPrice.addTarget(self, action: #selector(textFieldChanged), for: UIControlEvents.editingChanged)
        txtDate.addTarget(self, action: #selector(createDatePicker), for: UIControlEvents.touchDown)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if (myTransaction != nil)
        {
            title = "Edit Transaction"
            txtPrice.text = formatCurrency(string: (myTransaction?.price)!)
            imgCategory.image = myTransaction?.photo
            txtCategory.text = myTransaction?.category
            txtNote.text = myTransaction?.note
            txtDate.text = myTransaction?.date
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
            performSegue(withIdentifier: "ChooseCategorySegue", sender: self)
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.setDate(Date(), animated: false)
        datePicker.backgroundColor = UIColor.white
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
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy")
        let dateString = dateFormatter.string(from: datePicker.date)
        txtDate.text = dateString
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
        return str
    }
    
    



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: .default, type: .debug)
            return
        }
        let price = txtPrice.text?.replacingOccurrences(of: ",", with: "") ?? ""
        let category = txtCategory.text ?? ""
        let photo = imgCategory.image
        let type = myCategory?.type ?? 0
        let date = txtDate.text ?? ""
        let note = txtNote.text ?? ""
        myTransaction = Transaction(photo: photo, category: category, type: type, price: price, note: note, date: date)
    }

    

}
