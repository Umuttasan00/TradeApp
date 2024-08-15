

import UIKit

class UpdatePasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    let authController = AuthController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func linkGonderBtnClc(_ sender: Any) {
        var userEmail = emailTxtField.text
        if userEmail != "" && userEmail != nil {
            authController.sendPasswordResetLinkToUserEmail(Email: userEmail!) { Success in
                if Success{
                    self.makeAlert(titleInput: "Başarılı", messageInput: "Lütfen email hesabınıza gelen link'e tıklayarak şifrenizi yenileyiniz.")
                }else{
                    self.makeAlert(titleInput: "Başarısız", messageInput: "Yeniden deneyiniz.")
                }
            }
        }else {
            self.makeAlert(titleInput: "Başarısız", messageInput: "Lütfen geçerli deger giriniz")
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alert.addAction(okBtn)
        self.present(alert, animated: true, completion: nil)
    }
    
}
