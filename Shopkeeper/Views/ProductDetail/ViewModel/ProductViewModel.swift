//
//  ProductViewModel.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 29/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

protocol ProductDetailProtocol {
    func showProductDetail(nav: UINavigationController?, product: Product)
}

class ProductViewModel {
    var product: Product?
}

