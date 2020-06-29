//
//  CategoryCollectionViewCell.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 18/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell, ConfigurableCell {
    typealias T = Category
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configure(_ item: Category, at indexPath: IndexPath) {
        
    }

}
