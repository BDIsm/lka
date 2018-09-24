//
//  AuthViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 31.07.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit
import SafariServices
import WebKit

class AuthViewController: UIViewController, UITextFieldDelegate, SFSafariViewControllerDelegate {
    let defaults = UserDefaults.standard
    
    private var uuid = String()
    
    private let authViaEsiaNot = NSNotification.Name("authViaEsia")
    private let wkDismissNot = NSNotification.Name("wkDismiss")
    private let urlNot = NSNotification.Name("url")
    
    let request = classRequest()
    
    @IBOutlet weak var content: UIView!
    
    @IBOutlet weak var esiaView: authView!
    @IBOutlet weak var esiaButton: UIButton!
    
    let bgView = UIView()
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    @IBAction func authViaEsia(_ sender: UIButton) {
        startIndicator(view: esiaView)
        
        uuid = UUID().uuidString
        request.authorize(uuid: uuid)
        
        NotificationCenter.default.addObserver(self, selector: #selector(initComplete(notification:)), name: urlNot, object: nil)
    }
    
    var statusStyleLight = Bool()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusStyleLight ? .lightContent : .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Авторизация через ЕСИА
    @objc func initComplete(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, String> {
            // #1 -> Error
            if userInfo["error"] != "nil" {
                print(userInfo["error"]!)
                let ac = UIAlertController.init(title: nil, message: "Проблема соединения с сервером", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ОК", style: .default, handler: { (_) in
                    self.stopIndicator()
                }))
                present(ac, animated: true)
            }
            // #2 -> Web-browser
            else {
                let urlString = userInfo["response"]
                if let url = URL(string: urlString!) {
                    DispatchQueue.main.async {
                        self.loadWebView(url)
                    }
                }
                NotificationCenter.default.removeObserver(self, name: urlNot, object: nil)
            }
        }
    }
    
    func loadWebView(_ myURL: URL) {
        bgView.frame = self.view.bounds
        bgView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.view.addSubview(bgView)
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "webView") as! WebViewController
        self.addChildViewController(controller)
       
        self.statusStyleLight = true
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.view.addSubview(controller.view)
        
        controller.mosregURL = myURL
        controller.didMove(toParentViewController: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(wkDismiss), name: wkDismissNot, object: nil)
    }
    
    @objc func wkDismiss(notification: Notification) {
        bgView.removeFromSuperview()
        
        if let userInfo = notification.userInfo as? Dictionary<String, Bool> {
            if userInfo["authCheck"]! {
                request.checkAuth(uuid)
                NotificationCenter.default.addObserver(self, selector: #selector(authComplete(notification:)), name: authViaEsiaNot, object: nil)
            }
            else {
                self.stopIndicator()
            }
        }
    }
    
    // Авторизация через ввод данных в форму
    @objc func authComplete(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, String> {
            if userInfo["error"] != "nil" {
                print(userInfo["error"]!)
                let ac = UIAlertController.init(title: nil, message: "Ошибка при обработке запроса", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { (_) in
                    self.request.checkAuth(self.uuid)
                }))
                ac.addAction(UIAlertAction(title: "Отмена", style: .default, handler: { (_) in
                    // Если не прошел запрос и нажата Отмена
                    self.stopIndicator()
                }))
                present(ac, animated: true)
            }
            else {
                let authCode = userInfo["response"]
                print(authCode!+" – authCode")
                
                // -> Loading Docs
                if authCode == "2" {
                    // Авторизация прошла успешно
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "goToDownload", sender: self)
                    }
                }
                // –> User not found
                else {
                    let ac = UIAlertController.init(title: nil, message: "Авторизация прервана", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "ОК", style: .default, handler: { (_) in
                        // Введен несуществующий пользователь
                        self.stopIndicator()
                    }))
                    present(ac, animated: true)
                }
                NotificationCenter.default.removeObserver(self, name: self.authViaEsiaNot, object: nil)
            }
        }
    }
    
    func startIndicator(view: UIView) {
        let xPos = view.bounds.maxX - indicator.frame.width - 5
        let yPos = view.bounds.maxY - indicator.frame.height - 5
        indicator.frame.origin = CGPoint(x: xPos, y: yPos)
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        
        esiaButton.isEnabled = false
    }
    
    func stopIndicator() {
        indicator.stopAnimating()
        esiaButton.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? InitialViewController {
            vc.uuid = uuid
        }
    }
}
