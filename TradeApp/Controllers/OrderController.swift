//
//  OrderController.swift
//  TradeApp
//
//  Created by Muhammet Umut Taşan on 13.08.2024.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseFirestore
class OrderController {
    
    var firebaseDatabase = Firestore.firestore()
    var firestoreReference : DocumentReference? = nil
    
    func addBasketOnFirebase(userEmail : String ,productDocId : String, completion: @escaping (Bool) -> Void) {
        
        let userDocRef = firebaseDatabase.collection("Orders").document(userEmail)
        
        userDocRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                completion(false)  // Hata oluştu, işlem başarısız
            } else {
                var OrdersArray: [String] = []
                
                // Mevcut verileri kontrol et
                if let document = document, document.exists {
                    if let existingFavorites = document.get("OrdersArray") as? [String] {
                        OrdersArray = existingFavorites
                    }
                }
                
                if !OrdersArray.contains(productDocId) {
                    OrdersArray.append(productDocId)
                    User.userOrderProductsIdsArray.append(productDocId)
                }
                
                let data: [String: Any] = [
                    "OrdersArray": OrdersArray
                ]
                
                userDocRef.setData(data) { error in
                    if let error = error {
                        print("Error updating document: \(error.localizedDescription)")
                        completion(false)  // Güncelleme başarısız
                    } else {
                        print("Document successfully updated!")
                        completion(true)  // Güncelleme başarılı
                    }
                }
            }
        }
    }
    
    
    func getBasketProductsIds(userEmail: String, completion: @escaping (Bool) -> Void) {
        let userDocRef = firebaseDatabase.collection("Orders").document(userEmail)
        let productsCollectionRef = firebaseDatabase.collection("Products")
        
        userDocRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                completion(false)
            } else {
                User.userOrderProductsIdsArray.removeAll()
                if let document = document, document.exists {
                    if let orderArray = document.get("OrdersArray") as? [String] {
                        let dispatchGroup = DispatchGroup()

                        for orderId in orderArray {
                            dispatchGroup.enter()
                            productsCollectionRef.document(orderId).getDocument { (productDocument, error) in
                                if let productDocument = productDocument, productDocument.exists {
                                    User.userOrderProductsIdsArray.append(orderId)
                                }
                                dispatchGroup.leave()
                            }
                        }

                        dispatchGroup.notify(queue: .main) {
                            completion(true)
                        }
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }
    }

    func getProductOnBasketByDocId(documentId: String, completion: @escaping (Bool) -> Void){
        firebaseDatabase.collection("Products").document(documentId).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let basketProduct = Product()
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
                   let productImageUrl4 = data?["productImageUrl4"] as? String  {
                    
                    basketProduct.productName = productName
                    basketProduct.productPrice = productPrice
                    basketProduct.productDesc = productDesc
                    basketProduct.productSeller = productCategory
                    basketProduct.productSeller = productSeller
                    basketProduct.deliverType = productDeliverType
                    basketProduct.documentId = documentId
                    basketProduct.productImageUrl1 = productImageUrl1
                    basketProduct.productImageUrl2 = productImageUrl2
                    basketProduct.productImageUrl3 = productImageUrl3
                    basketProduct.productImageUrl4 = productImageUrl4
                    User.userBasketProduct.append(basketProduct)
                    print("Ürün Adı: \(productName), Ürün Fiyatı: \(productPrice)")
                    completion(true)
                }
            } else {
                print("Belge bulunamadı veya hata oluştu: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                completion(false)
            }
        }
    }
    
    func removeProductFromBasket(userEmail: String, productDocId: String, completion: @escaping (Bool) -> Void) {
        let userDocRef = firebaseDatabase.collection("Orders").document(userEmail)
        
        userDocRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
            } else {
                var ordersArray: [String] = []
                
                if let document = document, document.exists {
                    if let existingOrders = document.get("OrdersArray") as? [String] {
                        ordersArray = existingOrders
                    }
                }
                
                if let index = ordersArray.firstIndex(of: productDocId) {
                    ordersArray.remove(at: index)
                    
                    let data: [String: Any] = [
                        "OrdersArray": ordersArray
                    ]
                    
                    userDocRef.setData(data) { error in
                        if let error = error {
                            print("Error updating document: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            if let productIndex = User.userBasketProduct.firstIndex(where: { $0.documentId == productDocId }) {
                                User.userBasketProduct.remove(at: productIndex)
                                User.userOrderProductsIdsArray.remove(at: productIndex)
                            }
                            
                            print("Document successfully updated!")
                            completion(true)
                        }
                    }
                } else {
                    print("Ürün OrdersArray içinde bulunamadı.")
                    completion(false)
                }
            }
        }
    }
    
    func removeBasketProductsAnsProductsIdsArray(){
        User.userBasketProduct.removeAll()
        User.userOrderProductsIdsArray.removeAll()
    }

    
}
