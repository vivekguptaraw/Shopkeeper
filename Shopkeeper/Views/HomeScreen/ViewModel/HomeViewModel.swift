//
//  HomeViewModel.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 20/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class HomeViewModel: CategoryProductViewModel {
    fileprivate(set) var state: CategoryState = CategoryState()
    var onChange: ((CategoryState.FetchState) -> Void)?
    var trendingDataSource: TrendingHeader?
    var trendingContentDataSource: TrendingContent?
    
    func reloadData() {
        fetchFromDB()
        guard let categories = state.categories, categories.count > 0 else {
            fetchDataFromAPI()
            return
        }
        
        onChange?(.DBDataFetched)
        fetchDataFromAPI()
    }
    
    func fetchDataFromAPI() {
        ServiceManager.shared.fetchCategories {[weak self] (model) in
            guard let slf = self else { return }
            guard let categories = model else {
                slf.onChange?(.Error(.ErrorGettingData))
                return
            }
            slf.onChange?(.FreshDataFetched)
            slf.saveDataToDB(model: categories)
        }
    }
    
    func saveDataToDB(model: ProductAPIResource.ModelType) {
        CoreDataOperations.shared.insertDataIntoDB(categoryRankingResponse: model, completion: {[weak self] success in
            guard let slf = self else {return}
            slf.fetchFromDB()
            slf.onChange?(.DBDataUpdated)
        })
    }
    
    func fetchFromDB() {
        self.setTopLevelCategories()
        self.state.rankings = CoreDataOperations.shared.getRankings()
    }
    
    func setTopLevelCategories() {
        var topCategories = CoreDataOperations.shared.getCategories().filter {
            guard let childs = $0.childCategories, childs.count > 0 else {
                return false
            }
            return true
        }
        var childIds = [Int16]()
        for item in topCategories {
            guard let childCat = item.childCategories?.allObjects as? [ChildCategory], childCat.count > 0 else { return }
            _ = childCat.map { (obj) in
                childIds.append(obj.id)
            }
        }
        topCategories = topCategories.filter{
            return !childIds.contains(Int16($0.id))
        }
        self.state.categories = topCategories
    }
    
    func getProductForRanking(index: Int) -> [Product] {
        if let products = self.state.rankings?[index].product?.allObjects as? [Product] {
            return products
        }
        return []
    }
}


