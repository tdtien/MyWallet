//
//  CategoryViewController.swift
//  MyWallet
//
//  Created by Tien Huynh on 6/21/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    var segment = 0;
    
    @IBAction func segmentTapped(_ sender: Any) {
        segment = 1;
    }
    
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
