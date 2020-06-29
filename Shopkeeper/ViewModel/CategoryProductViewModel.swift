//
//  CategoryProduct.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 20/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

struct CategoryState {
    var categories: [Category]? 
    var parentCategories: [Category]? 
    var rankings: [Ranking]? 
    var rankedProducts: [Product]? 
    var fetchTryCount: Int  = 3
    
}

extension CategoryState {
    enum FetchState {
        case FreshDataFetched
        case DBDataFetched
        case DBDataUpdated
        case Error(CustomError)
    }

    enum CustomError {
        case ParsingFailed
        case ErrorGettingData
        case RetriesExhausted
    }
}


protocol CategoryProductViewModel {
    var state: CategoryState { get }
    var onChange: ((CategoryState.FetchState) -> Void)? { get set}
    
    func reloadData()
}

