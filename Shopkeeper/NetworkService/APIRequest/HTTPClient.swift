//
//  HTTPClient.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 26/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

struct HTTPClient<Resource: IApiResource> {
    let resource: Resource
    var session: SKURLSession
    
    init(resource: Resource, skSession: SKURLSession) {
        self.resource = resource
        self.session = skSession
    }
}

extension HTTPClient: INetworkRequestible {
    typealias ModelType = Resource.ModelType
    
    func load<T>(withCompletion completion: @escaping (APIResponseType<T>) -> Void) where T : Codable {
        self.request(resource) { (apiResponse: APIResponseType<T>) in
            completion(apiResponse)
        }
    }
}
