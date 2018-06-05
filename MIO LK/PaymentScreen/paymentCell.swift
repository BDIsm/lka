//
//  paymentCell.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 04.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation
import UIKit

class paymentViewCell: UICollectionViewCell {
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var typeImage: UIImageView!
    
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var date: UILabel!
    
    func customize(image: UIImage, a: String, d: String) {
        layer.cornerRadius = 10
        
        back.image = image
        //typeImage.image = #imageLiteral(resourceName: "DeNiro")
        
        amount.text = "\(a) ₽"
        date.text = "от \(d)"
    }
    
}
