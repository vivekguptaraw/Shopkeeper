//
//  CarouselLayout.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 30/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

import Foundation
let ACTIVE_DISTANCE: CGFloat = 150.0
let ZOOM_FACTOR: CGFloat = 0.3

class CarouselLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        let visibleRect = CGRect(origin: self.collectionView!.contentOffset, size: CGSize(width: self.collectionView!.bounds.width / 2, height: self.collectionView!.bounds.height / 2))
        if let attributesArray = attributes {
            for attribute in attributesArray {
                if attribute.frame.intersects(rect) {
                    let distance = visibleRect.maxX - attribute.center.x
                    let normalizedDistance = distance / ACTIVE_DISTANCE
                    if abs(distance) < ACTIVE_DISTANCE {
                        let zoom = 1 + ZOOM_FACTOR * (1.0 - abs(normalizedDistance))
                        attribute.transform3D = CATransform3DScale(CATransform3DIdentity, zoom, zoom, 1.0)
                        attribute.zIndex =  Int(round(zoom))
                    }
                }
            }
        }
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
