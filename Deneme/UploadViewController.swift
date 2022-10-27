//
//  UploadViewController.swift
//  Deneme
//
//  Created by melih ispir on 9.10.2022.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore


class UploadViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate {
    let userID = Auth.auth().currentUser!.uid
    @IBOutlet weak var yorumTextField: UITextView!
    var placeholderLabel : UILabel!
    var index = 0
    @IBOutlet weak var imageView: UIImageView!
    let firestoreDatabase = Firestore.firestore()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       /*
        self.firestoreDatabase.collection("Post").document("\(self.userID)").collection("OtherThings").getDocuments { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {}
        }
        */
        firestoreDatabase.collection("Post").document("\(userID)").collection("OtherThings").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.index = document.data().count
                    print("\(document.documentID) => \(document.data().count)")
                }
            }
        }
            
            
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        imageView.addGestureRecognizer(gestureRecognizer)
        yorumTextField.delegate = self
        yorumTextField.text = "Placeholder text goes right here..."
        yorumTextField.textColor = UIColor.lightGray
        
        
        
        
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {

        if yorumTextField.textColor == UIColor.lightGray {
            yorumTextField.text = ""
            yorumTextField.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if yorumTextField.text == "" {
            yorumTextField.text = "Placeholder text ..."
            yorumTextField.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func uploadButtonTiklandi(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child(uuid+".jpg")
            
            imageReference.putData(data) { (storage, error) in
                if error != nil {
                    self.hataMesajiGoster(title: "Hata", message: error?.localizedDescription ?? "")
                }
                else {
            
                    imageReference.downloadURL { (url,error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                          
                            if let imageUrl = imageUrl {
                              
                                
                                let firestorePost = ["gorselurl" : imageUrl, "yorum" : self.yorumTextField.text!, "email" :  Auth.auth().currentUser!.email ?? "", "tarih" : FieldValue.serverTimestamp()] as [String : Any]
                                
                                
                                /*
                                self.firestoreDatabase.collection("Post").document("\(self.userID)").collection("OtherThings").document("wholePaths")
                                    .setData(["\(self.index)":firestorePost])
                                */
                                
                                self.firestoreDatabase.collection("Post").document("\(self.userID)").collection("OtherThings").document("wholePaths")
                                    .updateData(["\(self.index)":firestorePost])
                                                
                                
                                /*
                                db.collection("cities").getDocuments() { (querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        for document in querySnapshot!.documents {
                                            print("\(document.documentID) => \(document.data())")
                                        }
                                    }
                                }
                                */

                            }
                        }
                    }
                }
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    func hataMesajiGoster(title: String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func gorselSec(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    
   
}

    
