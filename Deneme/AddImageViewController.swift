
import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import ObjectiveC

class AddImageViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate  {
    
    let userID = Auth.auth().currentUser!.uid
    @IBOutlet weak var imageViewProfile: UIImageView!
    let firestoreDatabase = Firestore.firestore()
    let sharedPref = UserDefaults.standard
    override func loadView() {
       
        Firestore.firestore().collection("Post").document("\(Auth.auth().currentUser!.uid)").collection("profileId").getDocuments { (querySnapshot, err) in
            if querySnapshot!.documents.count > 0 {
                self.performSegue(withIdentifier: "toFeedVC", sender: nil)
            }
        }
        
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewProfile?.layer.cornerRadius = (imageViewProfile?.frame.size.width ?? 0.0) / 2
        imageViewProfile?.clipsToBounds = true
        imageViewProfile?.layer.borderWidth = 6.0
        imageViewProfile?.layer.borderColor = UIColor.white.cgColor
        
        imageViewProfile.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        imageViewProfile.addGestureRecognizer(gestureRecognizer)
       
    }

    @IBAction func savePicture(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        if let data = imageViewProfile.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child(uuid+".jpg")
            
            imageReference.putData(data) { (storage, error) in
                if error != nil {}
                else {
                    imageReference.downloadURL { (url,error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                          
                            if let imageUrl = imageUrl {
                                        
                                let firestorePost = ["profilePicture": imageUrl,"profileChanges": FieldValue.serverTimestamp()] as [String : Any]
                             
                              
                                //self.firestoreDatabase.collection("Post").document("\(userID)").setData(firestorePost)
                                
                                //self.firestoreDatabase.collection("Post").document("\(userID)")
                                
                                self.firestoreDatabase.collection("Post").document("\(self.userID)").collection("profileId").document("datas").setData(firestorePost)
                                
                             
                                self.performSegue(withIdentifier: "toTabBar", sender: nil)
                                
                                
                                /*
                                self.firestoreDatabase.collection("Post").document("\(userID)").addDocument(data: firestorePost) { error in
                                    if error == nil {
                                        self.performSegue(withIdentifier: "toTabBar", sender: nil)
                                        
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
    
    @objc func gorselSec(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageViewProfile.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        
    }
}
