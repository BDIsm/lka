//
//  settingReusableView.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 05.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class settingReusableView: UICollectionReusableView {
    let defaults = UserDefaults.standard
    //Для настроек:
    @IBOutlet weak var viewWithButtons: UIView!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var reload: UIButton!
    @IBOutlet weak var exit: UIButton!
    
    //Анимация настроек
    let kRotationAnimationKey = "com.myapplication.rotationanimationkey" // Any key
    var open = Bool()
    
    //Позиция и размер
    var widthOpen = CGFloat()
    var widthClose = CGFloat()
    var xClose = CGFloat()
    var xOpen = CGFloat()
    
    @IBAction func exitTap(_ sender: UIButton) {
        defaults.set(false, forKey: "isAuthorized")
        Switcher.updateRootVC()
    }
    
    @IBAction func settingsTap(_ sender: Any) {
        if open {
            rotateView(view: settings, direct: 1.0)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.decrease()
            }) { (true) in
                self.stopRotatingView(view: self.settings)
            }
        }
        else {
            rotateView(view: settings, direct: -1.0)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.increase()
            }) { (true) in
                self.stopRotatingView(view: self.settings)
            }
        }
        open = !open
    }
    
    func decrease() {
        viewWithButtons.frame.origin.x = self.bounds.maxX-settings.frame.width-30
        viewWithButtons.frame.size.width = settings.frame.width+20
        
        reload.alpha = 0
        exit.alpha = 0
    }
    
    func increase() {
        viewWithButtons.frame.origin.x = self.bounds.minX+10
        viewWithButtons.frame.size.width = self.bounds.width-20
        
        reload.alpha = 1
        exit.alpha = 1
    }
    
    // Анимация для кнопки настроек
    func rotateView(view: UIView, duration: Double = 1, direct: Double) {
        if view.layer.animation(forKey: kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float(.pi * 2.0 * direct)
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            
            view.layer.add(rotationAnimation, forKey: kRotationAnimationKey)
        }
    }
    
    func stopRotatingView(view: UIView) {
        if view.layer.animation(forKey: kRotationAnimationKey) != nil {
            view.layer.removeAnimation(forKey: kRotationAnimationKey)
        }
    } 
}
