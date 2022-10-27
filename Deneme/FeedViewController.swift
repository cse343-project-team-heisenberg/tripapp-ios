
import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage
import Kingfisher
class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var emailDizisi = [String]()
    var yorumDizisi = [String]()
    var gorselDizisi = [String]()
    
    @IBOutlet weak var tableViewFeed: UITableView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    
        firebaseVerileriAl()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.feedTextView.text = yorumDizisi[indexPath.row]
        cell.feedText.text = emailDizisi[indexPath.row]
        let url = URL(string: gorselDizisi[indexPath.row])
        
        cell.feedImage.sd_setImage(with: URL(string: gorselDizisi[indexPath.row]), placeholderImage: nil) { (image: UIImage?, error: Error?, cacheType:SDImageCacheType!, imageURL: URL?) in

             //new size
            cell.feedImage.image = self.resizeImage(image: image!, newWidth:240)
        
        
        }

        
       //cell.feedImage.sd_setImage(with: URL(string: gorselDizisi[indexPath.row]))
        return cell
    }
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {

        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailDizisi.count
    }
    
    func firebaseVerileriAl() {
        let firesotreDatabase = Firestore.firestore()
        
        firesotreDatabase.collection("Post").addSnapshotListener { (snapshot,error) in
            if error != nil {
            
                print(error?.localizedDescription)
                
            } else {
               if snapshot?.isEmpty != true && snapshot != nil {

                   for document in snapshot!.documents {
                       
                       if let gorselUrl = document.get("gorselurl") as? String {
                           self.gorselDizisi.append(gorselUrl)
                           print(gorselUrl)
                           
                       }
                       if let yorum = document.get("yorum") as? String {
                           self.yorumDizisi.append(yorum)
                           
                       }
                       
                       if let email = document.get("email") as? String {
                           self.emailDizisi.append(email)
                           
                       }
                       
                   }
                   self.tableView.reloadData()
                    
                    
                }
            }
        }
        
    }
    

}
func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {

    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
    }
