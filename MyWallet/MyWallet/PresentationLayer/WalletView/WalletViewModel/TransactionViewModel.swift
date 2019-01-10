//
//  TransactionViewModel.swift
//  MyWallet
//
//  Created by Hoang Tien on 1/10/19.
//  Copyright © 2019 Tran Duy Tien. All rights reserved.
//

import UIKit

class TransactionViewModel: NSObject {
    var photo: UIImage?
    var category: String
    var price: String
    var note: String
    var textColor: UIColor
    
    init?(transaction: Transaction?) {
        if (transaction == nil) {
            return nil
        }
        self.photo = transaction!.photo
        self.category = transaction!.category
        self.note = transaction!.note
        if transaction!.type == 0 {
            self.price = "-\(Utilities.formatCurrency(string: transaction!.price))"
            self.textColor = UIColor.red
        } else {
            self.price = "+\(Utilities.formatCurrency(string: transaction!.price))"
            self.textColor = UIColor.blue
        }
    }
}
