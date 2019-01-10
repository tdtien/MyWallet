//
//  User.swift
//  MyWallet
//
//  Created by Tran Duy Tien on 6/28/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit
import Firebase

class User: NSObject {
    var ref: DatabaseReference?
    var email:String
    var amount:String
    var key: String

    init(email: String, amount: String, key: String = "") {
        self.ref = nil
        self.key = key
        self.email = email
        self.amount = amount
    }

    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let email = value["email"] as? String,
            let amount = value["amount"] as? String else {
                return nil
        }
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.email = email
        self.amount = amount
    }

    func toAnyObject() -> Any {
        return [
            "email": email,
            "amount": amount
        ]
    }
}
