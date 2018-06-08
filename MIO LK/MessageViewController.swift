//
//  MessageViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 06.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    
    @IBOutlet weak var messView: UIView!
    @IBOutlet weak var messageField: UITextView!
    // Размеры для лейблов
    var leftFrame = CGRect()
    var rightFrame = CGRect()
    
    var new = Bool()
    // Приветствие
    var greeting = messageView()
    // Кнопки выбора категории
    var techButt = buttonView()
    var contractButt = buttonView()
    // Коллекция договоров
    var collection = collectionDoc()
    
    var tapGesture = UITapGestureRecognizer()
    
    enum state: Int {
        case initial
        case techIsChosen
        case questionIsChosen
        case docIsChosen
        case oldChat
    }
    var stateChange: state = .initial
    
    @IBAction func send(_ sender: UIButton) {
        var str = messageField.text!
        str = str.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if str == "" {
        }
        else {
            if new {
                techButt.isEnabled = false
                contractButt.isEnabled = false
                
                collection.selectionDisable()
            }
            else {
                
            }
            
            let mess = messageView(frame: rightFrame, text: str, width: rightFrame.width)
            
            let xPosition = rightFrame.maxX - mess.frame.width
            mess.frame.origin = CGPoint(x: xPosition, y: contentView.bounds.maxY + 4.0)
            
            align(message: mess)
            messageField.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Открытие/закрытие клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        messageField.layer.cornerRadius = 10
        scroll.layer.masksToBounds = false
        contentView.layer.masksToBounds = false
        
        leftFrame = leftLabel.frame
        rightFrame = rightLabel.frame
        
        contentView.frame = CGRect(x: 0, y: scroll.bounds.maxY, width: scroll.frame.width, height: 0)
        
        if new {
            addGreeting()
            addButtons()
        }
        else {
            stateChange = .oldChat
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 1. Добавление приветствия
    func addGreeting() {
        let text = "Добрый день!\nПрежде чем написать нам свою хрень, пожалуйста, выберите категорию или засуньте палец себе поглубже в задницу, вы – потные драные тролли!"
        
        greeting = messageView(frame: leftFrame, text: text, width: leftFrame.width)
        greeting.frame.origin = CGPoint(x: 8, y: 8)
        
        let heightAdd = greeting.frame.height+16
        contentView.frame.size.height += heightAdd
        contentView.frame.origin.y -= heightAdd

        contentView.addSubview(greeting)
    }
    
    // 2. Добавление кнопок
    func addButtons() {
        let size = CGSize(width: greeting.frame.width/2-2, height: 50)
        
        let originOne = CGPoint(x: 8, y: greeting.frame.height+16)
        techButt = buttonView(frame: CGRect(origin: originOne, size: size), title: "Тех. поддержка")
        techButt.addTarget(self, action: #selector(technical), for: .touchUpInside)
        
        let originTwo = CGPoint(x: techButt.frame.width+12, y: greeting.frame.height+16)
        contractButt = buttonView(frame: CGRect(origin: originTwo, size: size), title: "Вопрос по договору")
        contractButt.addTarget(self, action: #selector(contractsShow), for: .touchUpInside)
        
        let heightAdd = techButt.frame.height+8
        contentView.frame.size.height += heightAdd
        contentView.frame.origin.y -= heightAdd
        
        contentView.addSubview(techButt)
        contentView.addSubview(contractButt)
    }
    
    // 2.1 Вопрос тех. поддержки
    @objc func technical() {
        messageField.resignFirstResponder()
        stateChange = .techIsChosen
        techButt.isEnabled = false
        
        // Если закрыты договоры
        if contractButt.isEnabled {
        }
        // Если открыты договоры
        else {
            contractButt.isEnabled = true
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.collection.alpha = 0
                
                // Смещение contentView
                let heightAdd = self.collection.frame.height+8
                self.contentView.frame.size.height -= heightAdd
                self.contentView.frame.origin.y += heightAdd
            }) { (true) in
                // Удаление subview
                self.collection.remove()
                self.collection.removeFromSuperview()
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name("isChosen"), object: nil)
            }
        }
        
        messageField.becomeFirstResponder()
    }
    
    // 2.2 Вопрос по договору
    @objc func contractsShow() {
        messageField.resignFirstResponder()
        stateChange = .questionIsChosen
        contractButt.isEnabled = false
        
        collection.frame = CGRect(x: 8, y: techButt.frame.maxY+8, width: scroll.frame.width-16, height: 150)
        collection.alpha = 0
        // Создание collectionView
        self.collection.collection(cellWidth: self.greeting.frame.width)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.collection.alpha = 1
            
            let heightAdd = self.collection.frame.height+8
            self.contentView.frame.size.height += heightAdd
            self.contentView.frame.origin.y -= heightAdd
        }) { (true) in
            NotificationCenter.default.addObserver(self, selector: #selector(self.docIsChosen(notification:)), name: NSNotification.Name("isChosen"), object: nil)
        }
        
        if !techButt.isEnabled {
            techButt.isEnabled = true
        }
        
        contentView.addSubview(collection)
    }
    
    // 2.2.1 Пользователь выбрал документ
    @objc func docIsChosen(notification: Notification) {
        stateChange = .docIsChosen
        messageField.becomeFirstResponder()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        switch stateChange {
        case .questionIsChosen:
            let ac = UIAlertController(title: nil, message: "Выберите договор", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
            return false
        case .initial:
            let ac = UIAlertController(title: nil, message: "Выберите категорию", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
            return false
        default:
            return true
        }
    }
    
    
    // Добавление сообщения, перемещение contentView
    func align(message: UIView) {
        let heightAdd = message.frame.height + 8.0
        
        if contentView.frame.height + heightAdd > scroll.frame.height {
            scroll.contentSize.height = contentView.frame.height + heightAdd
            contentView.frame.size.height += heightAdd
            contentView.frame.origin.y = 0
            
            let offset = CGPoint(x: 0, y: contentView.frame.maxY - scroll.bounds.height)
            scroll.setContentOffset(offset, animated: true)
        }
        else {
            contentView.frame.size.height += heightAdd
            contentView.frame.origin.y -= heightAdd
        }
        
        contentView.addSubview(message)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
            view.addGestureRecognizer(tapGesture)
            
            self.contentView.frame.origin.y -= keyboardSize.height
            self.messView.frame.origin.y -= keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("HIDE ME!")
            view.removeGestureRecognizer(tapGesture)
            self.contentView.frame.origin.y += keyboardSize.height
            self.messView.frame.origin.y += keyboardSize.height
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
