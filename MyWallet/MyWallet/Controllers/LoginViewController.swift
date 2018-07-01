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
    @IBOutlet weak var activityControl: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnLoginFB.delegate = self

//        Auth.auth().addStateDidChangeListener { (auth, user) in
//            if user != nil {
//                self.performSegue(withIdentifier: "LoginSuccessSegue", sender: self)
//            }
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
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
        activityControl.startAnimating()
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                let alert = UIAlertController(title: "Error!", message: "Something went wrong", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            // User is signed in
            self.activityControl.stopAnimating()
            self.performSegue(withIdentifier: "LoginSuccessSegue", sender: self)
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
        view.endEditing(true)
    }

    @IBAction func doLogin(_ sender: Any) {
        if ((txtfieldEmail.text?.isEmpty)! || (txtfieldPassword.text?.isEmpty)!) {
            let alert = UIAlertController(title: "Error!", message: "Please enter your email or password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        activityControl.startAnimating()
        Auth.auth().signIn(withEmail: txtfieldEmail.text!, password: txtfieldPassword.text!) { (user, error) in
            if let error = error {
                self.activityControl.stopAnimating()
                let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            if let user = Auth.auth().currentUser {
                if !user.isEmailVerified {
                    self.activityControl.stopAnimating()
                    let alert = UIAlertController(title: "Error!", message: "Please verify your email address", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Resend verification email", style: UIAlertActionStyle.default, handler: { (action) in
                        user.sendEmailVerification(completion: { (error) in
                            if let error = error {
                                let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                self.activityControl.stopAnimating()
                                let alert = UIAlertController(title: "Sucessful", message: "Please check your inbox to complete registeration", preferredStyle: UIAlertControllerStyle.actionSheet)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in self.dismiss(animated: true, completion: nil)}))
                                self.txtfieldEmail.resignFirstResponder()
                                self.txtfieldPassword.resignFirstResponder()
                                self.present(alert, animated: true, completion: nil)
                            }
                        })
                    }))
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    do {
                        try Auth.auth().signOut()
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                    print("Sign out successful")
                    return
                }
            }
            self.performSegue(withIdentifier: "LoginSuccessSegue", sender: self)
        }
    }
    @IBAction func unwindtoLoginViewController(segue:UIStoryboardSegue) {
        //Do nothing
    }
}
