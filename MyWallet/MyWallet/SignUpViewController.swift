//
//  SignUpViewController.swift
//  FireBaseDemo
//
//  Created by Tran Duy Tien on 5/5/18.
//  Copyright © 2018 Tran Duy Tien. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var txtfieldEmail: UITextField!
    @IBOutlet weak var txtfieldPassword: UITextField!
    @IBOutlet weak var txtfieldConfirmPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func doRegister(_ sender: Any) {
        if ((txtfieldPassword.text?.isEmpty)! || (txtfieldConfirmPassword.text?.isEmpty)! || (txtfieldEmail.text?.isEmpty)!) {
            let alert = UIAlertController(title: "Error!", message: "Please enter your information", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (txtfieldConfirmPassword.text != txtfieldPassword.text) {
            let alert = UIAlertController(title: "Error!", message: "Incorrect confirm password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: txtfieldEmail.text!, password: txtfieldPassword.text!) { (user, error) in
                if (error != nil) {
                    let alert = UIAlertController(title: "Error!", message: "Email has already used", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    Auth.auth().signIn(withEmail: self.txtfieldEmail.text!, password: self.txtfieldPassword.text!, completion: { (user, error) in
                        if (error != nil) {
                            let alert = UIAlertController(title: "Error!", message: "Something went wrong", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                    Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                            let alert = UIAlertController(title: "Error!", message: "Cannot send verification email", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Sucessful", message: "Please check your inbox to complete registeration", preferredStyle: UIAlertControllerStyle.actionSheet)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
    }
    @IBAction func doBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
