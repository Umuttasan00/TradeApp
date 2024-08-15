//
//  ProfileViewController.swift
//  TradeApp
//
//  Created by Muhammet Umut Taşan on 8.08.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let authController = AuthController()
    
    @IBOutlet weak var userProfilePhoto: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userSurnameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userPhoneNumberLbl: UILabel!
    @IBOutlet weak var userAddressLbl: UILabel!
    @IBOutlet weak var userGenderLbl: UILabel!
    
    var userGender : String = ""

    override func viewDidLoad() {
        
        print(SignedUser.user.userGender)
        super.viewDidLoad()
        if SignedUser.user.userGender == "Erkek"{
            userGender = "Erkek"
            userProfilePhoto.image = UIImage(named: "manProfilePhoto")
        }else{
            userGender = "Kadın"
            userProfilePhoto.image = UIImage(named: "womanProfilePhoto")
        }
        userNameLbl.text=SignedUser.user.userName
        userSurnameLbl.text=SignedUser.user.userSurname
        userEmailLbl.text=SignedUser.user.userEmail
        userPhoneNumberLbl.text=SignedUser.user.userPhoneNumber
        userAddressLbl.text=SignedUser.user.userAddress
        userGenderLbl.text=userGender
    }
    
    @IBAction func logOutBtnClc(_ sender: Any) {
        self.makeAlert(titleInput: "Çıkış yapılıyor ...", messageInput: "Bekleyiniz.") { sccss in
            if sccss {
                self.authController.userLogOut()
                CustomAlert().responseAlert(alert: Alert(title: "Çıkış yapııyor", desc: "Bekleyiniz", btnTitle: "Tamam", btnHandler: {
                    self.performSegue(withIdentifier: "logOutGoLogInPage", sender: nil)
                }()))
            }else{
                
            }
        }
        
        authController.userLogOut()
        CustomAlert().responseAlert(alert: Alert(title: "Çıkış yapııyor", desc: "Bekleyiniz", btnTitle: "Tamam", btnHandler: {
            self.performSegue(withIdentifier: "logOutGoLogInPage", sender: nil)
        }()))
       
    }
    func makeAlert(titleInput: String, messageInput: String, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        self.present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                alert.dismiss(animated: true, completion: {
                    completion(true)
                })
            }
        }
    }
    
    

}
