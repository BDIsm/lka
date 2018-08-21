//
//  buttonView.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 07.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation
import UIKit

class buttonView: UIButton {
    var title = String()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    func initialize() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        
        self.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption2)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.lightGray, for: .highlighted)
        self.showsTouchWhenHighlighted = true
        
        self.setBackgroundImage(#imageLiteral(resourceName: "blue"), for: .normal)
    }
    
}
