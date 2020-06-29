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

struct Colors {
    static let backgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.2)
    static let blueShade: UIColor? =  UIColor(hex: "#0C203DFF")?.withAlphaComponent(0.7)
    static let skyBlueShade: UIColor? =  UIColor(hex: "#8FACBDFF")
    static let yellowShade: UIColor? =  UIColor(hex: "#452D01FF")
    
}
