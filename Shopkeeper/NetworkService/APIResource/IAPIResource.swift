//
//  IAPIResource.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 26/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

protocol IApiResource: HttpRequest {
    associatedtype ModelType: Codable
}
