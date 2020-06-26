//
//  APIResponseType.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 26/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

enum HttpError: Error {
    case ConnectionError(Error)
    case Unknown
    case InvalidData
    case InvalidResponse
}

struct APIResponseType<Value: Codable> {
    var result: Result<Value, HttpError>
    var urlRequest: URLRequest
}
