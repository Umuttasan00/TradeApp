//
//  BasketViewCell.swift
//  TradeApp
//
//  Created by Muhammet Umut Taşan on 13.08.2024.
//

import UIKit

class BasketViewCell: UITableViewCell {

    @IBOutlet weak var fastDeliverLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    var deleteProductOnBasketBtnClcAction: (() -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteProductOnBasketBtnClc(_ sender: Any) {
        deleteProductOnBasketBtnClcAction?()
    }
    
    
}
