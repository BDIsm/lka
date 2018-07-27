//
//  InitialViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 29.05.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit
import SafariServices

class InitialViewController: UIViewController, URLSessionDataDelegate, SFSafariViewControllerDelegate {
    let defaults = UserDefaults.standard
    
    private var uuid = String()

    private let authNot = NSNotification.Name("auth")
    private let urlNot = NSNotification.Name("url")
    private let tokenNot = NSNotification.Name("token")
    private let docNot = NSNotification.Name("documents")
    private let payNot = NSNotification.Name("pay")
    
    let request = classRequest()
    
    var documents = [classDocuments]()
    var numberOfDocuments: Int = 1
    var numberOfPays = Int()
    
    var progressValue: Float = 0
    
    enum direction: Int {
        case toTop
        case toBottom
    }
    var direct: direction = .toTop
    var timer = Timer()
    
    var isAuthorized = Bool()
    
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var tenantLabel: UILabel!
    
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var viewEntering: UIView!
    @IBOutlet weak var enterButton: UIButton!
    
    @IBAction func enter(_ sender: Any) {
        defaults.removeObject(forKey: "documents")
        
        uuid = UUID().uuidString
        //request.authorize(uuid: uuid)
        request.authorize(uuid: "1111")
        NotificationCenter.default.addObserver(self, selector: #selector(urlComplete(notification:)), name: urlNot, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoading.layer.masksToBounds = false
        viewLoading.layer.shadowColor = UIColor.lightGray.cgColor
        viewLoading.layer.shadowOpacity = 0.8
        viewLoading.layer.shadowOffset = CGSize.zero
        viewLoading.layer.shadowRadius = 10.0
        
        viewEntering.layer.masksToBounds = false
        viewEntering.layer.shadowColor = UIColor.lightGray.cgColor
        viewEntering.layer.shadowOpacity = 0.8
        viewEntering.layer.shadowOffset = CGSize.zero
        viewEntering.layer.shadowRadius = 10.0
        
        enterButton.setBackgroundImage(#imageLiteral(resourceName: "lilka"), for: .highlighted)
        
        backgroundImage.frame.size = CGSize(width: backgroundImage.frame.width, height: backgroundImage.frame.height*2.5)
        
        timer = Timer.scheduledTimer(timeInterval: 3.1, target: self, selector: #selector(animateBack), userInfo: nil, repeats: true)
        timer.fire()
        
        isAuthorized = defaults.bool(forKey: "isAuthorized")
        if isAuthorized {
            
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 1, animations: {
                    self.backgroundImage.alpha = 0.3
                    self.viewEntering.alpha = 1
                })
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func urlComplete(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, String> {
            if userInfo["error"] != "nil" {
                let ac = UIAlertController.init(title: nil, message: "Ошибка при обработке запроса: \(userInfo["error"]!)\nДавай еще разок?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ОК", style: .default, handler: { (_) in
                    self.uuid = UUID().uuidString
                    //self.request.authorize(uuid: self.uuid)
                    self.request.authorize(uuid: "1111")
                }))
                ac.addAction(UIAlertAction(title: "Отмена", style: .default, handler: { (_) in
                    
                }))
                present(ac, animated: true)
            }
            else {
                NotificationCenter.default.removeObserver(self, name: urlNot, object: nil)
                
                let urlString = userInfo["response"]
                print(urlString!)
                
                if let url = URL(string: urlString!) {
                    let vc = SFSafariViewController(url: url)
                    vc.delegate = self
                    vc.title = "Авторизация"
                    
                    if var topController = UIApplication.shared.keyWindow?.rootViewController {
                        while let presentedViewController = topController.presentedViewController {
                            topController = presentedViewController
                            topController.title = "Авторизация"
                        }
                        
                        topController.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        viewEntering.alpha = 0
        request.testCheckAuth()
        NotificationCenter.default.addObserver(self, selector: #selector(authComplete(notification:)), name: authNot, object: nil)
    }
    
    @objc func authComplete(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, String> {
            if userInfo["error"] != "nil" {
                let ac = UIAlertController.init(title: nil, message: "Ошибка при обработке запроса: \(userInfo["error"]!)\nДавай еще разок?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ОК", style: .default, handler: { (_) in
                    self.request.testCheckAuth()
                }))
                ac.addAction(UIAlertAction(title: "Отмена", style: .default, handler: { (_) in
                    UIView.animate(withDuration: 1, animations: {
                        self.backgroundImage.alpha = 0.3
                        self.viewEntering.alpha = 1
                    })
                }))
                present(ac, animated: true)
            }
            else {
                let authCode = userInfo["response"]
                print(authCode!)
                
                if authCode == "2" {
                    let ac = UIAlertController.init(title: nil, message: "Авторизация прошла успешно", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "ОК", style: .default, handler: { (_) in
                        NotificationCenter.default.removeObserver(self, name: self.authNot, object: nil)
                        
                        self.updateProgress("")
                        //request.getSecurityToken(type: "entity", inn: "7710044140", snilsOgrn: "1027700251754")
                        self.request.getContractsFromBack()
                        //NotificationCenter.default.addObserver(self, selector: #selector(self.tokenComplete(notification:)), name: self.tokenNot, object: nil)
                        
                        NotificationCenter.default.addObserver(self, selector: #selector(self.docComplete(notification:)), name: self.docNot, object: nil)
                        NotificationCenter.default.addObserver(self, selector: #selector(self.payComplete(notification:)), name: self.payNot, object: nil)
                    }))
                    present(ac, animated: true)
                }
                else {
                    request.testCheckAuth()
                }
            }
        }
    }
    
//    @objc func tokenComplete(notification: Notification) {
//        if let userInfo = notification.userInfo as? Dictionary<String, String> {
//            if userInfo["error"] != "nil" {
//                //print(userInfo["error"]!)
//            }
//            else {
//                updateProgress("token")
//
//                NotificationCenter.default.removeObserver(self, name: tokenNot, object: nil)
//
//                let token = userInfo["response"]!
//                request.getContracts(token: token)
//
//                NotificationCenter.default.addObserver(self, selector: #selector(docComplete(notification:)), name: docNot, object: nil)
//                NotificationCenter.default.addObserver(self, selector: #selector(payComplete(notification:)), name: payNot, object: nil)
//            }
//        }
//    }
    
    @objc func docComplete(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, String> {
            if userInfo["error"] != "nil" {
                print(userInfo["error"]!)
                let ac = UIAlertController(title: "", message: "Ошибка при обработке запроса", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { (_) in
                    self.request.getContractsFromBack()
                }))
                ac.addAction(UIAlertAction(title: "Отмена", style: .default, handler: { (_) in
                    if self.isAuthorized {
                        let acSaved = UIAlertController(title: "", message: "Войти с последними сохраненными данными?", preferredStyle: .alert)
                        acSaved.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                            // Войти с сохранением
                        }))
                        acSaved.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in
                            self.reset()
                        }))
                        self.present(acSaved, animated: true)
                    }
                    else {
                        
                    }
                }))
                present(ac, animated: true)
            }
            else {
                updateProgress("documents")
                
                NotificationCenter.default.removeObserver(self, name: docNot, object: nil)
//                numberOfDocuments = Int(userInfo["response"]!)!
//                print("count: \(numberOfDocuments)")
            }
        }
    }
    
    @objc func payComplete(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, String> {
            numberOfPays += 1
            print(numberOfPays)
            
            updateProgress("pay")
            
            if userInfo["error"] != "nil" {
                print(userInfo["error"]!)
            }
            else {
                if numberOfPays == numberOfDocuments {
                    NotificationCenter.default.removeObserver(self, name: payNot, object: nil)
                    
                    timer.invalidate()
                    performSegue(withIdentifier: "loginComplete", sender: self)
                }
                else {
                }
            }
        }
    }
    
    func updateProgress(_ divideBy: String) {
        viewLoading.isHidden = false
        viewLoading.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        
        switch divideBy {
        case "pay":
            progress.progress += 0.8/Float(numberOfDocuments)//*numberOfPays)
        default:
            progress.progress += 0.1
        }
        progress.setProgress(progress.progress, animated: true)
        progressLabel.text = "Загрузка \(Int(progress.progress*100))%"
    }
    
    func reset() {
        progress.setProgress(0, animated: false)
        progress.isHidden = true
        
    }
    
    // Анимация герба
    @objc func animateBack() {
        switch direct {
        case .toTop:
            UIView.animate(withDuration: 3.0, delay: 0, options: .curveEaseInOut , animations: {
                self.backgroundImage.frame.origin.y = self.frontImage.frame.height - self.backgroundImage.frame.height
            }) { (true) in
                self.direct = .toBottom
            }
        default:
            UIView.animate(withDuration: 3.0, delay: 0, options: .curveEaseInOut , animations: {
                self.backgroundImage.frame.origin.y = 0
            }) { (true) in
                self.direct = .toTop
            }
        }
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
