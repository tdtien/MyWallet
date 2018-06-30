//
//  Expense.swift
//  MyWallet
//
//  Created by Tien Huynh on 6/10/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit

class Transaction: NSObject {
    //MARK: Properties
    var photo: UIImage?
    var category: String
    var nameTransaction: String
    var price: String
    var note: String
    var date:String
    
    init?(photo: UIImage?, category: String, nameTransaction: String, price: String, note:String, date: String) {
        guard !category.isEmpty else {
            return nil
        }
        self.photo = photo
        self.category = category
        self.nameTransaction = nameTransaction
        self.price = price
        self.note = note
        self.date = date
    }
}
