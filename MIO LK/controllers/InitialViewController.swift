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
    
    var offline = Bool()
    
    public var uuid = String()
    private let request = classRequest()
    private let docNot = NSNotification.Name("documents")
    private let payNot = NSNotification.Name("pay")
    private let chatNot = NSNotification.Name("chat")
    private let chatMNot = NSNotification.Name("chatM")
    
    var numberOfDocuments: Int = 1
    var numberOfPays = Int()
    
    var numberOfChats = Int()
    var numberOfChatM = Int()
    
    @IBOutlet weak var viewLoading: authView!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var container: UIView!

    @IBOutlet weak var reload: UIButton!
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBAction func reloadTapped(_ sender: UIButton) {
        loadDocs()
        reload.isHidden = true
        repeatLabel.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.bool(forKey: "isAuthorized") {
            uuid = defaults.object(forKey: "uuid") as! String
        }
        loadDocs()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDocs() {
        updateProgress("start")
        
        request.getContractsFromBack(uuid)
        request.getChatsFromBack(uuid, active: 1)
        print(uuid)
        
        NotificationCenter.default.addObserver(self, selector: #selector(docComplete(notification:)), name: docNot, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(payComplete(notification:)), name: payNot, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(docComplete(notification:)), name: chatNot, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(payComplete(notification:)), name: chatMNot, object: nil)
    }
    
    @objc func docComplete(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, String> {
            if userInfo["error"] != "nil" {
                let ac = UIAlertController(title: "", message: "Ошибка при обработке запроса \(userInfo["error"]!)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { (_) in
                    if notification.name == self.docNot {
                        self.request.getContractsFromBack(self.uuid)
                    }
                    else {
                        self.request.getChatsFromBack(self.uuid, active: 1)
                    }
                }))
                ac.addAction(UIAlertAction(title: "Отмена", style: .default, handler: { (_) in
                    if self.defaults.bool(forKey: "isAuthorized") {
                        let acSaved = UIAlertController(title: "", message: "Войти с последними сохраненными данными?", preferredStyle: .alert)
                        acSaved.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                            // Войти с сохранением
                            self.offline = true
                            self.performSegue(withIdentifier: "loginComplete", sender: self)
                        }))
                        acSaved.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in
                            self.container.isHidden = true
                            self.reload.isHidden = false
                            self.repeatLabel.isHidden = false
                        }))
                        self.present(acSaved, animated: true)
                    }
                    else {
                        self.container.isHidden = true
                        self.reload.isHidden = false
                        self.repeatLabel.isHidden = false
                    }
                }))
                present(ac, animated: true)
            }
            else {
                if notification.name == docNot {
                    NotificationCenter.default.removeObserver(self, name: docNot, object: nil)
                    numberOfDocuments = Int(userInfo["response"]!)!
                    print(numberOfDocuments, "LOLOLO")
                    
                    DispatchQueue.main.async {
                        self.updateProgress("base")
                    }
                }
                else {
                    NotificationCenter.default.removeObserver(self, name: chatNot, object: nil)
                    numberOfChats = Int(userInfo["response"]!)!
                    
                    DispatchQueue.main.async {
                        self.updateProgress("base")
                    }
                }
            }
        }
    }
    
    @objc func payComplete(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, String> {
            if notification.name == payNot {
                self.numberOfPays += 1
                DispatchQueue.main.async {
                    self.updateProgress("divide")
                }
            }
            else {
                self.numberOfChatM += 1
                DispatchQueue.main.async {
                    self.updateProgress("divide")
                }
            }
            
            if userInfo["error"] != "nil" {
                print(userInfo["error"]!)
            }
            else {
                if numberOfPays == numberOfDocuments {
                    NotificationCenter.default.removeObserver(self, name: payNot, object: nil)
                    NotificationCenter.default.removeObserver(self, name: chatMNot, object: nil)
                    
                    if !defaults.bool(forKey: "isAuthorized") {
                        defaults.set(true, forKey: "isAuthorized")
                        defaults.set(uuid, forKey: "uuid")
                    }
                    
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .short
                    let dateString = dateFormatter.string(from: date)
                    
                    let calendar = NSCalendar.current
                    let hour = calendar.component(.hour, from: date)
                    let minutes = calendar.component(.minute, from: date)
                    
                    let actualDateTime = dateString + " \(hour):\(minutes)"
                    defaults.set(actualDateTime, forKey: "actualDate")
                    
                    performSegue(withIdentifier: "loginComplete", sender: self)
                }
            }
        }
    }
    
    func updateProgress(_ divideBy: String) {
        container.isHidden = false
        
        viewLoading.isHidden = false
        viewLoading.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        
        switch divideBy {
        case "divide":
            if numberOfDocuments != 0 {
                progress.progress += 0.8/Float(numberOfDocuments+numberOfChats)
            }
        case "base":
            progress.progress += 0.1
        default: break
        }
        
        progress.setProgress(progress.progress, animated: true)
        progressLabel.text = "Загрузка \(Int(progress.progress*100))%"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TabBarController {
            vc.offline = offline
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
