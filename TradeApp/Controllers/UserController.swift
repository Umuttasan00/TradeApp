//
//  UserController.swift
//  TradeApp
//
//  Created by Muhammet Umut Taşan on 8.08.2024.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class UserController{
    
    var firebaseDatabase = Firestore.firestore()
    var firestoreReference : DocumentReference? = nil

    func getUserInformation(Email: String, completion: @escaping (Bool) -> Void) {
        firestoreReference = firebaseDatabase.collection("UserInformations").document(Email)
            .addSnapshotListener { (documentSnapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false) 
                    return
                }
                
                if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                    
                    let data = documentSnapshot.data()
                    //var user:User = nil
                    
                    SignedUser.user.userEmail = data?["userEmail"] as? String ?? "user not found"
                    SignedUser.user.userName = data?["userName"] as? String ?? "user name not found"
                    SignedUser.user.userSurname = data?["userSurname"] as? String ?? "user surname not found"
                    SignedUser.user.userGender = data?["Gender"] as? String ?? "hata"
                    SignedUser.user.userPhoneNumber = data?["userPhoneNumber"] as? String ?? "404"
                    SignedUser.user.userAddress = data?["userAddress"] as? String ?? "hata"
                    SignedUser.user.userProfilePhotoUrl = data?["ProfilePhotoUrl"] as? String ?? "hata"
                    
                    
                    //SignedUser.user = user
                    completion(true)
                } else {
                    print("Document does not exist")
                    completion(false)
                }
            } as? DocumentReference
    }

    
    
    func updateUserInformation (userEmail: String, userName: String, userSurname: String,userPhoneNumber:String, userAddress: String,userProfilePhotoUrl:String , userIsMale: Bool){
        var gender : String
        if userIsMale{
            gender = "Erkek"
        }else {
            gender = "Kadın"
        }
        firestoreReference = firebaseDatabase.collection("UserInformations").document(userEmail)
        let firebaseData = ["userName" : userName,"userSurname" : userSurname ,"userEmail" : userEmail,"ProfilePhotoUrl" : userProfilePhotoUrl ,"userPhoneNumber" : userPhoneNumber ,"userAddress": userAddress,"Gender" : gender] as [String : Any]
            
        firestoreReference?.setData(firebaseData, merge: false) { error in
                if let error = error {
                    print("Error writing document: \(error.localizedDescription)")
                } else {
                    print("veri eklendi")
                }
            }
    }
    
    func addFavoriteProduct(userEmail: String, productDocId: String, completion: @escaping (Bool) -> Void) {
        let userDocRef = firebaseDatabase.collection("favorites").document(userEmail)
        
        userDocRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                completion(false)  // Hata oluştu, işlem başarısız
            } else {
                var favoritesArray: [String] = []
                
                // Mevcut verileri kontrol et
                if let document = document, document.exists {
                    if let existingFavorites = document.get("FavoritesArray") as? [String] {
                        favoritesArray = existingFavorites
                    }
                }
                
                // Yeni ürün ID'sini ekle
                if !favoritesArray.contains(productDocId) {
                    favoritesArray.append(productDocId)
                }
                
                // Güncellenmiş veriyi kaydet
                let data: [String: Any] = [
                    "FavoritesArray": favoritesArray
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

    
   
    
    
    func getFavoriteProductsIds(userEmail: String, completion: @escaping (Bool) -> Void) {
        let userDocRef = firebaseDatabase.collection("favorites").document(userEmail)
        
        userDocRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                completion(false)
            } else {
                User.userFavoriteProductsIdsArray.removeAll()
                if let document = document, document.exists {
                    if let favoritesArray = document.get("FavoritesArray") as? [String] {
                        User.userFavoriteProductsIdsArray = favoritesArray
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
    func dropFavoriteProductId(userEmail: String, productId: String, completion: @escaping (Bool) -> Void) {
        let userDocRef = firebaseDatabase.collection("favorites").document(userEmail)

        // 1. Array'den ID'yi sil
        User.userFavoriteProductsIdsArray.removeAll { $0 == productId }
        
        // 2. Veritabanından ID'yi sil
        userDocRef.updateData([
            "FavoritesArray": User.userFavoriteProductsIdsArray
        ]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    
    func getUsersProduct(completion: @escaping (Bool) -> Void){
        let seller = "\(SignedUser.user.userName) \(SignedUser.user.userSurname)"
        User.myProducts.removeAll()
        for i in 0..<User.allProducts.count{
            if seller == User.allProducts[i].productSeller{
                User.myProducts.append(User.allProducts[i])
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
}
    

