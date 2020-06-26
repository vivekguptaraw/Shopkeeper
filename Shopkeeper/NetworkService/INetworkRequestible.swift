//
//  INetworkRequestible.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 26/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation
protocol INetworkRequestible {
    associatedtype ModelType
    var session: SKURLSession { get set }
    func load<T: Codable>(withCompletion completion: @escaping (APIResponseType<T>) -> Void)
}

extension INetworkRequestible {
    
    func request<T: Codable>(_ request: HttpRequest, handleCompletion: @escaping (APIResponseType<T>) -> Void) {
        let request = try request.createRequest()
        let task = session.dataTask(with: request) { (data, response, error) in
            let result: Result<T, HttpError>
            guard let httpResponse = response as? HTTPURLResponse else {
                 result = .failure(.InvalidResponse)
                 handleCompletion(self.createResult(result: result, request: request))
                 return
            }
            guard httpResponse.statusCode == 200 else {
                result = .failure(.InvalidData)
                handleCompletion(self.createResult(result: result, request: request))
                return
            }
            guard let successData = data else {
                result = .failure(.Unknown)
                handleCompletion(self.createResult(result: result, request: request))
                return
            }
            let decoder = JSONDecoder()
            do {
                let resp = try decoder.decode(T.self, from: successData)
                result = .success(resp)
                handleCompletion(self.createResult(result: result, request: request))
            } catch {
                result = .failure(.InvalidResponse)
                handleCompletion(self.createResult(result: result, request: request))
            }
            
        }
        task.resume()
    }
    
    private func createResult<T: Codable>(result: Result<T, HttpError>, request: URLRequest) -> APIResponseType<T> {
        let apiResponse = APIResponseType<T>(result: result, urlRequest: request)
        return apiResponse
    }
}
