//
//  URLSession+Additions.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 25/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation


public protocol SKURLSession {
  func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
  func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: SKURLSession { }
