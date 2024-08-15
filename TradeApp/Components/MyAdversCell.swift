//
//  MyAdversCell.swift
//  TradeApp
//
//  Created by Muhammet Umut Taşan on 14.08.2024.
//

import UIKit

class MyAdversCell: UITableViewCell {

    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var productDescLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productImageImageView: UIImageView!
    
    var dropAdversButtonAction: (() -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }
    @IBAction func dropAdversBtnClc(_ sender: Any) {
        dropAdversButtonAction?()
    }
    
}
