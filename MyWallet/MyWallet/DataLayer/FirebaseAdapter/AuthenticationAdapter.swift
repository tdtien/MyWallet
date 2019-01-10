//
//  AuthenticationAdapter.swift
//  MyWallet
//
//  Created by Hoang Tien on 1/3/19.
//  Copyright © 2019 Tran Duy Tien. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class AuthenticationAdapter: NSObject {
    
    static let sharedInstance = AuthenticationAdapter()
    
    private override init() {
        print("Singleton class")
    }
    
    func signIn(withEmail: String!, password: String!, completionHandler: @escaping (AuthDataResult?, Error?) -> ()) {
        Auth.auth().signIn(withEmail: withEmail, password: password) { (user, error) in
            completionHandler(user, error)
        }
    }
    
    func currentUser() -> Firebase.User? {
        return Auth.auth().currentUser;
    }
    
    func isEmailVerified(user: Firebase.User) -> Bool {
        if user.isEmailVerified {
            return true
        }
        return false
    }
    
    func sendEmailVerification(user: Firebase.User, completionHandler: @escaping (Error?) -> ()) {
        user.sendEmailVerification { (error) in
            completionHandler(error)
        }
    }
    
    func signOut() -> Error? {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            return (signOutError)
        }
        return nil
    }
    
    func createUser(withEmail: String, password: String, completionHandler: @escaping (AuthDataResult?, Error?) -> ()) {
        Auth.auth().createUser(withEmail: withEmail, password: password) { (user, error) in
            completionHandler(user, error)
        }
    }
    
    func sendPasswordReset(withEmail: String!, completionHandler: @escaping (Error?) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: withEmail) { (error) in
            completionHandler(error)
        }
    }
    
    //FacebookSDK
    func getFacebookAccessToken() -> (FBSDKAccessToken) {
        return FBSDKAccessToken.current()
    }
    
    func isFBAccessTokenActive() -> Bool {
        return FBSDKAccessToken.currentAccessTokenIsActive()
    }
    
    func getFacebookCredentialWith(accessToken: String) -> (AuthCredential) {
        return FacebookAuthProvider.credential(withAccessToken: accessToken)
    }
    
    func signInWith(credential: AuthCredential, completionHandler: @escaping (AuthDataResult?, Error?) -> ()) {
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            completionHandler(user, error)
        }
    }
}
