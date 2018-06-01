//
//  PaymentsCollectionViewCell.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 01.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class PaymentsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func display(text: String) {
        titleLabel.text = text
    }
}
