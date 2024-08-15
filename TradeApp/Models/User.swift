//
//  User.swift
//  TradeApp
//
//  Created by Muhammet Umut Taşan on 8.08.2024.
//

import Foundation

class User {
    static var allProducts: [Product] = []
    static var userFavoritesProduct: [Product] = []
    static var userBasketProduct: [Product] = []
    static var myProducts: [Product] = []
    static var userFavoriteProductsIdsArray: [String] = []
    static var userOrderProductsIdsArray: [String] = []

    var userEmail : String = ""
    var userName : String = ""
    var userSurname : String = ""
    var userAddress : String = ""
    var userPhoneNumber : String = ""
    var userProfilePhotoUrl : String = ""
    var userGender : String = ""
    var favoritesArray: [String] = []

    
    init(userEmail: String, userName: String, userSurname: String,userPhoneNumber:String, userAddress: String,userProfilePhotoUrl:String , userGender: String) {
        self.userEmail = userEmail
        self.userName = userName
        self.userSurname = userSurname
        self.userAddress = userAddress
        self.userPhoneNumber = userPhoneNumber
        self.userProfilePhotoUrl = userProfilePhotoUrl
        self.userGender = userGender
    }
    init(){
        
    }
}
