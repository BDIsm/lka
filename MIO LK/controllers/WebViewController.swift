//
//  WebViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 20.08.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    private let wkDismissNot = Notification.Name("wkDismiss")
    
    var close = Bool()
    var checkNeeded = Bool()
    
    var mosregURL: URL? {
        didSet {
            let myRequest = URLRequest(url: mosregURL!)
            wk.load(myRequest)
            wk.isHidden = true
        }
    }
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var wk: WKWebView!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBAction func tapToClose(_ sender: UITapGestureRecognizer) {
        checkNeeded = false
        removeFromParentViewController()
        close = true
    }
    
    @IBAction func move(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        let edgePoint = UIScreen.main.bounds.height*9/40
        
        if close { // предотвращение вызова при анимации закрытия
        }
        else {
            if self.view.frame.origin.y > edgePoint { // контроллер прошел через точку закрытия
                checkNeeded = false
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
        
        wk.uiDelegate = self
        wk.navigationDelegate = self
        
        wk.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progress.progress = Float(wk.estimatedProgress)
            if Float(wk.estimatedProgress) == 1.0 {
                progress.isHidden = true
            }
            else {
                progress.isHidden = false
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: topView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        shadowLayer.fillColor = UIColor(white: 0.97, alpha: 1.0).cgColor
        shadowLayer.shadowColor = UIColor.lightGray.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
        shadowLayer.shadowOpacity = 0.8
        shadowLayer.shadowRadius = 2.0
        
        topView.layer.mask = shadowLayer
        topView.layer.insertSublayer(shadowLayer, below: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        if let vc = parent as? AuthViewController {
            let arrow = arrowView(origin: topView.center)
            topView.addSubview(arrow)
            
            // Настройка контроллера
            self.view.layer.masksToBounds = false
            self.view.layer.cornerRadius = 10
            
            moveTo(view: vc.content, frame: vc.view.frame)
        }
    }
    
    override func removeFromParentViewController() {
        if let vc = parent as? AuthViewController {
            NotificationCenter.default.post(name: wkDismissNot, object: nil, userInfo: ["authCheck": checkNeeded])
            removeFrom(view: vc.content, frame: vc.view.frame)
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let currentURL = parseURL(wk.url!)
        
        if currentURL[1] == "mob.razvitie-mo.ru" {
            checkNeeded = true
            removeFromParentViewController()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let currentURL = parseURL(wk.url!)
    
        if currentURL[1] == "sso.mosreg.ru" {
            let javaScriptClick = "document.getElementsByClassName('form-control btn btn-primary wide btn--esia')[0].click();"
            self.wk.evaluateJavaScript(javaScriptClick)
        }
        else if currentURL[1] == "esia.gosuslugi.ru" && currentURL[2] == "idp" {
            wk.isHidden = false
            activity.stopAnimating()
        }
    }
    
    func parseURL(_ myUrl: URL) -> [String.SubSequence] {
        let urlStr = myUrl.absoluteString
        let partsOfUrl = urlStr.split(separator: "/")
        return partsOfUrl
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
            //self.shadow(opacity: 0.8, color: .lightGray, radius: 10.0)
            view.isUserInteractionEnabled = false
        }
    }
    
    func removeFrom(view: UIView, frame: CGRect) {
        self.tabBarController?.tabBar.isHidden = false
        
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
        })
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
