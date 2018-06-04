//
//  payView.swift
//  MIO.v2
//
//  Created by Исматуллоев Бежан on 24.05.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation
import UIKit

class viewPayment: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size = CGSize(width: 60, height: 60)
        //Shape
        self.layer.cornerRadius = 10.0
        /*Shadow
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 4.0*/
    }
    
    func customize(status: String, amount: String, date: String) {
        let backImage = UIImageView(frame: self.bounds)
        backImage.clipsToBounds = true
        backImage.layer.cornerRadius = 10.0
        
        switch status {
        case "gray":
            backImage.image = #imageLiteral(resourceName: "gray")
        case "red":
            backImage.image = #imageLiteral(resourceName: "red")
        default:
            backImage.image = #imageLiteral(resourceName: "blue")
        }
        
        self.addSubview(backImage)
        
        let label = BALabel()
        label.initializeLabel(input: "\(amount)₽", size: 11, lines: 1, color: UIColor.white)
        label.textAlignment = .center
        label.frame.size.width = self.bounds.width-5
        label.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        self.addSubview(label)
        
        let dateLabel = BALabel()
        dateLabel.initializeLabel(input: "от \(date)", size: 8, lines: 1, color: UIColor.white)
        dateLabel.textAlignment = .center
        dateLabel.frame.size.width = self.bounds.width-5
        dateLabel.frame.origin = CGPoint(x: 2.5, y: label.frame.maxY)
        self.addSubview(dateLabel)
    }
}
