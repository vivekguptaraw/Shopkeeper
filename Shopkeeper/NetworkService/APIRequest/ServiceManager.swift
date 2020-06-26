//
//  ServiceManager.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 26/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

final class ServiceManager {
    static let shared: ServiceManager = ServiceManager()
    var session: SKURLSession = URLSession(configuration: .default)
    private init() {}
}

extension ServiceManager: IAPIs {
    func fetchCategories(completion: @escaping (ProductAPIResource.ModelType?) -> Void) {
        let resource = ProductAPIResource()
        let request = HTTPClient(resource: resource, skSession: session)
        request.load { (response: APIResponseType<ProductAPIResource.ModelType>) in
            switch response.result {
            case .success(let model):
                print(model)
                completion(model)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
