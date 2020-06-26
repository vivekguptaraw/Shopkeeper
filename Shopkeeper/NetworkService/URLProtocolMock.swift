//
//  URLProtocolMock.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 25/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

class URLProtocolMock: URLProtocol {
    static var testUrlsWithData = [URL: Data?]()
    static var response: HTTPURLResponse?
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let url = self.request.url, let data = Self.testUrlsWithData[url] as? Data {
            // Found mock data.. load it immediately
            self.client?.urlProtocol(self, didReceive: Self.response!, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
    
}
