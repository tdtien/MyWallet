//
//  InitialWalletViewController.swift
//  MyWallet
//
//  Created by Tran Duy Tien on 6/22/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit
import Firebase

class InitialWalletViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var textFieldAmount: UITextField!
    var amount: String?


    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldAmount.delegate = self
        textFieldAmount.addTarget(self, action: #selector(textFieldChanged), for: UIControlEvents.editingChanged)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Actions
    @IBAction func dismissKeyboard(_ sender: Any) {
        textFieldAmount.resignFirstResponder()
    }
    @IBAction func saveAmount(_ sender: Any) {
        let ref = Database.database().reference()
        if let user = Auth.auth().currentUser {
            let childUpdate = ["/users/\(user.uid)/amount": amount]
            ref.updateChildValues(childUpdate)
            dismiss(animated: true, completion: nil)
        }
    }
    // MARK: Text field delegate
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
