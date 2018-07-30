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
    @IBOutlet weak var esiaEnter: UIView!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var innField: UITextField!
    @IBOutlet weak var ogrnField: UITextField!
    @IBOutlet weak var formCheckEnter: UIButton!
    
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var blurIndicator: UIVisualEffectView!
    
    @IBAction func sendInn(_ sender: UIButton) {
        if innField.text?.count == 10 {
            if ogrnField.text?.count == 13 {
                uuid = UUID().uuidString
                request.authorize(uuid: uuid)
            }
            else {
                let ac = UIAlertController(title: "", message: "Введите корректный ОГРН", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    self.ogrnField.becomeFirstResponder()
                }))
                present(ac, animated: true)
            }
        }
        else {
            let ac = UIAlertController(title: "", message: "Введите корректный ИНН", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.innField.becomeFirstResponder()
            }))
            present(ac, animated: true)
        }
    }
    
    @IBAction func enter(_ sender: Any) {
        blurIndicator.isHidden = false
        enterButton.isEnabled = false
        
        uuid = UUID().uuidString
        request.authorize(uuid: uuid)

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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text! as NSString
        let replaceString = text.replacingCharacters(in: range, with: string) as NSString
    
        switch textField {
        case innField:
            return replaceString.length <= 10
        default:
            return replaceString.length <= 13
        }
    }
    
    @objc func urlComplete(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, String> {
            // #1 -> Error
            if userInfo["error"] != "nil" {
                let ac = UIAlertController.init(title: nil, message: "Ошибка при обработке запроса: \(userInfo["error"]!)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ОК", style: .default, handler: { (_) in
                    self.resetToEnterState()
                }))
                present(ac, animated: true)
            }
            // #1 -> Web-browser
            else if userInfo["server"] == "0" {
                let urlString = userInfo["response"]
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
                NotificationCenter.default.removeObserver(self, name: urlNot, object: nil)
            }
            // #1 -> formView
            else {
                blurIndicator.isHidden = true
                formView.center.x = esiaEnter.center.x + formView.frame.width
                formView.isHidden = false
                
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    self.esiaEnter.center.x -= self.esiaEnter.frame.width
                    self.formView.center.x -= self.formView.frame.width
                }) { (_) in
                    
                }
            }
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        request.checkAuth(uuid)
        NotificationCenter.default.addObserver(self, selector: #selector(authComplete(notification:)), name: authNot, object: nil)
    }
    
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        print(URL.absoluteString)
    }
    
    @objc func authComplete(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, String> {
            // #2 –> Error
            if userInfo["error"] != "nil" {
                let ac = UIAlertController.init(title: nil, message: "Ошибка при обработке запроса: \(userInfo["error"]!)\nДавай еще разок?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ОК", style: .default, handler: { (_) in
                    self.request.checkAuth(self.uuid)
                }))
                ac.addAction(UIAlertAction(title: "Отмена", style: .default, handler: { (_) in
                    self.resetToEnterState()
                }))
                present(ac, animated: true)
            }
            else {
                let authCode = userInfo["response"]
                print(authCode!+" – authCode")
                
                // #2 -> Loading Docs
                if authCode == "2"  {
                    viewEntering.isHidden = true
                    updateProgress("start")
                    
                    request.getContractsFromBack()
                    NotificationCenter.default.addObserver(self, selector: #selector(self.docComplete(notification:)), name: self.docNot, object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.payComplete(notification:)), name: self.payNot, object: nil)
                    print("Авторизация прошла успешно")
                }
                // #2 –> User not found
                else {
                    let ac = UIAlertController.init(title: nil, message: "Не удалось найти пользователя", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "ОК", style: .default, handler: { (_) in
                        self.resetToEnterState()
                    }))
                    present(ac, animated: true)
                }
                NotificationCenter.default.removeObserver(self, name: self.authNot, object: nil)
            }
        }
    }
    
    @objc func docComplete(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, String> {
            if userInfo["error"] != "nil" {
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
                
                updateProgress("documents")
            }
        }
    }
    
    @objc func payComplete(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, String> {
            numberOfPays += 1
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
            if numberOfDocuments != 0 {
                progress.progress += 0.8/Float(numberOfDocuments)
            }
        case "documents":
            progress.progress += 0.1
        default: break
        }
        
        progress.setProgress(progress.progress, animated: true)
        progressLabel.text = "Загрузка \(Int(progress.progress*100))%"
    }
    
    func resetToEnterState() {
        viewEntering.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        viewEntering.isHidden = false
        esiaEnter.center = viewEntering.center
        esiaEnter.isHidden = false
        enterButton.isEnabled = true
        blurIndicator.isHidden = true
        formView.isHidden = true
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        innField.resignFirstResponder()
        ogrnField.resignFirstResponder()
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
