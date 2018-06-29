//
//  Category.swift
//  MyWallet
//
//  Created by Tien Huynh on 6/28/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit

class Category: NSObject {
    var photo: UIImage?
    var nameCategory: String
    
    init?(photo: UIImage?, nameCategory: String) {
        guard !nameCategory.isEmpty else {
            return nil
        }
        self.photo = photo
        self.nameCategory = nameCategory
    }
}
