//
//  UIColor.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 20/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 0.45)
    }
    
    static var randomDark: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
