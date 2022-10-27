//
//  File.swift
//  Deneme
//
//  Created by melih ispir on 11.10.2022.
//

import Foundation
import UIKit

func showErrorMessage (title:String, errorMessage:String, currentViewController : UIViewController) {
    let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: UIAlertController.Style.alert)
    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
    alert.addAction(okButton)
    currentViewController.present(alert, animated: true)
    
}
