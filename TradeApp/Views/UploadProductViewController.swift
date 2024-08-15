//
//  UploadProductViewController.swift
//  TradeApp
//
//  Created by Muhammet Umut Taşan on 8.08.2024.
//



// TODO:
//  - detaylar ekranı
//  - ürüm silme
//  - ürün foto getirme url firebase de var
//  - siparis gecmisi


import UIKit

class UploadProductViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    //categori pickerView kodları
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return Categories.count
        case 2:
            return fastDeliver.count
        case 3:
            return priceCurrencyArray.count
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return Categories[row]
        case 2:
            return fastDeliver[row]
        case 3:
            return priceCurrencyArray[row]
        default:
            return "veri bulunamadı"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            productCategoryTxtField.text=Categories[row]
            productCategoryTxtField.resignFirstResponder()
        case 2:
            fastDeliverTextField.text=fastDeliver[row]
            fastDeliverTextField.resignFirstResponder()
        case 3:
            priceCurrencyTextField.text = priceCurrencyArray[row]
            priceCurrencyTextField.resignFirstResponder()
        default:
            return         }
    }
    
    @IBOutlet weak var productNameTxtField: UITextField!
    @IBOutlet weak var productDescTxtField: UITextField!
    @IBOutlet weak var productCategoryTxtField: UITextField!
    @IBOutlet weak var productPriceTxtField: UITextField!
    @IBOutlet weak var fastDeliverTextField: UITextField!
    @IBOutlet weak var productImage1ImageView: UIImageView!
    @IBOutlet weak var productImage2ImageView: UIImageView!
    @IBOutlet weak var productImage3ImageView: UIImageView!
    @IBOutlet weak var productImage4ImageView: UIImageView!
    @IBOutlet weak var priceCurrencyTextField: UITextField!
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    
    var ProdcutImageArray: [UIImage] = []

    
    let priceCurrencyArray = ["₺","€","$","£"]
    var priceCurrencyPickerView = UIPickerView()
    
    let Categories = ["Giyim" ,"Teknoloji","Bebek" ,"Evcil Hayvan", "Hobi"]
    var categoriesPickerView = UIPickerView()
    
    let fastDeliver = ["Hızlı teslimat var","Hızlı teslimat yok"]
    var fastDeliverPickerView = UIPickerView()
    
    let imagePicker = UIImagePickerController()
    var productController = ProductController()
    let customAlert = CustomAlert()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        productCategoryTxtField.inputView = categoriesPickerView
        categoriesPickerView.delegate = self
        categoriesPickerView.dataSource = self
        categoriesPickerView.tag = 1
        
        fastDeliverTextField.inputView = fastDeliverPickerView
        fastDeliverPickerView.delegate = self
        fastDeliverPickerView.dataSource = self
        fastDeliverPickerView.tag = 2
        
        priceCurrencyTextField.inputView = priceCurrencyPickerView
        priceCurrencyPickerView.delegate = self
        priceCurrencyPickerView.dataSource = self
        priceCurrencyPickerView.tag = 3
        
    }
    
    
    @IBAction func addProductBtnClc(_ sender: Any) {
        
    
        let priceWithCurrency = "\(productPriceTxtField.text!) \(priceCurrencyTextField.text!)"
        let newProduct = Product(
            productName: productNameTxtField.text!,
            productDesc: productDescTxtField.text!,
            productSeller: SignedUser.user.userName,
            productPrice: priceWithCurrency,
            productCategory: productCategoryTxtField.text!,
            deliverType: fastDeliverTextField.text!,
            productImageUrl1: CurrentProduct.product.productImageUrl1,
            productImageUrl2: CurrentProduct.product.productImageUrl2,
            productImageUrl3: CurrentProduct.product.productImageUrl3,
            productImageUrl4: CurrentProduct.product.productImageUrl4,
            documentId: ""
        )
        if newProduct.productName != "" && newProduct.productDesc != "" && newProduct.productPrice != "" && newProduct.productCategory != "" && priceCurrencyTextField.text != "" && fastDeliverTextField.text != ""{
            productController.addProduct(product: newProduct) { success, error in
                if success{
                    for i in 0..<self.ProdcutImageArray.count {
                        if self.productImage1ImageView.image == nil {
                           
                            self.productController.addProductPhoto(image: self.ProdcutImageArray[i] ) { photoUrl in
                                print(photoUrl as Any)
                                CurrentProduct.product.productImageUrl1 = photoUrl!
                            }
                        }else if self.productImage2ImageView.image == nil {
                            
                            self.productController.addProductPhoto(image: self.ProdcutImageArray[i] ) { photoUrl in
                                print(photoUrl as Any)
                                CurrentProduct.product.productImageUrl2 = photoUrl!
                            }
                        }else if self.productImage3ImageView.image == nil {
                           
                            self.productController.addProductPhoto(image: self.ProdcutImageArray[i] ) { photoUrl in
                                print(photoUrl as Any)
                                CurrentProduct.product.productImageUrl3 = photoUrl!
                            }
                        }else if self.productImage4ImageView.image == nil {
                           
                            self.productController.addProductPhoto(image: self.ProdcutImageArray[i] ) { photoUrl in
                                print(photoUrl as Any)
                                CurrentProduct.product.productImageUrl4 = photoUrl!
                            }
                        }else{
                            print("Hata")
                        }
                    }
                   
                    
                    self.makeAlert(titleInput: "Başarılı", messageInput: "Ürün başarı ile eklendi .") { success in
                        if success{
                            if let tabBarController = self.tabBarController {
                                tabBarController.selectedIndex = 0
                            }
                            self.ProdcutImageArray.removeAll()
                            self.productNameTxtField.text = nil
                            self.productDescTxtField.text = nil
                            self.productPriceTxtField.text = nil
                            self.priceCurrencyTextField.text = nil
                            self.productCategoryTxtField.text = nil
                            self.fastDeliverTextField.text = nil
                            self.productImage1ImageView.image = nil
                            self.productImage2ImageView.image = nil
                            self.productImage3ImageView.image = nil
                            self.productImage4ImageView.image = nil
                        }else{
                            
                        }
                    }
                    print("asd\(CurrentProduct.product.productImageUrl1)")
                    print("asd\(CurrentProduct.product.productImageUrl2)")
                    print("as\(CurrentProduct.product.productImageUrl3)")
                    print("asd\(CurrentProduct.product.productImageUrl4)")
                    
                }else {
                    print(error?.localizedDescription as Any)
                }
            }
        }
        else{
            self.makeAlert(titleInput: "Başarısız", messageInput: "Boşlukları doldurun.") { success in
                if success{
                    
                }else{
                    
                }
            }

        }
    }
    
    
    @IBAction func addPhotoBtnClc(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
   
    
    
    // galeriden foto seçme
    func selectPhoto() {
           imagePicker.sourceType = .photoLibrary
           present(imagePicker, animated: true, completion: nil)
       }

       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let image = info[.originalImage] as? UIImage {
               
               if productImage1ImageView.image == nil {
                   productImage1ImageView.image = image
                   ProdcutImageArray.append(image)
                   productController.addProductPhoto(image: image) { photoUrl in
                       CurrentProduct.product.productImageUrl1 = photoUrl!
                   }
               }else if productImage2ImageView.image == nil {
                   productImage2ImageView.image = image
                   ProdcutImageArray.append(image)
                   productController.addProductPhoto(image: image) { photoUrl in
                       CurrentProduct.product.productImageUrl2 = photoUrl!
                   }
               }else if productImage3ImageView.image == nil {
                   productImage3ImageView.image = image
                   ProdcutImageArray.append(image)
                   productController.addProductPhoto(image: image) { photoUrl in
                       CurrentProduct.product.productImageUrl3 = photoUrl!
                   }
               }else if productImage4ImageView.image == nil {
                   productImage4ImageView.image = image
                   ProdcutImageArray.append(image)
                   productController.addProductPhoto(image: image) { photoUrl in
                       CurrentProduct.product.productImageUrl4 = photoUrl!
                   }
               }else{
                   print("Hata")
               }
           }
           dismiss(animated: true, completion: nil)
       }

       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           dismiss(animated: true, completion: nil)
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
