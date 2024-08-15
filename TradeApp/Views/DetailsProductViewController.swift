//
//  DetailsProductViewController.swift
//  TradeApp
//
//  Created by Muhammet Umut Taşan on 14.08.2024.
//

import UIKit
import SDWebImage

class DetailsProductViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    

    @IBOutlet weak var fastDeliverLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productDescLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var productSellerLbl: UILabel!
    @IBOutlet weak var productCategoryLbl: UILabel!
    let userController = UserController()
       let productController = ProductController()
       var selectedProduct: Product?
       var photoUrlArray: [String] = []

       override func viewDidLoad() {
           super.viewDidLoad()
           selectedProduct = CurrentProduct.selectedProduct
           tableView.delegate = self
           tableView.dataSource = self
           
           if let product = selectedProduct {
               
               if product.deliverType == "Hızlı teslimat var" {
                   self.fastDeliverLbl.isHidden = false
               }else if product.deliverType == "Hızlı teslimat yok"{
                   self.fastDeliverLbl.isHidden = true
               }else{
                   print("teslimat lbl hatası")
               }
               
               self.productNameLbl.text = product.productName
               self.productDescLbl.text = product.productDesc
               self.productPriceLbl.text = product.productPrice
               self.productCategoryLbl.text = product.productCategory
               self.productSellerLbl.text = product.productSeller
               photoUrlArray.removeAll()
               // URL'leri diziye ekle
               photoUrlArray = [product.productImageUrl1, product.productImageUrl2, product.productImageUrl3, product.productImageUrl4].compactMap { $0 }
               print("array countu \(photoUrlArray.count)")
               print("salt count \(countNonEmptyStrings(in: photoUrlArray))")
               
               // Veriyi güncelle ve tablonun yeniden yüklenmesini sağla
               print("Seçilen Ürün: \(product.productName)")
               print("Seçilen Ürün: \(product.productPrice)")
               print("Seçilen Ürün: \(product.productDesc)")
               print("Seçilen Ürün: \(product.productImageUrl2)")
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                   self.tableView.reloadData()
               })
               
           }
       }
    
    
    func countNonEmptyStrings(in array: [String]) -> Int {
        let filteredArray = array.filter { !$0.isEmpty }
        return filteredArray.count
    }


       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return countNonEmptyStrings(in: photoUrlArray)
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "produtPhotosCell", for: indexPath) as! ProductPhotosViewCell
           print(photoUrlArray)
           
           let urlString = photoUrlArray[indexPath.row]
           
           if let url = URL(string: urlString) {
               cell.productPhotoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
           } else {
               cell.productPhotoImageView.image = UIImage(named: "placeholder")
           }
           
           return cell
       }
    

   

}
