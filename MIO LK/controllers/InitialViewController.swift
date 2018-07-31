//
//  InitialViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 29.05.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit
import SafariServices

class InitialViewController: UIViewController, URLSessionDataDelegate, SFSafariViewControllerDelegate, UITextFieldDelegate {
    let defaults = UserDefaults.standard
    
    public var uuid = String()
    private let request = classRequest()
    private let docNot = NSNotification.Name("documents")
    private let payNot = NSNotification.Name("pay")
    
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
    
    @IBOutlet weak var viewLoading: authView!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage.frame.size = CGSize(width: backgroundImage.frame.width, height: backgroundImage.frame.height*2.5)
        
        timer = Timer.scheduledTimer(timeInterval: 3.1, target: self, selector: #selector(animateBack), userInfo: nil, repeats: true)
        timer.fire()
        
        if defaults.bool(forKey: "isAuthorized") {
            uuid = defaults.object(forKey: "uuid") as! String
        }
        request.getContractsFromBack(uuid)
        print(uuid)
        
        updateProgress("start")
        
        NotificationCenter.default.addObserver(self, selector: #selector(docComplete(notification:)), name: docNot, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(payComplete(notification:)), name: payNot, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func docComplete(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, String> {
            if userInfo["error"] != "nil" {
                let ac = UIAlertController(title: "", message: "Ошибка при обработке запроса \(userInfo["error"]!)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { (_) in
                    self.request.getContractsFromBack(self.uuid)
                }))
                ac.addAction(UIAlertAction(title: "Отмена", style: .default, handler: { (_) in
                    if self.defaults.bool(forKey: "isAuthorized") {
                        let acSaved = UIAlertController(title: "", message: "Войти с последними сохраненными данными?", preferredStyle: .alert)
                        acSaved.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                            // Войти с сохранением
                        }))
                        acSaved.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in
                            
                        }))
                        self.present(acSaved, animated: true)
                    }
                    else {
                        
                    }
                }))
                present(ac, animated: true)
            }
            else {
                NotificationCenter.default.removeObserver(self, name: docNot, object: nil)
                numberOfDocuments = Int(userInfo["response"]!)!
                
                DispatchQueue.main.async {
                    self.updateProgress("documents")
                }
            }
        }
    }
    
    @objc func payComplete(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, String> {
            numberOfPays += 1
            
            DispatchQueue.main.async {
                self.updateProgress("pay")
            }
            
            if userInfo["error"] != "nil" {
                print(userInfo["error"]!)
            }
            else {
                if numberOfPays == numberOfDocuments {
                    NotificationCenter.default.removeObserver(self, name: payNot, object: nil)
                    
                    timer.invalidate()
                    
                    if !defaults.bool(forKey: "isAuthorized") {
                        defaults.set(true, forKey: "isAuthorized")
                        defaults.set(uuid, forKey: "uuid")
                    }
                    
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
            if numberOfDocuments != 0 {
                progress.progress += 0.9/Float(numberOfDocuments)
            }
        case "documents":
            progress.progress += 0.1
        default: break
        }
        
        progress.setProgress(progress.progress, animated: true)
        progressLabel.text = "Загрузка \(Int(progress.progress*100))%"
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
