//
//  ProductController.swift
//  TradeApp
//
//  Created by Muhammet Umut Taşan on 11.08.2024.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class ProductController {
    
    var firestoreDatabase = Firestore.firestore()
    var firestoreReference : DocumentReference? = nil
    let storageRef = Storage.storage().reference()

    func addProduct(product: Product, completion: @escaping (Bool, Error?) -> Void) {
        let seller = "\(SignedUser.user.userName) \(SignedUser.user.userSurname)"

        let productData: [String: Any] = [
            "productName": product.productName,
            "productDesc": product.productDesc,
            "productSeller": seller,
            "productPrice": product.productPrice,
            "productCategory": product.productCategory,
            "deliverType": product.deliverType,
            "productImageUrl1": product.productImageUrl1,
            "productImageUrl2": product.productImageUrl2,
            "productImageUrl3": product.productImageUrl3,
            "productImageUrl4": product.productImageUrl4
        ]
        
        firestoreDatabase.collection("Products").addDocument(data: productData) { error in
            if let error = error {
                print("Error adding product: \(error.localizedDescription)")
                completion(false, error)
            } else {
                print("Product successfully added to Firebase!")
                completion(true, nil)
            }
        }
    }
    

    func getProductData(completion: @escaping () -> Void) {
        firestoreDatabase.collection("Products")
            .addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    // allProducts dizisini temizle
                    User.allProducts.removeAll()
                    
                    for document in snapshot!.documents {
                        let productWillAddArray = Product()
                        
                        // Document ID'yi al ve ekle
                        productWillAddArray.documentId = document.documentID
                        
                        if let productName = document.get("productName") as? String {
                            productWillAddArray.productName = productName
                        }
                        
                        if let productDescription = document.get("productDesc") as? String {
                            productWillAddArray.productDesc = productDescription
                        }
                        if let deliverType = document.get("deliverType") as? String {
                            productWillAddArray.deliverType = deliverType
                        }
                        if let productCategory = document.get("productCategory") as? String {
                            productWillAddArray.productCategory = productCategory
                        }
                        
                        if let imageUrl1 = document.get("productImageUrl1") as? String {
                            productWillAddArray.productImageUrl1 = imageUrl1
                        }
                        if let imageUrl2 = document.get("productImageUrl2") as? String {
                            productWillAddArray.productImageUrl2 = imageUrl2
                        }
                        if let imageUrl3 = document.get("productImageUrl3") as? String {
                            productWillAddArray.productImageUrl3 = imageUrl3
                        }
                        if let imageUrl4 = document.get("productImageUrl4") as? String {
                            productWillAddArray.productImageUrl4 = imageUrl4
                        }
                        
                        if let price = document.get("productPrice") as? String {
                            productWillAddArray.productPrice = price
                        }
                        
                        if let seller = document.get("productSeller") as? String {
                            productWillAddArray.productSeller = seller
                        }
                        
                        // Yeni ürünü allProducts dizisine ekle
                        User.allProducts.append(productWillAddArray)
                    }
                    
                    // Tamamlandığında completion bloğunu çağır
                    completion()
                }
            }
        }
    }
    
    
    func getProductByDocId(documentId: String, completion: @escaping (Bool) -> Void){
        firestoreDatabase.collection("Products").document(documentId).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let prodcut = Product()
                // Veriyi işleme (örneğin, bir model objesine dönüştürme)
                if let productName = data?["productName"] as? String,
                   let productPrice = data?["productPrice"] as? String,
                   let productDesc = data?["productDesc"] as? String,
                   let productDeliverType = data?["deliverType"] as? String,
                   let productSeller = data?["productSeller"] as? String,
                   let productCategory = data?["productCategory"] as? String,
                   let productImageUrl1 = data?["productImageUrl1"] as? String,
                   let productImageUrl2 = data?["productImageUrl2"] as? String,
                   let productImageUrl3 = data?["productImageUrl3"] as? String,
                   let productImageUrl4 = data?["productImageUrl4"] as? String {
                    
                    prodcut.productName = productName
                    prodcut.productPrice = productPrice
                    prodcut.productDesc = productDesc
                    prodcut.productSeller = productCategory
                    prodcut.productSeller = productSeller
                    prodcut.deliverType = productDeliverType
                    prodcut.documentId = documentId
                    prodcut.productImageUrl1 = productImageUrl1
                    prodcut.productImageUrl2 = productImageUrl2
                    prodcut.productImageUrl3 = productImageUrl3
                    prodcut.productImageUrl4 = productImageUrl4
                    User.userFavoritesProduct.append(prodcut)
                    print("Ürün Adı: \(productName), Ürün Fiyatı: \(productPrice)")
                    completion(true)
                }
            } else {
                print("Belge bulunamadı veya hata oluştu: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                completion(false)
            }
        }
    }
    
    
    func deleteProduct(withId productId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let productRef = firestoreDatabase.collection("Products").document(productId)
        
        let batch = firestoreDatabase.batch()
        
        // Product document is deleted
        batch.deleteDocument(productRef)
        
        // Collections to update
        let collectionsToUpdate = [
            firestoreDatabase.collection("favorites"),
            firestoreDatabase.collection("Orders")
        ]
        
        let group = DispatchGroup()
        
        for collection in collectionsToUpdate {
            group.enter()
            
            collection.getDocuments { (querySnapshot, error) in
                if let error = error {
                    group.leave()
                    completion(.failure(error))
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    group.leave()
                    return
                }
                
                for document in documents {
                    let docRef = document.reference
                    
                    // For "favorites" collection, we update "FavoritesArray"
                    if collection == self.firestoreDatabase.collection("favorites") {
                        if let favoritesArray = document.get("FavoritesArray") as? [String], favoritesArray.contains(productId) {
                            batch.updateData(["FavoritesArray": FieldValue.arrayRemove([productId])], forDocument: docRef)
                        }
                    }
                    
                    // For "Orders" collection, we update "OrdersArray"
                    if collection == self.firestoreDatabase.collection("Orders") {
                        if let ordersArray = document.get("OrdersArray") as? [String], ordersArray.contains(productId) {
                            batch.updateData(["OrdersArray": FieldValue.arrayRemove([productId])], forDocument: docRef)
                        }
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            // Commit the batch operation
            batch.commit { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }


    func addProductPhoto(image: UIImage, completion: @escaping (String?) -> Void) {
        
        let imageRef = storageRef.child("productPhotos/\(UUID().uuidString).jpg")
 
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            
            completion(nil)
            return
        }
        let uploadTask = imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Resim yükleme hatası: \(error.localizedDescription)")
                completion(nil)
                return
            }
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("URL alma hatası: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
               
                completion(url?.absoluteString)
            }
        }
    }
    
    func fetchImage(from docId: String, completion: @escaping (Bool, UIImage?) -> Void) {
           // Firebase URL'yi docId'ye göre oluşturun
           let baseURL = "https://your-firebase-storage-url/"
           let imageURLString = "\(baseURL)\(docId).jpg"
           
           guard let url = URL(string: imageURLString) else {
               completion(false, nil)
               return
           }

           // URL'den veri çekmek için bir veri görevini başlat
           let task = URLSession.shared.dataTask(with: url) { data, response, error in
               if let error = error {
                   print("Resim yükleme hatası: \(error.localizedDescription)")
                   completion(false, nil)
                   return
               }

               guard let data = data, let image = UIImage(data: data) else {
                   completion(false, nil)
                   return
               }

               completion(true, image)
           }

           // Görevi başlat
           task.resume()
       }

    
}
