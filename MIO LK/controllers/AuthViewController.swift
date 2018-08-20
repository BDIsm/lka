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
    private let authViaInnNot = NSNotification.Name("authViaInn")
    private let urlNot = NSNotification.Name("url")
    
    let request = classRequest()
    
    @IBOutlet weak var content: UIView!
    
    @IBOutlet weak var formView: authView!
    @IBOutlet weak var esiaView: authView!
    @IBOutlet weak var lawView: authView!
    
    @IBOutlet weak var innField: UITextField!
    @IBOutlet weak var snilsField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var esiaButton: UIButton!
    @IBOutlet weak var lawButton: UIButton!
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    @IBAction func authViaInn(_ sender: UIButton) {
        innField.resignFirstResponder()
        snilsField.resignFirstResponder()
        
        let snils = snilsField.text!
        
        if innField.text?.count == 12 {
            if snils.count == 11 {
                uuid = UUID().uuidString
                request.authorizeWithInn(uuid: uuid, inn: innField.text!, snils: snils)
                
                NotificationCenter.default.addObserver(self, selector: #selector(authComplete(notification:)), name: authViaInnNot, object: nil)
                
                startIndicator(view: formView)
            }
            else {
                let ac = UIAlertController(title: "", message: "Введите корректный СНИЛС", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    self.snilsField.becomeFirstResponder()
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
    
    @IBAction func authViaEsia(_ sender: UIButton) {
        innField.resignFirstResponder()
        snilsField.resignFirstResponder()
        
        startIndicator(view: esiaView)
        
        uuid = UUID().uuidString
        request.authorize(uuid: uuid)
        
        NotificationCenter.default.addObserver(self, selector: #selector(initComplete(notification:)), name: urlNot, object: nil)
    }
    
    @IBAction func authAsALaw(_ sender: UIButton) {
        innField.resignFirstResponder()
        snilsField.resignFirstResponder()
        
        startIndicator(view: lawView)
        
        uuid = UUID().uuidString
        request.authorize(uuid: uuid)
        
        NotificationCenter.default.addObserver(self, selector: #selector(initComplete(notification:)), name: urlNot, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadWebView(_ myURL: URL) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "webView") as! WebViewController
        self.addChildViewController(controller)
        
        // Настройка контроллера
        self.view.addSubview(controller.view)
        controller.setUp(myURL)
        
        controller.didMove(toParentViewController: self)
    }
    
    
    // Авторизация через ввод данных в форму
    @objc func authComplete(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, String> {
            if userInfo["error"] != "nil" {
                let ac = UIAlertController.init(title: nil, message: "Ошибка при обработке запроса: \(userInfo["error"]!)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { (_) in
                    if notification.name == self.authViaInnNot {
                        self.request.authorizeWithInn(uuid: self.uuid, inn: self.innField.text!, snils: self.snilsField.text!)
                    }
                    else if notification.name == self.authViaEsiaNot {
                        self.request.checkAuth(self.uuid)
                    }
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
                    let ac = UIAlertController.init(title: nil, message: "Не удалось найти пользователя", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "ОК", style: .default, handler: { (_) in
                        // Введен несуществующий пользователь
                        self.stopIndicator()
                    }))
                    present(ac, animated: true)
                }
                
                if notification.name == authViaInnNot {
                    NotificationCenter.default.removeObserver(self, name: self.authViaInnNot, object: nil)
                }
                else if notification.name == authViaEsiaNot {
                    NotificationCenter.default.removeObserver(self, name: self.authViaEsiaNot, object: nil)
                }
            }
        }
    }
    
    // Авторизация через ЕСИА
    @objc func initComplete(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, String> {
            // #1 -> Error
            if userInfo["error"] != "nil" {
                let ac = UIAlertController.init(title: nil, message: "Ошибка при обработке запроса: \(userInfo["error"]!)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ОК", style: .default, handler: { (_) in
                    self.stopIndicator()
                }))
                present(ac, animated: true)
            }
            // #1 -> Web-browser
            else {
                let urlString = userInfo["response"]
                if let url = URL(string: urlString!) {
                    DispatchQueue.main.async {
                        self.loadWebView(url)
                    }
                    //let vc = SFSafariViewController(url: url)
                    //vc.delegate = self
                    //vc.title = "Авторизация"
                    //present(vc, animated: true)
                }
                NotificationCenter.default.removeObserver(self, name: urlNot, object: nil)
            }
        }
    }
    
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        request.checkAuth(uuid)
        NotificationCenter.default.addObserver(self, selector: #selector(authComplete(notification:)), name: authViaEsiaNot, object: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text! as NSString
        let replaceString = text.replacingCharacters(in: range, with: string) as NSString
        
        if textField == snilsField {
            return replaceString.length <= 11
        }
        else {
            return replaceString.length <= 12
        }
    }
    
    func addSeparators(text: String) -> String {
        var output = ""
        var count = 0
        for i in text {
            if count == 3 || count == 6 {
                output.append(i)
                output.append("-")
            }
            else {
                output.append(i)
            }
            count += 1
        }
        return output
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        esiaButton.isEnabled = false
        lawButton.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboardEnableButtons), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc func hideKeyboardEnableButtons() {
        esiaButton.isEnabled = true
        lawButton.isEnabled = true
    }
    
    func startIndicator(view: UIView) {
        let xPos = view.bounds.maxX - indicator.frame.width - 5
        let yPos = view.bounds.maxY - indicator.frame.height - 5
        indicator.frame.origin = CGPoint(x: xPos, y: yPos)
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        
        enterButton.isEnabled = false
        esiaButton.isEnabled = false
        lawButton.isEnabled = false
        
        innField.isEnabled = false
        snilsField.isEnabled = false
    }
    
    func stopIndicator() {
        indicator.stopAnimating()
        enterButton.isEnabled = true
        esiaButton.isEnabled = true
        lawButton.isEnabled = true
        
        innField.isEnabled = true
        snilsField.isEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        innField.resignFirstResponder()
        snilsField.resignFirstResponder()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? InitialViewController {
            vc.uuid = uuid
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
