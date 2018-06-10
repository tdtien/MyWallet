//
//  Expense.swift
//  MyWallet
//
//  Created by Tien Huynh on 6/10/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit

class Expense: NSObject {
    //MARK: Properties
    var photo: UIImage?
    var category: String
    var transaction: String
    var price: String
    
    init?(photo: UIImage?, category: String, transaction: String, price: String) {
        guard !category.isEmpty else {
            return nil
        }
        self.photo = photo
        self.category = category
        self.transaction = transaction
        self.price = price
    }
}