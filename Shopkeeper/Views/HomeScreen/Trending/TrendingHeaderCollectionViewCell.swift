//
//  TrendingHeaderCollectionViewCell.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 28/06/20.
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
        self.label.layer.cornerRadius = self.label.bounds.height / 2
    }
    
    func configure(_ item: String, at indexPath: IndexPath) {
        label.text = item
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}
