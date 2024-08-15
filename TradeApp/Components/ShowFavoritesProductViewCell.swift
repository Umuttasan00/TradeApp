//
//  ShowFavoritesProductViewCell.swift
//  TradeApp
//
//  Created by Muhammet Umut Taşan on 12.08.2024.
//

import UIKit

class ShowFavoritesProductViewCell: UITableViewCell {

    @IBOutlet weak var favoriteProductNameLbl: UILabel!
    @IBOutlet weak var favoriteProductImageView: UIImageView!
    @IBOutlet weak var favoriteProductDescLbl: UILabel!
    @IBOutlet weak var favoriteProductPriecLbl: UILabel!
    
    var addBasketButtonAction: (() -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
               
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addBasketBtnClc(_ sender: Any) {
        addBasketButtonAction?()
    }
    
}
