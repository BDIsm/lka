//
//  offlineView.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 01.08.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation
import UIKit

class viewOffline: UIView {
    let defaults = UserDefaults.standard
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customize()
    }
    
    func customize() {
        self.backgroundColor = UIColor.clear
        
        if let actualDate = defaults.object(forKey: "actualDate") as? String {
            let label = UILabel()
            label.text = "Данные актуальны на \(actualDate)"
            label.font = UIFont(name: "Ekibastuz-Bold", size: 15)
            label.numberOfLines = 1
            label.textColor = UIColor.darkGray
            label.frame = self.bounds.insetBy(dx: 8.0, dy: 8.0)
            label.textAlignment = .center
            label.backgroundColor = UIColor.clear
            
            let blur = UIVisualEffectView.init(effect: UIBlurEffect(style: .light))
            blur.frame = self.bounds
            blur.clipsToBounds = true
            
            blur.contentView.addSubview(label)
            self.addSubview(blur)
        }
    }
}
