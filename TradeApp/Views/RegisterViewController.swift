//
//  ViewController.swift
//  TradeApp
//
//  Created by Muhammet Umut Taşan on 8.08.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtFeild: UITextField!
    @IBOutlet weak var GirisYapBtn: UIButton!
    
    var authController = AuthController()
    var userController = UserController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func GirisYapBtnClc(_ sender: Any) {
        if emailTxtField.text != nil && emailTxtField.text != "" && passwordTxtFeild.text != nil && passwordTxtFeild.text != ""{
            let userEmail = emailTxtField.text
            let userPassword = passwordTxtFeild.text
            //7
            
            
            authController.userLogin(userEmail: userEmail!, userPassword: userPassword!) { success in
                if success {
                    print("regsiter VC giriş yapıldı")
                    //
                    self.userController.getUserInformation(Email: userEmail!) { Success in
                        if Success {
                            self.performSegue(withIdentifier: "goToMainVcFromRegister", sender: nil)
                        }else {
                        }
                    }
                } else {
                    CustomAlert().responseAlert(alert: Alert(title: "Başarısız", desc: "Giriş başarısız.", btnTitle: "Tamam", btnHandler: {
                            print("test")
                    }()))
                }
            }
        } else {
            CustomAlert().responseAlert(alert: Alert(title: "Başarısız", desc: "Tüm boşlukları doldurun.", btnTitle: "Tamam", btnHandler: {
                    print("test")
            }()))
        }
        
        
       
        
        
        
    }
    
    
    

}

