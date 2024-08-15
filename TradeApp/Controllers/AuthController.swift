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

    
    
    func userSignUp(userEmail : String , userPassword : String) -> Bool {
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("hesap olusturuldu")
            }
        }
        
        return true
    }
    
    func sendPasswordResetLinkToUserEmail (Email : String){
        
    }

    
}
