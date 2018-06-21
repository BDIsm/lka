//
//  BALabel.swift
//  MIO.v2
//
//  Created by Исматуллоев Бежан on 03.04.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation
import UIKit

class BALabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func initializeLabel(input: String, size: CGFloat, lines: Int, color: UIColor) {
        self.font = UIFont(name: "Helvetica", size: size)
        self.textColor = color
        self.backgroundColor = UIColor.clear
        self.numberOfLines = lines
        self.text = input
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.1
        self.sizeToFit()
        self.textAlignment = .justified
    }
}

