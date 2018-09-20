//
//  InitialViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 29.05.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    let defaults = UserDefaults.standard
    
    var offline = Bool()
    
    public var uuid = String()
    private let request = classRequest()
    private let docNot = NSNotification.Name("documents")
    private let payNot = NSNotification.Name("pay")
    
    var numberOfDocuments: Int = 1
    var numberOfPays = Int()
    
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
        print(uuid)
        
        NotificationCenter.default.addObserver(self, selector: #selector(docComplete(notification:)), name: docNot, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(payComplete(notification:)), name: payNot, object: nil)
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
                            DispatchQueue.main.async {
                                self.offline = true
                                self.performSegue(withIdentifier: "loginComplete", sender: self)
                            }
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
                NotificationCenter.default.removeObserver(self, name: docNot, object: nil)
                numberOfDocuments = Int(userInfo["response"]!)!
                
                DispatchQueue.main.async {
                    if self.numberOfDocuments == 0 {
                        let ac = UIAlertController(title: nil, message: "Нет действующих договоров", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "ОК", style: .default, handler: { (_) in
                            let domain = Bundle.main.bundleIdentifier!
                            self.defaults.removePersistentDomain(forName: domain)
                            self.defaults.synchronize()
                            
                            self.defaults.set(false, forKey: "isAuthorized")
                            self.performSegue(withIdentifier: "noDocuments", sender: self)
                        }))
                        self.present(ac, animated: true)
                    }
                    else {
                        self.updateProgress("base")
                    }
                }
            }
        }
    }
    
    @objc func payComplete(notification: Notification) {
        self.numberOfPays += 1
        DispatchQueue.main.async {
            self.updateProgress("divide")
        }
        
        print(numberOfPays, numberOfDocuments)
        if numberOfPays == numberOfDocuments {
            NotificationCenter.default.removeObserver(self, name: payNot, object: nil)
            
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
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginComplete", sender: self)
            }
        }
    }
    
    func updateProgress(_ divideBy: String) {
        container.isHidden = false
        
        switch divideBy {
        case "divide":
            if numberOfDocuments != 0 {
                progress.progress += 0.9/Float(numberOfDocuments)
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
