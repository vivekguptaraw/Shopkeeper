//
//  CategoryHeaderView.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 18/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

protocol ICategoriesHeaderDelegate : class {
    func selected(category object: Category)
}

class CategoryHeaderView: UIView, NibLoadableProtocol {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: ICategoriesHeaderDelegate?
    
    var categories: [Category]! {
        didSet {
            if categories != nil, categories.count > 0 {
                collectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(CategoryCollectionViewCell.defaultNib, forCellWithReuseIdentifier: CategoryCollectionViewCell.defaultNibName)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let w = UIScreen.main.bounds.width * 0.4
            layout.itemSize = CGSize(width: w, height: self.collectionView.frame.height - 10)
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 10
            layout.invalidateLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}

extension CategoryHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories != nil ? categories.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.defaultNibName, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        //cell.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        cell.titleLabel.text = categories[indexPath.row].name ?? ""
        cell.titleLabel.textColor = .white
//        cell.layer.cornerRadius = 12
//        cell.layer.borderWidth = 1
//        cell.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if categories[indexPath.row] != nil {
            self.delegate?.selected(category: categories[indexPath.row])
        }
        
    }
    
    
}
