//
//  VariantCollectionViewCell.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 29/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class VariantCollectionViewCell: UICollectionViewCell, ConfigurableCell {
    
    typealias T = Variants
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = Colors.blueShade
        self.label.textColor = .white
        // Initialization code
    }
    
    func configure(_ item: Variants, at indexPath: IndexPath) {
        if let name = item.color?.lowercased() {
            label.text = name
        }
    }

}
