//
//  DataSources.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 21/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class TrendingHeader: CollectionArrayDataSource<String, TrendingHeaderCollectionViewCell> {
        var selectedIndex = 0
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
            if let hCell = cell as? TrendingHeaderCollectionViewCell {
                if selectedIndex == indexPath.item {
                    hCell.label.font = UIFont(name: "Papyrus", size: 20)
                    hCell.label.textColor = .black
                } else {
                    hCell.label.font = UIFont(name: "Papyrus", size: 18)
                    hCell.label.textColor = .gray
                }
            }
            return cell
            
        }
    
        
}

class TrendingContent: CollectionArrayDataSource<Product, TrendingContentCollectionViewCell> {
    
}
