////
////  messageView.swift
////  MIO LK
////
////  Created by Исматуллоев Бежан on 07.06.2018.
////  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class messageView: UIView {
//    var text = String()
//    var width = CGFloat()
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = UIColor.clear
//    }
//    
//    init(frame: CGRect, text: String, width: CGFloat) {
//        super.init(frame: frame)
//        self.text = text
//        self.width = width
//        customize()
//    }
//    
//    func customize() {
//        // Инициализация лейбла
//        let myLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: 35.0)))
//        myLabel.numberOfLines = 0
//        myLabel.text = text
//        myLabel.textColor = UIColor.darkText
//        myLabel.sizeToFit()
//        myLabel.setNeedsDisplay()
//        
//        // Инициализация View для лейбла
//        let viewForLbl = UIImageView(frame: myLabel.bounds.insetBy(dx: -10, dy: -5).offsetBy(dx: 10, dy: 5))
//        viewForLbl.backgroundColor = .white
//        viewForLbl.clipsToBounds = true
//        viewForLbl.layer.cornerRadius = 10.0
//        viewForLbl.layer.borderColor = UIColor.lightGray.cgColor
//        viewForLbl.layer.borderWidth = 0.5
//        viewForLbl.insertSubview(myLabel, at: 1)
//        
//        myLabel.center = viewForLbl.center
//        
//        self.frame = viewForLbl.frame
//        self.addSubview(viewForLbl)
//    }
//}
