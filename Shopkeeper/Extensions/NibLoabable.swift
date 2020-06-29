//
//  NibLoabable.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 18/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

protocol StoryBoardID: class {}

extension StoryBoardID where Self: UIViewController {
    static var storyBoardID: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryBoardID {
    
}

protocol NibLoadableProtocol {
    static var defaultNibName: String { get }
    static func loadFromNib() -> Self
}

extension NibLoadableProtocol where Self: UIView {
    
    static var defaultNibName: String {
        return String(describing: self)
    }
    
    static var defaultNib: UINib {
        return UINib(nibName: defaultNibName, bundle: nil)
    }
    
    static func loadFromNib() -> Self {
        guard let nib = Bundle.main.loadNibNamed(defaultNibName, owner: nil, options: nil)?.first as? Self else {
            fatalError("[NibLoadableProtocol] Cannot load view from nib.")
        }
        return nib
    }
    
}
