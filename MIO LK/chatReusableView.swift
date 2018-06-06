//
//  chatReusableView.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 06.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class chatReusableView: UICollectionReusableView {
    
    @IBOutlet weak var back: UIImageView!
    
    func customize() {
        back.layer.cornerRadius = 10
        
        
    }
    
}
