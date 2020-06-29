//
//  CategoryViewModel.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 29/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class CategoryViewModel {
    
    var categories: [Category]
    var leafCategory: Category?
    var grandLeafCategory: Category?
    var grandLeafs = [Category]()
    
    var category: Category? {
        didSet {
            setChilds(leafIndex: 0, grandLeafIndex: 0)
        }
    }
    
    init() {
        categories = CoreDataOperations.shared.getCategories()
    }
    
    func setChilds(leafIndex: Int, grandLeafIndex: Int) {
        guard let allChildCategories = category?.childCategories?.allObjects as? [ChildCategory] else {return}
        guard let leafCat = getCategory(id: allChildCategories[leafIndex].id) else {
            return
        }
        self.leafCategory = leafCat
        grandLeafs.removeAll()
        if let grandLeaf = leafCat.childCategories?.allObjects as? [ChildCategory] {
            for index in grandLeaf {
                grandLeafs.append(getCategory(id: Int16(index.id))!)
            }
            if grandLeafs.count > grandLeafIndex {
                if let grandleafCat = getCategory(id: Int16(grandLeafs[grandLeafIndex].id)) {
                    grandLeafCategory = grandleafCat
                }
            }
            
        }
    }
    
    func getCategory(id: Int16) -> Category? {
        return categories.first{ $0.id == id} ?? nil
    }
    
    
}

extension CategoryViewModel: ProductDetailProtocol {
    func showProductDetail(nav: UINavigationController?, product: Product) {
        if let vc = Helper.getViewControllerFromStoryboard(toStoryBoard: .Main, initialViewControllerIdentifier: ProductViewController.storyBoardID) as? ProductViewController {
            vc.viewModel = ProductViewModel()
            vc.viewModel?.product = product
            nav?.pushViewController(vc, animated: true)
        }
    }
}
