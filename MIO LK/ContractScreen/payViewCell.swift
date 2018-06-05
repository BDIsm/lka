//
//  payViewCell.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 04.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class payViewCell: UICollectionViewCell {
    @IBOutlet weak var back: UIImageView!
    
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var date: UILabel!
    
    func customize(image: UIImage, a: String, d: String) {
        layer.cornerRadius = 10
        
        back.image = image
        
        amount.text = "\(a) ₽"
        date.text = "от \(d)"
    }
    
}
