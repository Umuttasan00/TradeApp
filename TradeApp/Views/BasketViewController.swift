//
//  BasketViewController.swift
//  TradeApp
//
//  Created by Muhammet Umut Taşan on 8.08.2024.
//

import UIKit
import SDWebImage

class BasketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        User.userBasketProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basketCellId", for: indexPath) as! BasketViewCell
       
        
        if indexPath.row < User.userBasketProduct.count {
            
            let product = User.userBasketProduct[indexPath.row]
            
            if let url = URL(string: product.productImageUrl1) {
                cell.productImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            }
            
            
            cell.deleteProductOnBasketBtnClcAction = { [weak self] in
                    self?.deleteProductOnBasketBtnClc(indexPath: indexPath)
                }
            
            cell.productNameLbl.text = product.productName
            cell.productPrice.text = product.productPrice
            if product.deliverType == "Hızlı teslimat yok"{
                cell.fastDeliverLbl.isHidden = true
            }else{
                cell.fastDeliverLbl.isHidden = false
            }

         } else {
            cell.productNameLbl.text = "Yükleniyor..."
            cell.productNameLbl.text = "Yükleniyor..."
        }
        
        
        return cell
    }
    
    @IBOutlet weak var totalPriceLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    let productController = ProductController()
    let userController = UserController()
    let orderController = OrderController()
    
    var totalProductPrice :Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.totalPriceLbl.text = String(totalProductPrice)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBasketProducts()
    }

    // Ürünler yüklendikten sonra toplam fiyat hesaplanmalı ve etiket güncellenmeli
    func loadBasketProducts() {
        User.userBasketProduct.removeAll()
        
        let group = DispatchGroup()
        
        for i in 0..<User.userOrderProductsIdsArray.count {
            group.enter()
            self.orderController.getProductOnBasketByDocId(documentId: User.userOrderProductsIdsArray[i]) { success in
                if success {
                    print("userBasketProduct count u: \(User.userBasketProduct.count)")
                    print("Veri yüklendi: \(User.userBasketProduct[0].productName)")
                } else {
                    print("Veri yükleme başarısız.")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.tableView.reloadData()
            self.calculateTheTotalPrice()
            self.totalPriceLbl.text = String(self.totalProductPrice)
        }
    }

    func calculateTheTotalPrice(){
        totalProductPrice = 0 
        for product in User.userBasketProduct {
            addPriceToTotal(priceString: product.productPrice)
        }
        totalPriceLbl.text = "\(totalProductPrice)"
    }

    func deleteProductOnBasketBtnClc(indexPath: IndexPath){
        orderController.removeProductFromBasket(userEmail: SignedUser.user.userEmail, productDocId:User.userBasketProduct[indexPath.row].documentId ) { success in
            if success{
                self.tableView.reloadData()
                self.makeAlert(titleInput: "Başarılı.", messageInput: "Ürün sepetten çıkartıldı.") { sccss in
                    if sccss{
                        self.tableView.reloadData()
                        self.calculateTheTotalPrice()
                        self.totalPriceLbl.text = String(self.totalProductPrice)
                    }else{
                        
                    }
                }
            }else{
                
            }
        }
        
    }
    
    @IBAction func buyBtnClc(_ sender: Any) {
        print(User.userBasketProduct.count)
        print(User.userOrderProductsIdsArray.count)
        self.makeAlert(titleInput: "Bekleyiniz...", messageInput: "Ödeme yapılıyor.") { sccss in
            if sccss{
                if let tabBarController = self.tabBarController {
                    tabBarController.selectedIndex = 0
                    self.orderController.removeBasketProductsAnsProductsIdsArray()
                    for i in 0..<User.userFavoriteProductsIdsArray.count {
                        self.orderController.removeProductFromBasket(userEmail: SignedUser.user.userEmail, productDocId: User.userFavoriteProductsIdsArray[i]) { sccss in
                        if sccss {
                            
                        }else{
                            
                        }
                    }}
            }else{
                }
                self.calculateTheTotalPrice()
                self.totalPriceLbl.text = String(self.totalProductPrice)
            }
        }
    }
    
    func addPriceToTotal(priceString: String) {
        let exchangeRates: [String: Double] = [
            "$": 27.0,
            "€": 30.0,
            "£": 35.0,
            "₺": 1.0
        ]
        
        var cleanPrice = priceString
        for (symbol, _) in exchangeRates {
            cleanPrice = cleanPrice.replacingOccurrences(of: symbol, with: "")
        }
        cleanPrice = cleanPrice.replacingOccurrences(of: " ", with: "")
        
        for (symbol, rate) in exchangeRates {
            if priceString.contains(symbol), let priceValue = Double(cleanPrice) {
                let convertedPrice = priceValue * rate
                totalProductPrice += Int(convertedPrice)
                break
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
