//
//  MyAdversViewController.swift
//  TradeApp
//
//  Created by Muhammet Umut Taşan on 14.08.2024.
//

import UIKit
import SDWebImage

class MyAdversViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        User.myProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myAdversCell", for: indexPath) as! MyAdversCell
        
        var product = User.myProducts[indexPath.row]
        
        if let url = URL(string: product.productImageUrl1) {
            cell.productImageImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
        
        cell.dropAdversButtonAction = { [weak self] in
            self?.dropAdversBtnClc(indexPath: indexPath, docId: product.documentId)
        }
        
        cell.productDescLbl.text = product.productDesc
        cell.productNameLbl.text = product.productName
        cell.productPriceLbl.text = product.productPrice
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    let userController = UserController()
    let productController = ProductController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        userController.getUsersProduct { success in
            if success{
                
            }else{
                
            }
            self.tableView.reloadData()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userController.getUsersProduct { success in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
            }
        }
    }

    
    func dropAdversBtnClc(indexPath: IndexPath, docId : String){
        productController.deleteProduct(withId: User.myProducts[indexPath.row].documentId) { result in
                        switch result {
                        case .success():
                            // Silme başarılı, ürünü yerel diziden de kaldır ve tabloyu güncelle
                            User.myProducts.remove(at: indexPath.row)
                            DispatchQueue.main.async {
                                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                            }
                            
                        case .failure(let error):
                            // Silme işlemi sırasında hata oluştu
                            print("Ürün silinirken hata oluştu: \(error.localizedDescription)")
                            
                            // Hata mesajı göstermek isterseniz:
                            let alert = UIAlertController(title: "Hata", message: "Ürün silinirken bir hata oluştu.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
                            self.present(alert, animated: true)
                        }
                    }
                }
    
}
