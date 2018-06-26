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

    private let tokenNot = NSNotification.Name("token")
    private let urlNot = NSNotification.Name("url")
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
    
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var tenantLabel: UILabel!
    
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBAction func enter(_ sender: Any) {
        defaults.removeObject(forKey: "documents")
        
        uuid = UUID().uuidString
        request.authorize(uuid: uuid)
        
        NotificationCenter.default.addObserver(self, selector: #selector(urlComplete(notification:)), name: urlNot, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.frame.size = CGSize(width: backgroundImage.frame.width, height: backgroundImage.frame.height*2.5)
        
        timer = Timer.scheduledTimer(timeInterval: 3.1, target: self, selector: #selector(animateBack), userInfo: nil, repeats: true)
        timer.fire()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        request.getSecurityToken(type: "entity", inn: "7710044140", snilsOgrn: "1027700251754")
        NotificationCenter.default.addObserver(self, selector: #selector(tokenComplete(notification:)), name: tokenNot, object: nil)
    }

    @objc func urlComplete(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, String> {
            if userInfo["error"] != "nil" {
                let ac = UIAlertController.init(title: nil, message: "Ошибка при обработке запроса: \(userInfo["error"]!)\nДавай еще разок?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ОК", style: .default, handler: { (_) in
                    self.uuid = UUID().uuidString
                    self.request.authorize(uuid: self.uuid)
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
    
    @objc func tokenComplete(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, String> {
            if userInfo["error"] != "nil" {
                print(userInfo["error"]!)
            }
            else {
                updateProgress("token")
                
                NotificationCenter.default.removeObserver(self, name: tokenNot, object: nil)
                
                let token = userInfo["response"]!
                request.getContracts(token: token)
                
                NotificationCenter.default.addObserver(self, selector: #selector(docComplete(notification:)), name: docNot, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(payComplete(notification:)), name: payNot, object: nil)
            }
        }
    }
    
    @objc func docComplete(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, String> {
            if userInfo["error"] != "nil" {
                print(userInfo["error"]!)
            }
            else {
                updateProgress("documents")
                
                NotificationCenter.default.removeObserver(self, name: docNot, object: nil)
                
                numberOfDocuments = Int(userInfo["response"]!)!
                print("count: \(numberOfDocuments)")
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
        
        switch divideBy {
        case "pay":
            progress.progress += 0.8/Float(numberOfDocuments)//*numberOfPays)
        default:
            progress.progress += 0.1
        }
        progress.setProgress(progress.progress, animated: true)
        progressLabel.text = "Загрузка \(progress.progress*100)%"
    }
    
    /*@objc func errorInPay() {
        self.progressValue += 0.8/Float(documents.count)
        self.progress.setProgress(self.progressValue, animated: true)
        self.progressLabel.text = "Загрузка данных \(self.progressValue*100)%"
        
        self.paysDone += 1
        
        if self.paysDone == documents.count {
            self.progress.setProgress(Float(100), animated: true)
            self.progressLabel.text = "Загрузка данных 100%"
            print("That's all!")
            
            timer.invalidate()
            performSegue(withIdentifier: "loginComplete", sender: self)
        }
    }*/
    
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
