//
//  SettingsViewController.swift
//  Deneme
//
//  Created by melih ispir on 9.10.2022.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

   
    @IBOutlet weak var textMail: UILabel!
    
    @IBOutlet weak var textName: UILabel!
    
    @IBOutlet weak var textSurname: UILabel!
    
    
    @IBOutlet weak var countOfPost: UILabel!
    
    let standart = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        textMail.text = standart.string(forKey: "mail")
        textName.text = standart.string(forKey: "name")
        textSurname.text = standart.string(forKey: "surname")
        countOfPost.text = "0"
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cikisYapTiklandi(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        } catch{
            print("Hata")
        }
    }
}

