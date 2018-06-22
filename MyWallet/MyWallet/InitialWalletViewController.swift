//
//  InitialWalletViewController.swift
//  MyWallet
//
//  Created by Tran Duy Tien on 6/22/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit

class InitialWalletViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var textFieldAmount: UITextField!
    var amount: String?


    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldAmount.delegate = self
        amount = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: textField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        amount?.append(string)
        textField.text = formatCurrency(string: amount!)
        return false
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        amount?.remove(at: (amount?.endIndex)!)
        return true
    }
    func formatCurrency(string: String) -> String {
        var count = 0;
        var res = string
        for (_, char) in string.enumerated() {
            count = count + 1
            if count == 3 {
                let idx = res.index(after: res.index(of: char)!)
                res.insert(",", at: idx)
                count = 0
            }
        }
        return res
    }
    // MARK: Actions
    @IBAction func dismissKeyboard(_ sender: Any) {
        textFieldAmount.resignFirstResponder()
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
