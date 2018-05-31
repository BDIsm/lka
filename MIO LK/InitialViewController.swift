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
    
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var tenantLabel: UILabel!
    
    @IBAction func enter(_ sender: Any) {
        getUserData()
        
        let uuid = UUID().uuidString
        
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
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        getUserData()
    }

    func getUserData() {
        request.getSecurityToken(type: "entity", inn: "7710044140", snilsOgrn: "1027700251754") { (true) in
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
        self.progressValue += 0.8/97//Float(docs.count)
        self.progress.setProgress(self.progressValue, animated: true)
        self.progressLabel.text = "Загрузка данных \(self.progressValue*100)%"
        
        self.paysDone += 1
        
        if self.paysDone == documents.count {
            self.progress.setProgress(Float(100), animated: true)
            self.progressLabel.text = "Загрузка данных 100%"
            print("That's all!")
            
            performSegue(withIdentifier: "loginComplete", sender: self)
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
