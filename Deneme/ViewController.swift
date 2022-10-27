//
//  ViewController.swift
//  Deneme
//
//  Created by melih ispir on 8.10.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func girisYapTiklandı(_ sender: Any) {
        defaults.set(false, forKey: "isAddedProfilePicture")
        if textField.text != "" && passwordField.text != "" {
            Auth.auth().signIn(withEmail: textField.text!, password: passwordField.text!) { authdataresult, error in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? " ")
                
                } else {
                    if Auth.auth().currentUser?.isEmailVerified == true {
                        Firestore.firestore().collection("Post").document("\(Auth.auth().currentUser!.uid)").collection("profileId").getDocuments { (querySnapshot, err) in
                            if querySnapshot!.documents.count > 0 {
                                self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                            }else {
                                self.performSegue(withIdentifier: "toProfileVC", sender: nil)
                            }
                        }
                    }
                }
            }
            
        } else {
            self.hataMesaji(titleInput: "Hata", messageInput: "E mail ve şifre giriniz")
        }
        
        
    }
    
    @IBAction func kayitOlTiklandi(_ sender: Any) {
        self.performSegue(withIdentifier: "toRegisterVC", sender: nil)
        /*
        if textField.text != "" && passwordField.text != "" {
            // Kayıt olma işlemi
            Auth.auth().createUser(withEmail: textField.text!, password: passwordField.text!) { authdataresult, error in
                if error != nil {
                    self.hataMesaji(titleInput: "Error", messageInput: error?.localizedDescription ?? " ")
                    
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else {
            hataMesaji(titleInput: "Hata", messageInput: "Kullanıcı Adı ve Şifre Giriniz!")
        }
         */
    }
    func hataMesaji(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
}

