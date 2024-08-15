import Foundation

class Product {


    
    var productName: String
    var productDesc: String
    var productSeller: String
    var productPrice: String
    var productCategory: String
    var deliverType: String
    var productImageUrl1: String
    var productImageUrl2: String
    var productImageUrl3: String
    var productImageUrl4: String
    var documentId: String
    
    
    // Tüm özellikleri başlatan init
    init(productName: String, productDesc: String, productSeller: String, productPrice: String, productCategory: String, deliverType: String, productImageUrl1: String, productImageUrl2: String, productImageUrl3: String, productImageUrl4: String, documentId : String) {
        self.productName = productName
        self.productDesc = productDesc
        self.productSeller = productSeller
        self.productPrice = productPrice
        self.productCategory = productCategory
        self.deliverType = deliverType
        self.productImageUrl1 = productImageUrl1
        self.productImageUrl2 = productImageUrl2
        self.productImageUrl3 = productImageUrl3
        self.productImageUrl4 = productImageUrl4
        self.documentId = documentId
    }
    
    // Boş init (varsayılan değerlerle)
    init() {
        self.productName = ""
        self.productDesc = ""
        self.productSeller = ""
        self.productPrice = ""
        self.productCategory = ""
        self.deliverType = ""
        self.productImageUrl1 = ""
        self.productImageUrl2 = ""
        self.productImageUrl3 = ""
        self.productImageUrl4 = ""
        self.documentId = ""

    }
}
