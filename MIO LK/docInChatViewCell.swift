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
        numberLabel.font = UIFont(name: "Helvetica", size: 14)
        
        dateLabel.frame = CGRect(x: 50+numberLabel.frame.width, y: 10, width: (self.frame.width-60)/2, height: 20)
        dateLabel.textAlignment = .right
        dateLabel.textColor = UIColor.lightGray
        dateLabel.font = UIFont(name: "Helvetica", size: 14)
        
        addressLabel.frame = CGRect(x: 10, y: 40, width: self.frame.width-20, height: self.frame.height-50)
        addressLabel.numberOfLines = 0
        addressLabel.textAlignment = .justified
        addressLabel.textColor = UIColor.gray
        addressLabel.font = UIFont(name: "Helvetica", size: 11)
        
        self.addSubview(numberLabel)
        self.addSubview(dateLabel)
        self.addSubview(addressLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected
            {
                select.backgroundColor = UIColor(red: 0.25, green: 0.35, blue: 0.7, alpha: 1)
            }
            else
            {
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
