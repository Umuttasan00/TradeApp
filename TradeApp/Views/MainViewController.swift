
/// TODO:
///    - Siparis geçmişi
///    - Details Screen
///    - Foto getirme (  TAMAM   )
///    - Ürün silme 

import UIKit
import SDWebImage

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var wellcomeUserTxtLbl: UILabel!
    
 
    let productController = ProductController()
    let userController = UserController()
    let orderController = OrderController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print()
        wellcomeUserTxtLbl.text = "Hoşgeldin  \(SignedUser.user.userName)!"
        productController.getProductData(completion: {
            print("basarılı aferin")
            for _ in User.allProducts {
                self.userController.getFavoriteProductsIds(userEmail: SignedUser.user.userEmail) { success in
                    if success{
                        
                    }else{
                        
                    }
                }
                self.tableView.reloadData()
               }
        })
        self.orderController.getBasketProductsIds(userEmail: SignedUser.user.userEmail) { success in
            if success{
            }else{
            }
            self.userController.getUsersProduct { success in
                if success{
                    
                }else{
                    
                }
         
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
   
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        User.allProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShowProductCell
        if let url = URL(string: User.allProducts[indexPath.row].productImageUrl1) {
                cell.productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            }
        
        if User.userFavoriteProductsIdsArray.contains(User.allProducts[indexPath.row].documentId) {
            cell.favoriteBtn.tintColor = UIColor.red
        } else {
            cell.favoriteBtn.tintColor = UIColor.systemBlue
        }
        
        cell.productDescLbl.text = User.allProducts[indexPath.row].productDesc
        cell.productNameLbl.text = User.allProducts[indexPath.row].productName
        cell.productPriceLbl.text = User.allProducts[indexPath.row].productPrice
        cell.favoriteButtonAction = { [weak self] in
                self?.favoriteBtnClc(indexPath: indexPath)
            }
        cell.reviewButtonAction = { [weak self] in
            self?.reviewBtnClc(indexPath: indexPath)
        }
        let product = User.allProducts[indexPath.row]
        cell.addBasketButtonAction = { [weak self] in
            
            self?.addBasketBtnClc(indexPath: indexPath, docId : product.documentId)
            }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetailsVc" {
            if let destinationVC = segue.destination as? DetailsProductViewController {
                if let indexPath = sender as? IndexPath {
                    destinationVC.selectedProduct = User.allProducts[indexPath.row]
                }
            }
        }
    }



    
    func reviewBtnClc(indexPath: IndexPath) {
        print("segue start")
        //self.performSegue(withIdentifier: "goDetailsVc", sender: indexPath)
        CurrentProduct.selectedProduct = User.allProducts[indexPath.row]
        
        print("segue finish")
    }

    func favoriteBtnClc(indexPath: IndexPath) {
        if User.userFavoriteProductsIdsArray.contains(User.allProducts[indexPath.row].documentId) {
            userController.dropFavoriteProductId(userEmail: SignedUser.user.userEmail, productId: User.allProducts[indexPath.row].documentId) { sccs in
                if sccs {
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            
        } else {
            userController.addFavoriteProduct(userEmail: SignedUser.user.userEmail, productDocId: User.allProducts[indexPath.row].documentId) { success in
                if success {
                    self.userController.getFavoriteProductsIds(userEmail: SignedUser.user.userEmail) { success in
                        if success {
                            DispatchQueue.main.async {
                                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                            }
                        }
                    }
                }
            }
        }
    }

    
    
    func addBasketBtnClc(indexPath: IndexPath, docId : String){
        orderController.addBasketOnFirebase(userEmail: SignedUser.user.userEmail, productDocId: docId) { success in
            if success{
                self.makeAlert(titleInput: "Sepete eklendi", messageInput: "Sepete gidip sipraisinizi tamamlayabilirsiniz") { success in
                    if success{
                        
                    }else{
                        
                    }
                }
            }else{
                
            }
        }
    }
    func makeAlert(titleInput: String, messageInput: String, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        self.present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                alert.dismiss(animated: true, completion: {
                    completion(true)
                })
            }
        }
    }

}
