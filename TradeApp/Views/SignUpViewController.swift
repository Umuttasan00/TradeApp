
import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var uyeOlBtn: UIButton!
    
    
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
