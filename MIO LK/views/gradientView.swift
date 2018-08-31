//
//  gradientView.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 10.08.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation
import UIKit

class gradient {
    class func setColour(for view: UIView, status: String, radius: CGFloat) -> (CALayer, UIColor, UIColor) {
        var colorTop = UIColor()
        var colorBottom = UIColor()
            
        switch status {
        case "Оплачено":
            // Blue
            colorTop =  UIColor(red: 44.0/255.0, green: 191.0/255.0, blue: 248.0/255.0, alpha: 1.0)
            colorBottom = UIColor(red: 38.0/255.0, green: 127.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        case "Не оплачено (неоплаченное начисление прошлого периода)":
            // Red
            colorTop =  UIColor(red: 227.0/255.0, green: 9.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            colorBottom = UIColor(red: 165.0/255.0, green: 6.0/255.0, blue: 25.0/255.0, alpha: 1.0)
        default:
            // Orange
            colorTop =  UIColor(red: 255.0/255.0, green: 174.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            colorBottom = UIColor(red: 237.0/255.0, green: 98.0/255.0, blue: 7.0/255.0, alpha: 1.0)

//            colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0)
//            colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        gradientLayer.cornerRadius = radius
        
        return (gradientLayer, colorBottom, colorTop)
    }
}
