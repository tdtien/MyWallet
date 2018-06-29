//
//  AddExpenseViewController.swift
//  MyWallet
//
//  Created by Tien Huynh on 6/17/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit

class AddExpenseViewController: UIViewController{
    
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    
    var myCategory:Category? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (myCategory != nil)
        {
            txtCategory.text = myCategory?.nameCategory
            imgCategory.image = myCategory?.photo
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancelPressed(_ sender: UIBarButtonItem) {
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
