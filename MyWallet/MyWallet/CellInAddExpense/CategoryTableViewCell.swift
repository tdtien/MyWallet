//
//  CategoryTableViewCell.swift
//  MyWallet
//
//  Created by Tien Huynh on 6/17/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var txtCategory: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
