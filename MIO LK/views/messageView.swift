//
//  messageView.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 06.08.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation
import UIKit

class messageView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = .white
    }
}
