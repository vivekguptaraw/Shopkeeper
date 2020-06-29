//
//  HomeViewController.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 17/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    var trendingHeaderCollectionView: UICollectionView!
    var trendingContentCollectionView: UICollectionView!
    var viewModel: HomeViewModel?
    var selectedRankIndex = 0
    private var navigator: HomeNavigatorProtocol?
    
    lazy var header: CategoryHeaderView = {
        let hdr = CategoryHeaderView.loadFromNib()
        hdr.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.38))
        hdr.delegate = self
        return hdr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewModel()
        self.topView.addSubview(header)
        self.title = "Heady Mart"
        navigator = HomeNavigator(navigator: self.navigationController)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        header.frame = topView.bounds
        footer.frame = bottomView.bounds
        trendingHeaderCollectionView.frame = CGRect(x: 0, y: 0, width: self.bottomView.frame.width, height: Sizes.trendingHeaderHeight)
        trendingContentCollectionView.frame = CGRect(x: 0, y: trendingHeaderCollectionView.frame.maxY, width: self.bottomView.frame.width, height: bottomView.frame.height - trendingHeaderCollectionView.frame.height)
    }
    
    func setViewModel() {
        viewModel = HomeViewModel()
        viewModel?.onChange = changes
        viewModel?.reloadData()
    }
    
    func changes(change: CategoryState.FetchState) {
        switch change {
        case .FreshDataFetched:
            print("==> FreshDataFetched")
            setData()
        case .DBDataFetched:
            print("==> FreshDataFetched")
            setData()
        case .DBDataUpdated:
            print("==> FreshDataFetched")
            setData()
        case .Error(let error):
            switch error {
            case .ErrorGettingData:
                print("==> Error ErrorGettingData")
            case .ParsingFailed:
                print("==> Error ParsingFailed")
            case .RetriesExhausted:
                print("==> Error RetriesExhausted")
            }
        }
    }
    
    func setData() {
        DispatchQueue.main.async {[weak self] in
            guard let slf = self else {return}
            slf.header.categories = slf.viewModel?.state.categories
            slf.setTrendingItems()
        }
    }
    
    func setTrendingItems() {
        self.setRankingHeader()
        self.setRankingContent(index: 0)
    }
    
    func setRankingHeader() {
        guard let ranking = viewModel?.state.rankings else {return}
        let rankNames = ranking.map {$0.ranking ?? ""}
        self.viewModel?.trendingDataSource = TrendingHeader(collectionView: self.trendingHeaderCollectionView, array: rankNames)
        self.viewModel?.trendingDataSource?.collectionItemSelectionHandler = trendingHeaderSelected
        setLayout(collectionVw: trendingHeaderCollectionView)
    }
    
    func setRankingContent(index: Int) {
        guard let state = viewModel?.state, let ranking = state.rankings, ranking.count > 0, let products = ranking[index].product?.allObjects as? [Product] else {return}
        self.viewModel?.trendingContentDataSource = TrendingContent(collectionView: self.trendingContentCollectionView, array: products)
        self.viewModel?.trendingContentDataSource?.collectionItemSelectionHandler = trendingProductelected
        setLayout(collectionVw: trendingContentCollectionView)
    }
    
    func trendingHeaderSelected(indexPath: IndexPath) {
        self.viewModel?.trendingDataSource?.selectedIndex = indexPath.item
        self.viewModel?.trendingDataSource?.collectionView.reloadData()
        self.viewModel?.trendingDataSource?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if let products = self.viewModel?.getProductForRanking(index: indexPath.item) {
            self.viewModel?.trendingContentDataSource?.provider.items = [products]
            self.viewModel?.trendingContentDataSource?.collectionView.reloadData()
            self.viewModel?.trendingContentDataSource?.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
            
        }
    }
    
    func trendingProductelected(indexPath: IndexPath) {
        if let products = self.viewModel?.trendingContentDataSource?.provider.items, let prods = products.first {
        }
        
    }
    
    func setLayout(collectionVw: UICollectionView) {
        guard let layout = collectionVw.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let itemW = collectionVw == self.trendingHeaderCollectionView ? collectionVw.bounds.width * 0.4 : collectionVw.bounds.width * 0.4
        let itemH = collectionVw == self.trendingHeaderCollectionView ?  collectionVw.frame.width * 0.3 : collectionVw.frame.width * 0.4
        
        if collectionVw == self.trendingHeaderCollectionView {
            layout.itemSize = CGSize(width: itemW, height: itemH)
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 8
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        } else {
            let w = (collectionVw.frame.width / 3.0) - (5 + 10 )
            layout.itemSize = CGSize(width: w, height: w)
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 8
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        layout.scrollDirection = collectionVw == self.trendingHeaderCollectionView ? .horizontal : .vertical
        layout.invalidateLayout()
    }
    
    lazy var footer: UIView = {
        let viewLayout1 = UICollectionViewFlowLayout()
        let viewLayout2 = UICollectionViewFlowLayout()

        trendingHeaderCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.bottomView.frame.width, height: Sizes.trendingHeaderHeight), collectionViewLayout: viewLayout1)
        trendingContentCollectionView = UICollectionView(frame: CGRect(x: 0, y: trendingHeaderCollectionView.frame.maxY, width: self.bottomView.frame.width, height: bottomView.frame.height - trendingHeaderCollectionView.frame.height), collectionViewLayout: viewLayout2)
        trendingHeaderCollectionView.register(TrendingHeaderCollectionViewCell.defaultNib, forCellWithReuseIdentifier: TrendingHeaderCollectionViewCell.defaultNibName)
        trendingContentCollectionView.register(TrendingContentCollectionViewCell.defaultNib, forCellWithReuseIdentifier: TrendingContentCollectionViewCell.defaultNibName)
        trendingHeaderCollectionView.showsHorizontalScrollIndicator = false
        trendingContentCollectionView.showsVerticalScrollIndicator = false
        let vw = UIView()
        vw.frame = CGRect(origin: .zero, size: CGSize(width: self.bottomView.frame.width, height: trendingHeaderCollectionView.frame.height + trendingContentCollectionView.frame.height))
        vw.addSubview(trendingHeaderCollectionView)
        vw.addSubview(trendingContentCollectionView)
        trendingContentCollectionView.backgroundColor = .white
        trendingHeaderCollectionView.backgroundColor = .white
        self.bottomView.addSubview(vw)
        return vw
    }()
}

extension HomeViewController: ICategoriesHeaderDelegate {
    func selected(category object: Category) {
        self.navigator?.showCategoryScreen(category: object)
    }
}

extension HomeViewController {
    struct Sizes {
        static let trendingHeaderHeight: CGFloat = UIScreen.main.bounds.width * 0.18
    }
}
