//
//  arrowView.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 22.08.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation
import UIKit

class arrowView: UIView {
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let gradientOne = UIColor(red: 44.0/255.0, green: 191.0/255.0, blue: 248.0/255.0, alpha: 1.0).cgColor
    let gradientTwo = UIColor(red: 38.0/255.0, green: 127.0/255.0, blue: 241.0/255.0, alpha: 1.0).cgColor
    
    var colorTop: UIColor?
    var colorBottom: UIColor?
    
    init(origin: CGPoint) {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: 40, height: 10))
        self.center = origin
        self.backgroundColor = .clear
    }
    
    // We need to implement init(coder) to avoid compilation errors
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        // Левая нижняя точка
        let lftTopPt = CGPoint(x: rect.minX+rect.height/8, y: rect.minY)
        let lftBotPt = CGPoint(x: rect.minX+rect.height/8, y: rect.midY)
        let rghtTopPt = CGPoint(x: rect.maxX-rect.height/8, y: rect.minY)
        let rghtBotPt = CGPoint(x: rect.maxX-rect.height/8, y: rect.midY)
        
        let cntrPt = CGPoint(x: rect.midX, y: rect.midY)
        let cntrBotPt = CGPoint(x: rect.midX, y: rect.maxY)

        let lftTopCurvePt = CGPoint(x: rect.minX, y: rect.minY+rect.height/8)
        let lftBotCurvePt = CGPoint(x: rect.minX, y: rect.minY+rect.height*3/8)
        let rghtTopCurvePt = CGPoint(x: rect.maxX, y: rect.minY+rect.height/8)
        let rghtBotCurvePt = CGPoint(x: rect.maxX, y: rect.minY+rect.height*3/8)
        
        path.move(to: lftTopPt)
        path.addLine(to: cntrPt)
        path.addLine(to: rghtTopPt)
        path.addCurve(to: rghtBotPt, controlPoint1: rghtTopCurvePt, controlPoint2: rghtBotCurvePt)
        path.addLine(to: cntrBotPt)
        path.addLine(to: lftBotPt)
        path.addCurve(to: lftTopPt, controlPoint1: lftBotCurvePt, controlPoint2: lftTopCurvePt)
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        gradientSet.append([colorTop?.cgColor ?? gradientOne, colorBottom?.cgColor ?? gradientTwo])
        gradientSet.append([colorBottom?.cgColor ?? gradientTwo, colorTop?.cgColor ?? gradientOne])
        
        gradient.mask = shapeLayer
        gradient.masksToBounds = false
        gradient.frame = self.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:0, y:1)
        gradient.drawsAsynchronously = true
        
        animateGradient()
        
        self.layer.masksToBounds = false
        self.layer.addSublayer(gradient)
    }
    
    func animateGradient() {
        if currentGradient < gradientSet.count-1 {
            currentGradient += 1
        }
        else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
    }
    
}
