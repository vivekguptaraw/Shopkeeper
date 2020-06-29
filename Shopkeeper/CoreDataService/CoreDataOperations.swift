//
//  CoreDataOperations.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 26/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import CoreData
import UIKit

struct CoreDataOperations {
    
    static let shared: CoreDataOperations = CoreDataOperations()
    
    private init() {}
    
    func insertDataIntoDB(categoryRankingResponse: CategoryRankingAPIResponse, completion: @escaping (Bool) -> Void) {
        parseDataForDB(apiResponseData: categoryRankingResponse, completion: completion)
    }
    
    private func parseDataForDB(apiResponseData: CategoryRankingAPIResponse, completion: @escaping (Bool) -> Void) {
        if let categoriesResponse = apiResponseData.categories, categoriesResponse.count > 0 {
            for categoryResponse in categoriesResponse {
                createCategoryEntity(categoryResponse: categoryResponse)
            }
        }
        CoreDataManager.shared.saveContext { _ in
            if let rankings = apiResponseData.rankings, rankings.count > 0 {
                self.createRankingEntity(rankingsResponse: rankings)
                CoreDataManager.shared.saveContext(completion: completion)
            } else {
                completion(false)
            }
        }
    }
    
     private func createCategoryEntity(categoryResponse: CategoryAPIModel) {
           let category = Category(context: CoreDataManager.shared.privateManagedObjectContext)
           if let id = categoryResponse.id, let i32 = Int32(id) as? Int32 {
               category.id = i32
           }
           
           category.name = categoryResponse.name
           
           let products = createProductEntity(productApiResp: categoryResponse.products)
           category.products = NSSet(array: products)
           category.childCategories = NSSet(array: createChildCategoryEntity(childCategoryResponse: categoryResponse.childCategories))
    }
    
    private func createProductEntity(productApiResp: [ProductAPIModel]?) -> [Product] {
           var products = [Product]()
           guard let productsResponseArray = productApiResp else { return products }
           
           for productResponse in productsResponseArray {
               let product = Product(context: CoreDataManager.shared.privateManagedObjectContext)
               product.id = Int16(productResponse.id ?? 0)
               product.name = productResponse.name ?? ""
               product.dateAdded = Helper.getDate(from: productResponse.dateAdded ?? "")
            
               let variants = createVariantEntity(variantsResponse: productResponse.variants)
               product.variants = NSSet(array: variants)
               
               if let taxResponse = productResponse.tax {
                   product.tax = createTaxEntity(taxResponse: taxResponse)
               }
               products.append(product)
           }
           return products
    }
    
    private func createVariantEntity(variantsResponse: [VariantAPIModel]?) -> [Variants] {
        var variants = [Variants]()
        guard let variantResponseArray = variantsResponse else { return variants }
        for variantResponse in variantResponseArray {
            let variant = Variants(context: CoreDataManager.shared.privateManagedObjectContext)
            variant.id = Int32(Int16(variantResponse.id ?? 0))
            variant.size = Int64(Int16(variantResponse.size ?? 0))
            variant.color = variantResponse.color ?? ""
            variant.price = Double(variantResponse.price ?? 0)
            variants.append(variant)
        }
        return variants
    }
    
    private func createTaxEntity(taxResponse: TaxAPIModel) -> Tax {
        let tax = Tax(context: CoreDataManager.shared.privateManagedObjectContext)
        tax.name = taxResponse.name ?? ""
        tax.value = taxResponse.value ?? 0.0
        return tax
    }
    
    private func createChildCategoryEntity(childCategoryResponse: [Int]?) -> [ChildCategory] {
        var childCategoriesArray = [ChildCategory]()
        
        if let childCategories = childCategoryResponse {
            for child in childCategories {
                let childCategory = ChildCategory(context: CoreDataManager.shared.privateManagedObjectContext)
                childCategory.id = Int16(child)
                childCategoriesArray.append(childCategory)
            }
        }
        return childCategoriesArray
    }
    
    private func createRankingEntity(rankingsResponse: [RankingAPIModel]?){
        var rankings = [Ranking]()
        var products = [Product]()
        do {
            products = try CoreDataManager.shared.privateManagedObjectContext.fetch(Product.fetchRequest())
        } catch let error {
            print(error.localizedDescription)
        }
        
        if let rankingsArray = rankingsResponse {
            for rankingResponse in rankingsArray {
                let ranking: Ranking = Ranking.findOrCreate(condition:"ranking = '\(rankingResponse.ranking ?? "")'", MOC: CoreDataManager.shared.privateManagedObjectContext)
                
                //let ranking = Ranking(context: CoreDataManager.shared.managedObjectContext)
                ranking.ranking = rankingResponse.ranking ?? ""
                if let rankingProductApiResp = rankingResponse.products {
                    for rankingProduct in rankingProductApiResp {
                        if let prod = rankingProduct.addProductToRanking(products: products) {
                            ranking.addToProduct(prod)
                        }
                    }
                }
                rankings.append(ranking)
            }
        }
    }
    
    func getCategories() -> ([Category]) {
        do {
            let categories = try CoreDataManager.shared.mainManagedObjectContext.fetch(Category.fetchRequest())
            if let array = categories as? [Category] {
                return array
            }
        } catch {
            print("Error while fetching Categories")
        }
        return []
    }
    
    func getRankings() -> ([Ranking]) {
        do {
            let ranking = try CoreDataManager.shared.mainManagedObjectContext.fetch(Ranking.fetchRequest())
            if let array = ranking as? [Ranking] {
                let sorted = array.sorted { (r1, r2) -> Bool in
                    return r1.ranking ?? "" < r2.ranking ?? ""
                }
                return sorted
            }
        } catch {
            print("Error while fetching Ranking")
        }
        return []
    }
}
