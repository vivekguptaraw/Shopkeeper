//
//  ProductViewController.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 29/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var collectionheightConstraint: NSLayoutConstraint!
    
    var viewModel: ProductViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(VariantCollectionViewCell.defaultNib, forCellWithReuseIdentifier: VariantCollectionViewCell.defaultNibName)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        collectionView.showsHorizontalScrollIndicator = false
        self.title = viewModel?.product?.name
        setData()
        self.nameLabel.textColor = Colors.blueShade
        self.colorLabel.textColor = Colors.blueShade
        self.priceLable.textColor = Colors.blueShade
    }
    
    func setData() {
        if let vars = viewModel?.product?.variants?.allObjects as? [Variants], let variant = vars[pageControl.currentPage] as? Variants {
            self.nameLabel.text = viewModel?.product?.name
            self.colorLabel.text = variant.color
            self.priceLable.text = "\(variant.price)"
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionheightConstraint.constant = Sizes.collectionHeight
        setLayout()
    }
    
}

extension ProductViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let vars = viewModel?.product?.variants, vars.count > 0 {
            self.pageControl.numberOfPages = vars.count
            self.pageControl.isHidden = false
            return vars.count
        } else {
            self.pageControl.isHidden = true
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VariantCollectionViewCell.defaultNibName, for: indexPath) as? VariantCollectionViewCell {
            if let variant = viewModel?.product?.variants?.allObjects as? [Variants] {
                cell.configure(variant[indexPath.item], at: indexPath)
            }
            //cell.backgroundColor = .random
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.item
        self.setData()
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func setLayout() {
        
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: Sizes.COLLECTIONINSET, bottom: 0, right: Sizes.COLLECTIONINSET)
            flowLayout.minimumLineSpacing = 20.0
            flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
            let width: CGFloat = UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width: UIScreen.main.bounds.height

            let height = (width / 1.07) - Sizes.CELLHEIGHTPADING - self.collectionView.frame.minY
            flowLayout.itemSize = CGSize(width: height, height: height)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
         setPage(scrollView: scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setPage(scrollView: scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setPage(scrollView: scrollView)
    }
    
    func setPage(scrollView: UIScrollView) {
        let pos = getPos(offset: scrollView.contentOffset.x, width: scrollView.frame.width)
        pageControl.currentPage = pos
        self.setData()
    }
    
    func getPos(offset: CGFloat, width: CGFloat) -> Int {
        let pos = offset / (width - 2 * Sizes.COLLECTIONINSET)
        let intRound = Int(round(pos))
        return intRound
    }
    
    struct Sizes {
        static let collectionCellWidth: CGFloat = UIScreen.main.bounds.width
        static let collectionHeight: CGFloat = UIScreen.main.bounds.width * 0.7
        static let COLLECTIONINSET: CGFloat =  90
        static let CELLHEIGHTPADING: CGFloat =  100
    }
}
