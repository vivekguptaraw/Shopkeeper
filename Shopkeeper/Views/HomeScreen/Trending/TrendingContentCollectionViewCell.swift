//
//  TrendingContentCollectionViewCell.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 28/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class TrendingContentCollectionViewCell: UICollectionViewCell, ConfigurableCell {
    
    typealias T = Product
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = Colors.blueShade
        self.label.numberOfLines = 3
        self.label.lineBreakMode = .byTruncatingTail
        self.label.textColor = .white
        self.countLabel.textColor = .white
        self.layer.cornerRadius = (self.label.bounds.height / 2 + 4)
        self.productImage.layer.cornerRadius = self.productImage.bounds.height / 2
    }
    
    func configure(_ item: Product, at indexPath: IndexPath) {
        label.text = item.name
        productImage.image = UIImage(named: "placeholder2" )
        //setRadius()
    }
    
    func setCount(type: TrendingType, countText: String) {
        countLabel.text = countText
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}
