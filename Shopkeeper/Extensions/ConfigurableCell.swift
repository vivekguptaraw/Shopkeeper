//
//  ConfigurableCell.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 18/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

protocol ConfigurableCell: NibLoadableProtocol {
    associatedtype T
    func configure(_ item: T, at indexPath: IndexPath)
}
