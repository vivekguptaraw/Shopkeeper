//
//  CatgoryViewController.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 29/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class CatgoryViewController: UIViewController {
    
    var viewModel: CategoryViewModel?
    
    @IBOutlet weak var parentCollectionView: UICollectionView!
    @IBOutlet weak var childLabel: UILabel!
    @IBOutlet weak var childCategoryCollection: UICollectionView!
    @IBOutlet weak var leafSelectionButton: UIButton!
    @IBOutlet weak var leafProductsCollectionView: UICollectionView!
    @IBOutlet weak var parentCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var childHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var childsParentUIVIew: UIView!
    @IBOutlet weak var dropDownImage: UIImageView!
    var selectedMainCatgoryIndex: Int = 0
    var selectedChildCatgoryIndex: Int = 0
    var openChildMenu: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        self.title = viewModel?.category?.name ?? ""
        parentCollectionView.register(ParentCollectionViewCell.defaultNib, forCellWithReuseIdentifier: ParentCollectionViewCell.defaultNibName)
        childCategoryCollection.register(ChildCategoryCollectionViewCell.defaultNib, forCellWithReuseIdentifier: ChildCategoryCollectionViewCell.defaultNibName)
        leafProductsCollectionView.register(ProductCollectionViewCell.defaultNib, forCellWithReuseIdentifier: ProductCollectionViewCell.defaultNibName)
        parentCollectionView.dataSource = self
        childCategoryCollection.dataSource = self
        leafProductsCollectionView.dataSource = self
        parentCollectionView.delegate = self
        childCategoryCollection.delegate = self
        leafProductsCollectionView.delegate = self
        parentCollectionHeight.constant = Sizes.parentCollectionHeight
        childHeightConstraint.constant = Sizes.childCollectionViewHeight
        self.loadData(name: viewModel?.grandLeafCategory?.name ?? "")
        parentCollectionView.reloadData()
        toggelLeafMenu(flag: false)
        self.childCategoryCollection.backgroundColor = .clear
        selectedMainCatgoryIndex = 0
        selectedChildCatgoryIndex = 0
        self.dropDownImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        dropDownImage.addGestureRecognizer(gesture)
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
    }
    
    func loadData(name: String) {
        leafSelectionButton.setTitle(name, for: .normal)
        childCategoryCollection.reloadData()
        leafProductsCollectionView.reloadData()
        self.setLayout(collectionView: childCategoryCollection)
        self.setLayout(collectionView: leafProductsCollectionView)
    }
    
    @IBAction func leafSelectionClicked(_ sender: Any) {
        toggelLeafMenu(flag: openChildMenu)
    }
    
    @objc func tap() {
        toggelLeafMenu(flag: openChildMenu)
    }
    
    func toggelLeafMenu(flag: Bool) {
        self.childCategoryCollection.isHidden = !flag
        self.childsParentUIVIew.backgroundColor = flag ? UIColor.gray.withAlphaComponent(0.5) : .clear
        UIView.animate(withDuration: 0.3) {
            self.childHeightConstraint.constant = flag ? UIScreen.main.bounds.width * 0.3 : 44
            self.view.layoutIfNeeded()
            self.openChildMenu = !self.openChildMenu
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setLayout()
    }
    
    func setLayout() {
        self.setLayout(collectionView: parentCollectionView)
        self.setLayout(collectionView: childCategoryCollection)
        self.setLayout(collectionView: leafProductsCollectionView)
    }
}

extension CatgoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == parentCollectionView {
            return viewModel?.category?.childCategories?.count ?? 0
        } else if collectionView == childCategoryCollection {
            return viewModel?.leafCategory?.childCategories?.count ?? 0
        } else if collectionView == leafProductsCollectionView {
            return viewModel?.grandLeafCategory?.products?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == parentCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParentCollectionViewCell.defaultNibName, for: indexPath) as? ParentCollectionViewCell {
                if let childCat = viewModel?.category?.childCategories?.allObjects as? [ChildCategory], let category = self.getSubCategories(childCats: childCat, index: indexPath.item  ) {
                    cell.configure(category, at: indexPath)
                    if selectedMainCatgoryIndex == indexPath.item {
                        cell.label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
                        cell.label.textColor = UIColor.white
                        cell.backgroundColor = Colors.blueShade?.withAlphaComponent(0.7)
                    } else {
                        cell.label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
                        cell.backgroundColor =  .white
                        cell.label.textColor = UIColor.black.withAlphaComponent(0.7)
                    }
                    cell.applyCornerRadius()
                    
                }
                
                return cell
            }
        } else if collectionView == childCategoryCollection {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChildCategoryCollectionViewCell.defaultNibName, for: indexPath) as? ChildCategoryCollectionViewCell {
                if let childCat = viewModel?.leafCategory?.childCategories?.allObjects as? [ChildCategory], let category = self.getSubCategories(childCats: childCat, index: indexPath.item  ) {
                    cell.configure(category, at: indexPath)
                    if selectedChildCatgoryIndex == indexPath.item {
                        cell.label.font = UIFont.systemFont(ofSize: 19, weight: .heavy)
                        cell.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                    } else {
                        cell.label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
                        cell.backgroundColor = UIColor.lightText.withAlphaComponent(0.05)
                    }
                }
                return cell
            }
        } else if collectionView == leafProductsCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.defaultNibName, for: indexPath) as? ProductCollectionViewCell {
                if let prods = viewModel?.grandLeafCategory?.products?.allObjects as? [Product] {
                    cell.configure(prods[indexPath.item], at: indexPath)
                }
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == parentCollectionView {
            self.selectedMainCatgoryIndex = indexPath.item
            self.viewModel?.setChilds(leafIndex: self.selectedMainCatgoryIndex, grandLeafIndex: 0)
            
            self.loadData(name: viewModel?.grandLeafs[0].name ?? "")
            self.parentCollectionView.reloadData()
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                //self.parentCollectionView.reloadData()
            }
            
            
        } else if collectionView == childCategoryCollection {
            self.selectedChildCatgoryIndex = indexPath.item
            self.openChildMenu = false
            toggelLeafMenu(flag: self.openChildMenu)
            self.viewModel?.setChilds(leafIndex: self.selectedMainCatgoryIndex, grandLeafIndex: indexPath.item)
            if let childs = viewModel?.leafCategory?.childCategories?.allObjects as? [ChildCategory] {
                let category = self.getSubCategories(childCats: childs, index: indexPath.item )
                self.loadData(name: category?.name ?? "")
            }
            
        } else if collectionView == leafProductsCollectionView {
            if let prods = viewModel?.grandLeafCategory?.products?.allObjects as? [Product] {
                self.viewModel?.showProductDetail(nav: self.navigationController, product: prods[indexPath.item])
            }
        }
        
    }

    func getSubCategories(childCats: [ChildCategory]?, index: Int) -> Category? {
        if let cats = childCats {
            if let category = self.viewModel?.getCategory(id: cats[index].id) {
                return category
            }
        }
        return nil
    }
}

extension CatgoryViewController {
    func setLayout(collectionView: UICollectionView) {
        //guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        if collectionView == parentCollectionView {
            let w = Sizes.parentCollectionCellWidth
            let h = Sizes.parentCollectionHeight - 4
            layout.itemSize = CGSize(width: w, height: h)
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 8
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            layout.scrollDirection = .horizontal
        } else if collectionView == childCategoryCollection {
            let w = Sizes.childCollectionCellWidth
            let h = Sizes.childCollectionHeight
            layout.itemSize = CGSize(width: w, height: h)
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 8
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            layout.scrollDirection = .horizontal
        } else if collectionView == leafProductsCollectionView {
            let w = collectionView.frame.width * 0.4
            let h = w
            layout.itemSize = CGSize(width: w, height: h)
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 8
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            layout.scrollDirection = .vertical
        }
        layout.prepare()
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.collectionViewLayout.invalidateLayout()
        //layout.invalidateLayout()
    }
    
    struct Sizes {
        static let parentCollectionCellWidth: CGFloat = UIScreen.main.bounds.width * 0.3
        static let parentCollectionHeight: CGFloat = 70
        
        static let childCollectionCellWidth: CGFloat = UIScreen.main.bounds.width * 0.25
        static let childCollectionViewHeight: CGFloat = 80
        static let childCollectionHeight: CGFloat = 40
    }
    
}
