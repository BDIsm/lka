//
//  WebViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 20.08.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    @IBOutlet weak var wk: WKWebView!
    
    var close = Bool()
    
    @IBAction func move(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        let edgePoint = UIScreen.main.bounds.height*9/40
        
        if close { // предотвращение вызова при анимации закрытия
        }
        else {
            if self.view.frame.origin.y > edgePoint { // контроллер прошел через точку закрытия
                removeFromParentViewController()
                close = true
            }
            else {
                if self.view.frame.origin.y+translation.y <= 30 { // попытка поднять контроллер выше начального положения
                }
                else {
                    self.view.frame.origin.y += translation.y
                    if let vc = parent as? AuthViewController {
                        scaleOnDragg(view: vc.content, frame: vc.view.frame, edge: edgePoint) // увеличение заднего контроллера
                    }
                }
                
                if sender.state == .ended {
                    if let vc = parent as? AuthViewController {
                        animateOnDraggingEnding(view: vc.content, frame: vc.view.frame) // анимация, если контроллер не закрыли
                    }
                }
            }
        }
        
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настройка контроллера
        self.view.layer.masksToBounds = false
        self.view.layer.cornerRadius = 10
        
        wk.uiDelegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        if let vc = parent as? AuthViewController {
            moveTo(view: vc.content, frame: vc.view.frame)
        }
    }
    
    override func removeFromParentViewController() {
        if let vc = parent as? AuthViewController {
            removeFrom(view: vc.content, frame: vc.view.frame)
        }
    }
    
    func moveTo(view: UIView, frame: CGRect) {
        let scaleX = 1-20/frame.width
        let scaleY = 1-40/frame.height
        
        // Указание размеров контроллера с начислением
        self.view.frame = CGRect(x: 0, y: frame.maxY-40, width: frame.width, height: frame.height-20)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .preferredFramesPerSecond60, animations: {
            let transformScale = CGAffineTransform(scaleX: scaleX, y: scaleY)
            view.transform = transformScale
            
            // Смена статус бара
            UIApplication.shared.statusBarStyle = .lightContent
            // Закругление углов
            view.layer.cornerRadius = 10
            // Анимация child контроллера
            self.view.frame.origin.y = 30
        }) { (true) in
            self.shadow(opacity: 0.8, color: .lightGray, radius: 10.0)
            view.isUserInteractionEnabled = false
        }
    }
    
    func removeFrom(view: UIView, frame: CGRect) {
        self.tabBarController?.tabBar.isHidden = false
        
        self.shadow(opacity: 0, color: .white, radius: 0)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .preferredFramesPerSecond60, animations: {
            let transformScale = CGAffineTransform(scaleX: 1, y: 1)
            view.transform = transformScale
            
            // Смена статус бара
            UIApplication.shared.statusBarStyle = .default
            
            // Закругление углов
            view.layer.cornerRadius = 0
            // Анимация child контроллера
            self.view.frame.origin.y = frame.maxY-40
        }) { (true) in
            self.view.removeFromSuperview()
            view.isUserInteractionEnabled = true
        }
    }
    
    func scaleOnDragg(view: UIView, frame: CGRect, edge: CGFloat) {
        let scaleX = 1-20/frame.width
        let scaleY = 1-40/frame.height
        
        let multiplicator = self.view.frame.origin.y/edge
        
        let changeScaleX = scaleX+(1-scaleX)*multiplicator
        let changeScaleY = scaleY+(1-scaleY)*multiplicator
        
        let transformScale = CGAffineTransform(scaleX: changeScaleX, y: changeScaleY)
        view.transform = transformScale
    }
    
    func animateOnDraggingEnding(view: UIView, frame: CGRect) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .preferredFramesPerSecond60, animations: {
            let scaleX = 1-20/frame.width
            let scaleY = 1-40/frame.height
            
            let transformScale = CGAffineTransform(scaleX: scaleX, y: scaleY)
            view.transform = transformScale
            
            // Анимация child контроллера
            self.view.frame.origin.y = 30
        }) { (true) in
        }
    }
    
    func setUp(_ myUrl: URL) {
        let js = "document.getElementsByClassName('form-control btn btn-primary wide btn--esia')[0].click();"
        
        let myRequest = URLRequest(url: myUrl)
        wk.load(myRequest)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.wk.evaluateJavaScript(js) { (result, error) in
            }
        })
    }
    
    func shadow(opacity: Float, color: UIColor, radius: CGFloat) {
        self.view.layer.shadowColor = color.cgColor
        self.view.layer.shadowOpacity = opacity
        self.view.layer.shadowOffset = CGSize.zero
        self.view.layer.shadowRadius = radius
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
