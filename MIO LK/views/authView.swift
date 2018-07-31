//
//  authView.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 31.07.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation
import UIKit

class authView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    func setUp() {
        self.layer.masksToBounds = false
        
        self.backgroundColor = UIColor.white
        //Shape
        self.layer.cornerRadius = 10.0
        //Shadow
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10.0
    }
}
