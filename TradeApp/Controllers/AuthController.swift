//
//  AuthController.swift
//  TradeApp
//
//  Created by Muhammet Umut Taşan on 8.08.2024.
//

import Foundation
import Firebase
import FirebaseAuth


class AuthController {
    var response : Bool = false
    var firebaseDatabase = Firestore.firestore()
    var firestoreReference : DocumentReference? = nil
    
    func userLogin(userEmail: String, userPassword: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { authResult, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false) // Hata durumunda false döndür
            } else {
                print("Controller başarılı")
                completion(true)  // Başarılı giriş durumunda true döndür
            }
        }
    }

    
    
    func userSignUp(userEmail: String, userPassword: String, completion: @escaping (Bool, String?) -> Void) {
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            } else {
                print("Hesap oluşturuldu")
                completion(true, nil) 
            }
        }
    }
    
    func addUserInformation(
        userName: String,
        userSurname: String,
        userEmail: String,
        userProfilePhotoUrl: String,
        userPhoneNumber: String,
        userAddress: String,
        userGender: String,
        completion: @escaping (Bool) -> Void
    ) {
        let firestoreReference = firebaseDatabase.collection("UserInformations").document(userEmail)
        
        firestoreReference.getDocument { (document, error) in
            if let document = document, document.exists {
                // Belge zaten mevcut, bu yüzden veri ekleme işlemi yapılmaz
                print("Bu e-posta ile zaten bir kullanıcı mevcut.")
                completion(false)
            } else {
               
                
                let firebaseData = [
                    "userName": userName,
                    "userSurname": userSurname,
                    "userEmail": userEmail,
                    "ProfilePhotoUrl": userProfilePhotoUrl,
                    "userPhoneNumber": userPhoneNumber,
                    "userAddress": userAddress,
                    "Gender": userGender
                ] as [String: Any]
                
                firestoreReference.setData(firebaseData, merge: false) { error in
                    if let error = error {
                        print("Error writing document: \(error.localizedDescription)")
                        completion(false) // Hata durumunda completion false döndürür
                    } else {
                        print("Veri eklendi")
                        completion(true) // Başarılı olursa completion true döndürür
                    }
                }
            }
        }
    }

    

    
    func userLogOut() {
        do {
            try Auth.auth().signOut()
            print("Çıkış yapıldı")
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }

   


    
    func sendPasswordResetLinkToUserEmail (Email : String , completion: @escaping (Bool) -> Void){
        Auth.auth().sendPasswordReset(withEmail: Email) { (error ) in
            if let error = error{
                
                completion(false)
            } else {
                
                completion(true)
            }
            
            
        }
    }
    
    

    
}

