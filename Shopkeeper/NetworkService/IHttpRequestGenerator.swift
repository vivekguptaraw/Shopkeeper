//
//  IHttpRequestProtocol.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 26/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
}

protocol HttpRequest {
    var baseUrl: URL { get }
    var path: String { get }
    var method: HttpMethod {get}
}

extension HttpRequest {
    var baseUrl: URL {return URL(string: "https://stark-spire-93433.herokuapp.com")!}
    var method: HttpMethod {return .get}

    func createRequest() -> URLRequest {
        let url = baseUrl.appendingPathComponent(path)
        guard URLComponents(url: url, resolvingAgainstBaseURL: false) != nil else {
            fatalError("URL is not valid")
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        request.httpMethod = method.rawValue
        return request
    }
}

