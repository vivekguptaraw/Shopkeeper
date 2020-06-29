//
//  ParentCollectionViewCell.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 29/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class ParentCollectionViewCell: UICollectionViewCell, ConfigurableCell {
    
    typealias T = Category
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ item: Category, at indexPath: IndexPath) {
        label.text = item.name
    }

}
