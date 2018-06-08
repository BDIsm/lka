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
    
    var documents = [classDocuments]()
    var token = String()
    
    let request = classRequest()
    var paysDone = 0
    
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
        //defaults.removeObject(forKey: "overdue")
        
        getUserData()
        
        //let uuid = UUID().uuidString
        /*
        request.authorize(uuid: uuid) { (true) in
            let urlString = self.defaults.object(forKey: "url") as! String
            if let url = URL(string: urlString) {
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
        }*/
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
        //getUserData()
    }

    func getUserData() {
        //request.getSecurityToken(type: "individual", inn: "507902318711", snilsOgrn: "17248060262") { (true) in
        request.getSecurityToken(type: "entity", inn: "7812014560", snilsOgrn: "1027809169585") { (true) in
        //request.getSecurityToken(type: "entity", inn: "7710044140", snilsOgrn: "1027700251754") { (true) in
            print("successToken")
            self.tenantLabel.text = (self.defaults.object(forKey: "tenant") as! String)
            self.tenantLabel.isHidden = false
            
            self.viewLoading.isHidden = false
            self.progressValue += 0.1
            self.progress.setProgress(self.progressValue, animated: true)
            self.progressLabel.text = "Загрузка данных \(self.progressValue*100)%"
            
            self.request.getContracts(finished: { (true) in
                print("successDocs")
                self.progressValue += 0.1
                self.progress.setProgress(self.progressValue, animated: true)
                self.progressLabel.text = "Загрузка данных \(self.progressValue*100)%"
                
                if let savedDocs = self.defaults.object(forKey: "documents") as? Data {
                    self.documents = NSKeyedUnarchiver.unarchiveObject(with: savedDocs) as! [classDocuments]
                }
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.errorInPay), name: NSNotification.Name("pay"), object: nil)
                
                for i in self.documents {
                    self.request.getPayments(id: i.id)
                }
            })
        }
    }
    
    @objc func errorInPay() {
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
