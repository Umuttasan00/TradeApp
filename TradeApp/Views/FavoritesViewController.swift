//
//  FavoritesViewController.swift
//  TradeApp
//
//  Created by Muhammet Umut Taşan on 8.08.2024.
//

import UIKit
import SDWebImage

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    
    let productController = ProductController()
    let userController = UserController()
    let orderController = OrderController()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
         super.viewDidLoad()
         tableView.delegate = self
         tableView.dataSource = self
        print(User.userFavoriteProductsIdsArray.count)
        print(User.userFavoritesProduct.count)
        
     }
     
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         loadFavoriteProducts()
     }

     func loadFavoriteProducts() {
         // Önce favori ürünler listesini temizliyoruz
         User.userFavoritesProduct.removeAll()
         
         let group = DispatchGroup()
         
         for i in 0..<User.userFavoriteProductsIdsArray.count {
             group.enter()
             self.productController.getProductByDocId(documentId: User.userFavoriteProductsIdsArray[i]) { success in
                 if success {
                     print("Veri yüklendi: \(User.userFavoritesProduct.last?.productName ?? "Bilinmeyen Ürün")")
                 } else {
                     print("Veri yükleme başarısız.")
                 }
                 group.leave()
             }
         }
         
         group.notify(queue: .main) {
             self.tableView.reloadData()
         }
     }


    

 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        User.userFavoriteProductsIdsArray.count
            
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! ShowFavoritesProductViewCell
        
        if indexPath.row < User.userFavoritesProduct.count {
            let product = User.userFavoritesProduct[indexPath.row]
            
            if let url = URL(string: product.productImageUrl1) {
                cell.favoriteProductImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            }
            
            cell.favoriteProductNameLbl.text = product.productName
            cell.favoriteProductDescLbl.text = product.productDesc
            cell.favoriteProductPriecLbl.text = product.productPrice
            
            cell.addBasketButtonAction = { [weak self] in
                self?.addBasketBtnClc(indexPath: indexPath, docId: product.documentId)
            }
        } else {
            // Veri mevcut değilse "Yükleniyor..." mesajları göster
            cell.favoriteProductNameLbl.text = "Yükleniyor..."
            cell.favoriteProductDescLbl.text = "Yükleniyor..."
            cell.favoriteProductPriecLbl.text = "Yükleniyor..."
        }
        
        return cell
    }

    func addBasketBtnClc(indexPath: IndexPath, docId : String){
        orderController.addBasketOnFirebase(userEmail: SignedUser.user.userEmail, productDocId: docId) { success in
            if success{
                self.makeAlert(titleInput: "Sepete eklendi", messageInput: "Sepete gidip siprarişinizi tamamlayabilirsiniz.") { success in
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                alert.dismiss(animated: true, completion: {
                    completion(true)
                })
            }
        }
    }


}
