//
//  CategoryRankingAPIResponse.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 26/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

// MARK: - CategoryRankingAPIResponse
struct CategoryRankingAPIResponse: Codable {
    let categories: [CategoryAPIModel]?
    let rankings: [RankingAPIModel]?
}

// MARK: - Category
struct CategoryAPIModel: Codable {
    let id: Int?
    let name: String?
    let products: [ProductAPIModel]?
    let childCategories: [Int]?

    enum CodingKeys: String, CodingKey {
        case id, name, products
        case childCategories = "child_categories"
    }
}

// MARK: - Product
struct ProductAPIModel: Codable {
    let id: Int?
    let name, dateAdded: String?
    let variants: [VariantAPIModel]?
    let tax: TaxAPIModel?

    enum CodingKeys: String, CodingKey {
        case id, name
        case dateAdded = "date_added"
        case variants, tax
    }
}

// MARK: - Tax
struct TaxAPIModel: Codable {
    let name: String?
    let value: Double?
}

// MARK: - Variant
struct VariantAPIModel: Codable {
    let id: Int?
    let color: String?
    let size: Int?
    let price: Int?
}

// MARK: - Ranking
struct RankingAPIModel: Codable {
    let ranking: String?
    let products: [RankingProductAPIModel]?
}

// MARK: - RankingProduct
struct RankingProductAPIModel: Codable {
    let id: Int?
    let viewCount, orderCount, shares: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case viewCount = "view_count"
        case orderCount = "order_count"
        case shares
    }
}


