//
//  HomeNavigatorProtocol.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 22/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

protocol HomeNavigatorProtocol {
    init(navigator: UINavigationController?)
    func showCategoryScreen(category: Category)
}

class HomeNavigator: HomeNavigatorProtocol {
    
    var navigator: UINavigationController?
    
    required init(navigator nav: UINavigationController?) {
        self.navigator = nav
    }
    
    func showCategoryScreen(category: Category) {
        
    }
    
}





