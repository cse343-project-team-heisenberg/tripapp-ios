//
//  RegisterViewController.swift
//  Deneme
//
//  Created by melih ispir on 11.10.2022.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerMailTextField: UITextField!
    
    @IBOutlet weak var registerPasswordTextField: UITextField!
    
    @IBOutlet weak var registerPasswordAgainTextField: UITextField!
    
    @IBOutlet weak var registerNameTextField: UITextField!
    
    @IBOutlet weak var registerSurnameTextField: UITextField!
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func setOnClick(_ sender: Any) {
        if registerMailTextField.text?.isEmpty != true {
            if registerPasswordTextField.text?.isEmpty == false && registerPasswordAgainTextField.text?.isEmpty == false {
                if registerPasswordTextField.text == registerPasswordAgainTextField.text {
                    
                    Firebase.Auth.auth().createUser(withEmail: registerMailTextField.text!, password: registerPasswordTextField.text!) { authDataResult, error in
                        if error != nil {
                            self.sendError(title: "Error", error: error?.localizedDescription ?? "")
                        } else {
                            
                        
                            self.sendVerificationMail()
                            self.defaults.set(self.registerMailTextField.text, forKey: "mail")
                            self.defaults.set(self.registerPasswordTextField.text, forKey: "password")
                            self.defaults.set(self.registerNameTextField.text, forKey: "name")
                            self.defaults.set(self.registerSurnameTextField.text, forKey: "surname")
                            
                            
                        }
                        
                    }
                    
                } else {
                    
                }
                
                
            } else {
                
                
            }
            
        } else {
            showErrorMessage(title: "Error", errorMessage: "Your E-mail is empty", currentViewController:self)
            
        }
        
        
    }
    private var authUser : User? {
        return Auth.auth().currentUser
    }

    public func sendVerificationMail() {
        if self.authUser != nil && !self.authUser!.isEmailVerified {
            self.authUser!.sendEmailVerification(completion: { (error) in
                if error == nil {
                    self.sendError(title: "Info", error: "Your verification mail has been sent")
                    
                } else {
                    self.sendError(title:"Error", error: error?.localizedDescription ?? "" )
                }
            })
        }
        else {

        }
    }
    
    func sendError(title:String, error:String){
        showErrorMessage(title: title, errorMessage: error, currentViewController: self)
        
    }
    
    
    

    
}
