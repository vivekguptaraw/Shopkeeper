//
//  TrendingHeaderCollectionViewCell.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 21/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class TrendingHeaderCollectionViewCell: UICollectionViewCell, ConfigurableCell {
    typealias T = String
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.alpha = 0.8
    }
    
    func configure(_ item: String, at indexPath: IndexPath) {
        label.text = item
    }

}
