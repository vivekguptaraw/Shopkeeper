//
//  CategoryCollectionViewCell.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 27/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell, ConfigurableCell {
    typealias T = Category
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = Colors.blueShade
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    func configure(_ item: Category, at indexPath: IndexPath) {
        
    }

}
