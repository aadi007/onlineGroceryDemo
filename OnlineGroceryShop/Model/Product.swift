//
//  Product.swift
//  OnlineGroceryShop
//
//  Created by Aadesh Maheshwari on 07/12/15.
//  Copyright © 2015 Aadesh Maheshwari. All rights reserved.
//

import UIKit

class Product: NSObject {
    var Id: Int16 = 0
    var name: String?
    var price: String?
    
    init(productName:String, productId: Int16, productPrice: String) {
        super.init()
        self.name = productName
        self.Id = productId
        self.price = productPrice
    }

}
