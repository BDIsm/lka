//
//  docInChatViewCell.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 07.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class docInChatViewCell: UICollectionViewCell {
    let select = UIImageView()
    
    let numberLabel = UILabel()
    let dateLabel = UILabel()
    let addressLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        self.layer.masksToBounds = false
        
        self.backgroundColor = UIColor.white
        //Shape
        self.layer.cornerRadius = 10.0
        //Shadow
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10.0
        
        select.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        select.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        
        numberLabel.frame = CGRect(x: 40, y: 10, width: (self.frame.width-60)/2, height: 20)
        numberLabel.textAlignment = .left
        numberLabel.textColor = UIColor.lightGray
        numberLabel.font = UIFont(name: "Helvetica", size: 12)
        
        dateLabel.frame = CGRect(x: 50+numberLabel.frame.width, y: 10, width: (self.frame.width-60)/2, height: 20)
        dateLabel.textAlignment = .right
        dateLabel.textColor = UIColor.lightGray
        dateLabel.font = UIFont(name: "Helvetica", size: 12)
        
        addressLabel.frame = CGRect(x: 10, y: 40, width: self.frame.width-20, height: self.frame.height-50)
        addressLabel.numberOfLines = 0
        addressLabel.textAlignment = .justified
        addressLabel.textColor = UIColor.gray
        addressLabel.font = UIFont(name: "Helvetica", size: 9)
        
        self.addSubview(numberLabel)
        self.addSubview(dateLabel)
        self.addSubview(addressLabel)
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected
            {
                select.image = #imageLiteral(resourceName: "blue")
                select.clipsToBounds = true
                //select.backgroundColor = UIColor(red:0.60, green:0.78, blue:0.94, alpha:1.0)
            }
            else
            {
                select.image = UIImage()
                select.backgroundColor = UIColor(white: 0.95, alpha: 1)
            }
        }
    }
    
    func redraw() {
        select.layer.cornerRadius = select.frame.width/2
        select.layer.borderColor = UIColor(white: 0.85, alpha: 1).cgColor
        select.layer.borderWidth = 1
        
        self.addSubview(select)
    }
}
