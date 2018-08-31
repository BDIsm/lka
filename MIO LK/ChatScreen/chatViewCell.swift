//
//  chatViewCell.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 06.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class chatViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func prepareForReuse() {
        dateLabel.text = ""
        themeLabel.text = ""
        messageLabel.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customize()
    }
    
    var date: String? {
        didSet {
            dateLabel.text = date
        }
    }
    
    var theme: String? {
        didSet {
            themeLabel.text = theme
        }
    }
    
    var message: String? {
        didSet {
            messageLabel.text = message
        }
    }
    
    func customize() {
        self.layer.masksToBounds = false
        
        self.backgroundColor = UIColor.white
        
        self.layer.cornerRadius = 20.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 12.0
        self.layer.shadowOpacity = 0.7
    }
    
}
