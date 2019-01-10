//
//  DatabaseAdapter.swift
//  MyWallet
//
//  Created by Hoang Tien on 1/10/19.
//  Copyright © 2019 Tran Duy Tien. All rights reserved.
//

import UIKit
import Firebase

class DatabaseAdapter: NSObject {

    static let sharedInstance = DatabaseAdapter()
    
    private override init() {
        print("Singleton class")
    }
    
    func getDatabaseReference() -> DatabaseReference {
        return Database.database().reference()
    }
    
    func registerUserToFirebaseDatabase(user: Firebase.User, reference: DatabaseReference, newUser: User) -> () {
        reference.child("users").child(user.uid).setValue(newUser.toAnyObject())
    }
  
    func updateChildValues(user: Firebase.User, amount: String?, reference: DatabaseReference) -> () {
        let childUpdate = ["/users/\(user.uid)/amount": amount]
        reference.updateChildValues(childUpdate)
    }
    
    func observeWith(userID: String, reference: DatabaseReference, completionHandler: @escaping (User?) -> ()) {
        var user:User?
        reference.child("users").child(userID).observe(.value) { (snapshot) in
            user = User(snapshot: snapshot)
            completionHandler(user)
        }
    }
}
