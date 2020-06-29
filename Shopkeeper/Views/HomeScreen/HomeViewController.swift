//
//  HomeViewController.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 27/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var trendingHeaderCollectionView: UICollectionView!
    var trendingContentCollectionView: UICollectionView!
    var viewModel: HomeViewModel?
    var selectedRankIndex = 0
    private var navigator: HomeNavigatorProtocol?
    
    lazy var header: CategoryHeaderView = {
        let hdr = CategoryHeaderView.loadFromNib()
        hdr.frame = CGRect(origin: .zero, size: CGSize(width: tableView.bounds.width, height: UIScreen.main.bounds.width * 0.38))
        hdr.delegate = self
        return hdr
    }()
    
    lazy var footer: UIView = {
        let vw = UIView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.bounds.width, height: Sizes.trendingHeaderHeight + (2 * Sizes.trendingContentCellHeight) + Sizes.trendingContentCellSpacing)))
        let viewLayout1 = UICollectionViewFlowLayout()
        let viewLayout2 = UICollectionViewFlowLayout()

        trendingHeaderCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: vw.frame.width, height: Sizes.trendingHeaderHeight), collectionViewLayout: viewLayout1)
        trendingContentCollectionView = UICollectionView(frame: CGRect(x: 0, y: trendingHeaderCollectionView.frame.maxY, width: vw.frame.width, height: vw.frame.height - trendingHeaderCollectionView.frame.height), collectionViewLayout: viewLayout2)
        trendingHeaderCollectionView.register(TrendingHeaderCollectionViewCell.defaultNib, forCellWithReuseIdentifier: TrendingHeaderCollectionViewCell.defaultNibName)
        trendingContentCollectionView.register(TrendingContentCollectionViewCell.defaultNib, forCellWithReuseIdentifier: TrendingContentCollectionViewCell.defaultNibName)
        trendingHeaderCollectionView.showsHorizontalScrollIndicator = false
        trendingContentCollectionView.showsHorizontalScrollIndicator = false
        vw.addSubview(trendingHeaderCollectionView)
        vw.addSubview(trendingContentCollectionView)
        trendingContentCollectionView.backgroundColor = .clear
        trendingHeaderCollectionView.backgroundColor = .clear
        return vw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewModel()
        self.tableView.backgroundColor = Colors.backgroundColor
        self.title = "Shoppy"
        navigator = HomeNavigator(navigator: self.navigationController)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        header.frame = CGRect(origin: .zero, size: CGSize(width: tableView.bounds.width, height: UIScreen.main.bounds.width * 0.38))
        tableView.tableHeaderView = header
        var border = UIView(frame: CGRect(origin: CGPoint(x: 0, y: header.frame.maxY), size: CGSize(width: header.frame.width, height: 0.5)))
        border.backgroundColor = UIColor.lightGray
        header.addSubview(border)
        tableView.tableFooterView = footer
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        trendingHeaderCollectionView.frame.size = CGSize(width: tableView.frame.width, height: trendingHeaderCollectionView.frame.size.height)
        trendingContentCollectionView.frame.size = CGSize(width: tableView.frame.width, height: trendingContentCollectionView.frame.size.height)
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
        let rankNames = ranking.map { (obj) -> String in
            var rank = ""
            let rankArray = (obj.ranking ?? "").capitalized.components(separatedBy: " ")
            rank = rankArray.count > 2 ? ((rankArray.first ?? "").appending(" \(rankArray[1])") ) : (obj.ranking ?? "")
            return rank
        }
        self.viewModel?.trendingDataSource = TrendingHeader(collectionView: self.trendingHeaderCollectionView, array: rankNames)
        self.viewModel?.trendingDataSource?.collectionItemSelectionHandler = trendingHeaderSelected
        setLayout(collectionVw: trendingHeaderCollectionView)
    }
    
    func setRankingContent(index: Int) {
        guard let state = viewModel?.state, let ranking = state.rankings, ranking.count > 0, let products = ranking[index].product?.allObjects as? [Product] else {return}
        self.viewModel?.trendingContentDataSource =
            TrendingContent(collectionView: self.trendingContentCollectionView, array: [products], type: TrendingType.type(index: index))
        self.viewModel?.trendingContentDataSource?.collectionItemSelectionHandler = trendingProductelected
        setLayout(collectionVw: trendingContentCollectionView)
    }
    
    func trendingHeaderSelected(indexPath: IndexPath) {
        self.viewModel?.trendingDataSource?.selectedIndex = indexPath.item
        self.viewModel?.trendingDataSource?.collectionView.reloadData()
        self.viewModel?.trendingDataSource?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if let products = self.viewModel?.getProductForRanking(index: indexPath.item) {
            self.viewModel?.trendingContentDataSource?.type = TrendingType.type(index: indexPath.item)
            self.viewModel?.trendingContentDataSource?.provider.items = [products]
            self.viewModel?.trendingContentDataSource?.collectionView.reloadData()
            self.viewModel?.trendingContentDataSource?.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
            
        }
    }
    
    func trendingProductelected(indexPath: IndexPath) {
        if let products = self.viewModel?.trendingContentDataSource?.provider.items, let prods = products.first {
            self.viewModel?.showProductDetail(nav: self.navigationController, product: prods[indexPath.item])
        }
        
    }
    
    func setLayout(collectionVw: UICollectionView) {
        guard let layout = collectionVw.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        if collectionVw == self.trendingHeaderCollectionView {
            let itemW = collectionVw.bounds.width * 0.4
            let itemH = collectionVw.frame.height
            layout.itemSize = CGSize(width: itemW, height: itemH)
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 8
        } else {
            let w = (collectionVw.frame.width / 2) + 30
            layout.itemSize = CGSize(width: w, height: Sizes.trendingContentCellHeight)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = Sizes.trendingContentCellSpacing
        }
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .horizontal
        layout.invalidateLayout()
    }
    
    
}

extension HomeViewController: ICategoriesHeaderDelegate {
    func selected(category object: Category) {
        self.navigator?.showCategoryScreen(category: object)
    }
}

extension HomeViewController {
    struct Sizes {
        static let trendingHeaderHeight: CGFloat = UIScreen.main.bounds.width * 0.18
        static let trendingContentCellHeight: CGFloat = UIScreen.main.bounds.width * 0.25
        static let trendingContentCellSpacing: CGFloat = 8
    }
}

