//
//  ShowProductCell.swift
//  TradeApp
//
//  Created by Muhammet Umut Taşan on 11.08.2024.
//

import UIKit

class ShowProductCell: UITableViewCell {
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDescLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    let userController = UserController()
    var favoriteButtonAction: (() -> Void)?
    var addBasketButtonAction: (() -> Void)?

    var reviewButtonAction: (() -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func reviewBtnClc(_ sender: Any) {
        reviewButtonAction?()
    }
    
    @IBAction func addBasketBtnClc(_ sender: Any) {
        addBasketButtonAction?()
    }
    
 
    
      
    @IBAction func favoriteBtnClc(_ sender: Any) {
        
        favoriteButtonAction?()
    }
}
