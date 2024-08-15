//
//  Alert.swift
//  TradeApp
//
//  Created by Muhammet Umut Taşan on 10.08.2024.
//

import Foundation

class Alert{
    var title:String
    var desc:String
    var btnTitle:String
    var btnHandler:Void
    
    init(title: String, desc: String, btnTitle: String, btnHandler: Void) {
        self.title = title
        self.desc = desc
        self.btnTitle = btnTitle
        self.btnHandler = btnHandler
    }
    
}
