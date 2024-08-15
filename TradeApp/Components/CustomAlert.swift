//
//  CustomAlert.swift
//  TradeApp
//
//  Created by Muhammet Umut Taşan on 10.08.2024.
//

import Foundation
import UIKit

class CustomAlert: UIViewController {
    
    func makeAlert(alert:Alert) {
        let tempAlert = UIAlertController(title: alert.title, message: alert.desc, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: alert.btnTitle, style: .default, handler: {_ in alert.btnHandler})
        tempAlert.addAction(okBtn)
        UIApplication.shared.windows.first?.rootViewController?.present(tempAlert, animated: true, completion: {
            
        })
        
        
    }
    
    func responseAlert(alert:Alert) {
        let tempAlert = UIAlertController(title: alert.title, message: alert.desc, preferredStyle: .alert)

        UIApplication.shared.windows.first?.rootViewController?.present(tempAlert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                tempAlert.dismiss(animated: true)
            }
        })
        
        
    }
    
}
