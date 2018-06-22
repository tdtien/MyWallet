//
//  ViewController.swift
//  FireBaseDemo
//
//  Created by Tran Duy Tien on 5/5/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    

    // MARK: Properties
    @IBOutlet weak var txtfieldEmail: UITextField!
    @IBOutlet weak var txtfieldPassword: UITextField!
    @IBOutlet weak var btnLoginFB: FBSDKLoginButton!

    var isComplete: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnLoginFB.delegate = self
        /*
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.isComplete  = true
                self.performSegue(withIdentifier: "LoginSuccessSegue", sender: self)
            }
        }
        */
    }
    override func viewWillAppear(_ animated: Bool) {
        isComplete = false
        if FBSDKAccessToken.current() != nil {
            FBSDKLoginManager().logOut()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Login button delegate
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let token = FBSDKAccessToken.current() else {
            print("Get token failed!")
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                let alert = UIAlertController(title: "Error!", message: "Something went wrong", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            // User is signed in
            print("Login successful!")
            self.isComplete = true
            self.performSegue(withIdentifier: "LoginFBSuccessSegue", sender: self)
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    // MARK: Actions
    @IBAction func dismissKeyboard(_ sender: Any) {
        txtfieldEmail.resignFirstResponder()
        txtfieldPassword.resignFirstResponder()
    }

    @IBAction func doLogin(_ sender: Any) {
        if ((txtfieldEmail.text?.isEmpty)! || (txtfieldPassword.text?.isEmpty)!) {
            let alert = UIAlertController(title: "Error!", message: "Please enter your email or password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        Auth.auth().signIn(withEmail: txtfieldEmail.text!, password: txtfieldPassword.text!) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            print("Login successful!")
            self.isComplete = true
            self.performSegue(withIdentifier: "LoginSuccessSegue", sender: self)
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "LoginSuccessSegue" || identifier == "LoginFBSuccessSegue" {
            if isComplete {
             return true
            }
            return false
        }
        return true
    }
    @IBAction func unwindtoLoginViewController(segue:UIStoryboardSegue) {
        //Do nothing
    }
}
