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
    
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var background = CALayer()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        background.removeFromSuperlayer()
    }
    
    func customize(_ status: String, _ accrual: String, _ from: String) {
        layer.cornerRadius = 10
        
        background = gradient.setColour(for: self, status: status, radius: 10).0
        self.layer.insertSublayer(background, at: 0)
        
        amount.text = "\(accrual) ₽"
        date.text = from != "" ? "от \(from)" : "нет даты"
    }
    
}
