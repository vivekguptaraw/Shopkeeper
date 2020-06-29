//
//  UIVIew+Additions.swift
//  Shopkeeper
//
//  Created by Vivek Gupta on 29/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

extension UIView {
    func applyCornerRadius() {
        self.layer.cornerRadius = self.bounds.height / 2
    }
}
