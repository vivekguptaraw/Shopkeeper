//
//  Helper.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 26/06/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

enum  StoryBoard: String {
    case Main
}

struct Helper {
    
    static func getDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        if let date = formatter.date(from: dateString) {
            return date
        }
        return nil
    }
    
    static func getViewControllerFromStoryboard(toStoryBoard storyBoardName: StoryBoard, initialViewControllerIdentifier identifier: String) -> UIViewController? {
        let storyBoard = UIStoryboard(name: storyBoardName.rawValue, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: identifier)
    }
}
