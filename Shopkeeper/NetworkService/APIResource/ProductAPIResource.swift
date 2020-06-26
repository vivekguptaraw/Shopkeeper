//
//  ProductAPIResource.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 26/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

struct ProductAPIResource: IApiResource {
    typealias ModelType = CategoryRankingAPIResponse
    var path: String = "/json"
}
