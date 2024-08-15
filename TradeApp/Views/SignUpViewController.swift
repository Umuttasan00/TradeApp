
import UIKit
import FirebaseAuth


class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var phoneNumberTxtField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var uyeOlBtn: UIButton!
    
    var authController = AuthController()
    var usercontroller = UserController()
    
    let genders = ["Erkek" , "Kadın"]
    var genderPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genderTextField.inputView = genderPickerView
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        genderPickerView.tag = 1
        
    }
    
    
    @IBAction func uyeOlBtnClc(_ sender: Any) {
        let userEmail = emailTextField.text
        let userPassword = passwordTextField.text
        let userName = nameTextField.text
        let userSurname = surnameTextField.text
        let userAddress = addressTextField.text
        let userPhoneNumber = phoneNumberTxtField.text
        let gender = genderTextField.text
        
        
        if areAllFieldsFilled() {
            if passwordTextField.text == confirmPasswordTextField.text{
                authController.userSignUp(userEmail: userEmail!, userPassword: userPassword!) { success, errorMessage in
                    if success {
                        self.authController.addUserInformation(userName: userName!, userSurname: userSurname!, userEmail: userEmail!, userProfilePhotoUrl: "", userPhoneNumber: userPhoneNumber!, userAddress: userAddress!, userGender: gender!) { success in
                            if success{
                                self.makeAlert(titleInput: "Başarılı", messageInput: "Hesap başarıyla oluşturuldu") { success in
                                    if success{
                                        self.navigationController?.popViewController(animated: true)
                                    }else{
                                    }
                                }
                            }else{
                            }
                        }
                    }
                    else{
                        CustomAlert().responseAlert(alert: Alert(title: "Uye Olma Başarısız!", desc: errorMessage!, btnTitle: "Tamam", btnHandler: {
                        }()))
                    }
                }
            }else{
                self.makeAlert(titleInput: "Başarısız.", messageInput: "Girilen şifreler aynı degil.") { sccss in
                    if sccss{
                    }else{
                    }
                }
            }
        }else{
            self.makeAlert(titleInput: "Başarısız.", messageInput: "Tüm boşlukları doldurnuz.") { success in
                if success{
                }else{
                }
            }
        }       }
    
    func areAllFieldsFilled() -> Bool {
        guard
            let phoneNumber = phoneNumberTxtField.text, !phoneNumber.isEmpty,
            let name = nameTextField.text, !name.isEmpty,
            let surname = surnameTextField.text, !surname.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty,
            let address = addressTextField.text, !address.isEmpty,
            let gender = genderTextField.text, !gender.isEmpty
        else {
            return false
        }
        
        return true
    }

    func makeAlert(titleInput: String, messageInput: String, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        self.present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                alert.dismiss(animated: true, completion: {
                    completion(true)
                })
            }
        }
    }


    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return genders.count
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return genders[row]
        default:
            return "veri bulunamadı"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            genderTextField.text=genders[row]
            genderTextField.resignFirstResponder()
        default:
            return         }
    }

}
