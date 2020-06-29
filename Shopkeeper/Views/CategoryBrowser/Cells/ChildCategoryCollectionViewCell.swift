//
//  ChildCategoryCollectionViewCell.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 29/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class ChildCategoryCollectionViewCell: UICollectionViewCell, ConfigurableCell {
    
    typealias T = Category
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = Colors.blueShade
        
        // Initialization code
    }
    
    func configure(_ item: Category, at indexPath: IndexPath) {
        label.text = item.name
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
    }

}
