//
//  DataSources.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 28/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class TrendingHeader: CollectionArrayDataSource<String, TrendingHeaderCollectionViewCell> {
        var selectedIndex = 0
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
            if let hCell = cell as? TrendingHeaderCollectionViewCell {
                if selectedIndex == indexPath.item {
                    hCell.label.font = UIFont(name: "Papyrus", size: 22)
                    hCell.label.textColor = Colors.yellowShade
                } else {
                    hCell.label.font = UIFont(name: "Papyrus", size: 18)
                    hCell.label.textColor = .gray
                }
            }
            return cell
            
        }
    
        
}

class TrendingContent: CollectionArrayDataSource<Product, TrendingContentCollectionViewCell> {
    var type: TrendingType = .MostOrdered
    
    init(collectionView: UICollectionView, array: [[Product]], type: TrendingType) {
        self.type = type
        super.init(collectionView: collectionView, array: array)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
           if let hCell = cell as? TrendingContentCollectionViewCell {
            if let item = self.item(at: indexPath) {
                    hCell.setCount(type: self.type, countText: self.type.getCountText(item: item))
                    hCell.setNeedsLayout()
                    hCell.layoutIfNeeded()
                }
           }
           
           return cell
    }
    
}

enum TrendingType {
    case MostViewed, MostOrdered, MostShared
    
    static func type(index: Int) -> TrendingType {
        switch index {
        case 0:
            return .MostOrdered
        case 1:
            return .MostShared
        case 2:
            return .MostViewed
        default:
            return .MostOrdered
        }
    }
    
    func getCountText(item: Product) -> String {
        switch self {
        case .MostViewed:
            return "\(item.viewsCount)  Views"
        case .MostOrdered:
            return "\(item.ordersCount)  Orderes"
        case .MostShared:
            return "\(item.shareCount)  Shares"
        }
        return ""
    }
    
}
