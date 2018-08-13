//
//  viewDocument.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 29.05.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation
import UIKit

class viewDocument: UIView {
    let topInset: CGFloat = 10
    let bottomInset: CGFloat = 10
    let rightInset: CGFloat = 10
    let leftInset: CGFloat = 10
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
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
        
    }
    
    func addSeparators(number: String, date: String, type: String, owner: String, address: String, rent: String) {
        let area = self.bounds.height - topInset - bottomInset
        let separatorWidth = self.bounds.width - rightInset - leftInset
        
        let labelWidth = separatorWidth/2
        
        let cellHeight = area/6-3
        
        // Number
        let numberLbl = BALabel()
        numberLbl.initializeLabel(input: number, size: 15, lines: 1, color: UIColor.darkGray)
        numberLbl.textAlignment = .center
        
        let viewForLbl = UIView()
        viewForLbl.frame.size = CGSize(width: separatorWidth*5/12, height: 20)
        viewForLbl.frame.origin = CGPoint(x: 10, y: cellHeight/2)// - viewForLbl.frame.height)
        viewForLbl.layer.cornerRadius = 5
        viewForLbl.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 0.85)
        numberLbl.center = CGPoint(x: viewForLbl.bounds.midX, y: viewForLbl.bounds.midY)
        
        viewForLbl.addSubview(numberLbl)
        self.addSubview(viewForLbl)
        
        // Date
        let dateLbl = BALabel()
        dateLbl.initializeLabel(input: "от "+date, size: 15, lines: 1, color: UIColor.darkGray)
        dateLbl.textAlignment = .center
        
        let viewForDate = UIView()
        viewForDate.frame.size = CGSize(width: separatorWidth*5/12, height: 20)
        viewForDate.frame.origin = CGPoint(x: self.bounds.maxX-10-viewForDate.frame.width, y: cellHeight/2)
        viewForDate.layer.cornerRadius = 5
        viewForDate.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 0.85)
        dateLbl.center = CGPoint(x: viewForDate.bounds.midX, y: viewForDate.bounds.midY)
        
        viewForDate.addSubview(dateLbl)
        self.addSubview(viewForDate)
        
        // Type
        let typeLbl = BALabel()
        typeLbl.initializeLabel(input: type, size: 17, lines: 0, color: UIColor.darkGray)
        typeLbl.textAlignment = .right
        typeLbl.frame.size = CGSize(width: labelWidth, height: cellHeight-10)
        typeLbl.frame.origin = CGPoint(x: self.bounds.midX, y: cellHeight*2-5-typeLbl.frame.height)
        
        let tLabel = BALabel()
        tLabel.initializeLabel(input: "Объекта:", size: 15, lines: 1, color: UIColor.lightGray)
        tLabel.frame.size = CGSize(width: labelWidth, height: tLabel.frame.height)
        tLabel.frame.origin = CGPoint(x: 10, y: cellHeight+5)// - tLabel.frame.height)
        
        self.addSubview(typeLbl)
        self.addSubview(tLabel)
        
        // Owner
        let ownerLbl = BALabel()
        ownerLbl.initializeLabel(input: owner, size: 17, lines: 0, color: UIColor.darkGray)
        ownerLbl.textAlignment = .right
        ownerLbl.frame.size = CGSize(width: labelWidth, height: cellHeight-10)
        ownerLbl.frame.origin = CGPoint(x: self.bounds.midX, y: cellHeight*3-5-ownerLbl.frame.height)
        
        let oLabel = BALabel()
        oLabel.initializeLabel(input: "Арендодатель:", size: 15, lines: 1, color: UIColor.lightGray)
        oLabel.frame.size = CGSize(width: labelWidth, height: oLabel.frame.height)
        oLabel.frame.origin = CGPoint(x: 10, y: cellHeight*2+5)// - oLabel.frame.height)
        
        self.addSubview(ownerLbl)
        self.addSubview(oLabel)
        
        // Address
        let addressLbl = BALabel()
        addressLbl.initializeLabel(input: address, size: 17, lines: 0, color: UIColor.darkGray)
        addressLbl.textAlignment = .right
        addressLbl.frame.size = CGSize(width: labelWidth, height: cellHeight-10)
        addressLbl.frame.origin = CGPoint(x: self.bounds.midX, y: cellHeight*4-5-addressLbl.frame.height)
        
        let aLabel = BALabel()
        aLabel.initializeLabel(input: "Адрес:", size: 15, lines: 1, color: UIColor.lightGray)
        aLabel.frame.size = CGSize(width: labelWidth, height: aLabel.frame.height)
        aLabel.frame.origin = CGPoint(x: 10, y: cellHeight*3+5)
        
        self.addSubview(addressLbl)
        self.addSubview(aLabel)
        
        let rentLbl = BALabel()
        rentLbl.initializeLabel(input: "\(rent) руб.", size: 20, lines: 0, color: UIColor.red)
        rentLbl.textAlignment = .right
        rentLbl.frame.size = CGSize(width: labelWidth, height: cellHeight-10)
        rentLbl.frame.origin = CGPoint(x: self.bounds.midX, y: cellHeight*5-5-addressLbl.frame.height)
        
        let rLabel = BALabel()
        rLabel.initializeLabel(input: "Арендная плата:", size: 15, lines: 1, color: UIColor.lightGray)
        rLabel.frame.size = CGSize(width: labelWidth, height: rLabel.frame.height)
        rLabel.frame.origin = CGPoint(x: 10, y: cellHeight*4+5)
        
        self.addSubview(rentLbl)
        self.addSubview(rLabel)
        
        for i in 1..<6 {
            let yPos = cellHeight * CGFloat(i)
            let line = UIView(frame: CGRect(x: leftInset, y: yPos, width: separatorWidth, height: 0.5))
            line.backgroundColor = UIColor(white: 0.9, alpha: 1)
            self.addSubview(line)
        }
    }
}

