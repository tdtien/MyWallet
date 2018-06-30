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
    var type: Int
    var price: String
    var note: String
    var date:String
    
    init?(photo: UIImage?, category: String, type: Int, price: String, note:String, date: String) {
        guard !category.isEmpty else {
            return nil
        }
        self.photo = photo
        self.category = category
        self.type = type
        self.price = price
        self.note = note
        self.date = date
    }
}
