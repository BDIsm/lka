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
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        self.title = title
        self.initialize(title: title)
        self.layer.cornerRadius = 10
    }
    
    func initialize(title: String) {
        self.clipsToBounds = true
        
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont(name: "Helvetica", size: 14)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.lightGray, for: .highlighted)
        self.showsTouchWhenHighlighted = true
        
        self.setBackgroundImage(#imageLiteral(resourceName: "blue"), for: .normal)
    }
    
}
