//
//  SelectedProductViewCell.swift
//  OnlineGroceryShop
//
//  Created by Aadesh Maheshwari on 08/12/15.
//  Copyright © 2015 Aadesh Maheshwari. All rights reserved.
//

import UIKit

class SelectedProductViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
