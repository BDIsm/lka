//
//  ChatViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 06.08.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, messageTextDelegate, chatTypeDelegate {
    let defaults = UserDefaults.standard
    var messages = [classMessages]()
    var documents = [classDocuments]()
    
    var newChat = Bool()
    
    var tapGesture = UITapGestureRecognizer()
    
    var type: chatType = .common
    var cellHeight = CGFloat()
    
    @IBOutlet weak var tableView: UITableView!
    var messTextView = messageTextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messTextView.delegate = self
        messTextView.frame = (self.tabBarController?.tabBar.frame)!
        messTextView.initialize(frame: messTextView.frame)
        self.view.addSubview(messTextView)
        
        tableView.frame.size.height = messTextView.frame.minY-tableView.frame.minY
        
        if newChat {
        }
        else {
            let one = classMessages(date: "15.05.2018", out: "1", id: "1", message: "Добрый день. Возник вопрос по поводу оплаты аренды моего земельного участка")
            let two = classMessages(date: "15.05.2018", out: "1", id: "1", message: "Кому я мог бы его задать?")
            let three = classMessages(date: "15.05.2018", out: "0", id: "1", message: "Добрый день, спасибо за Ваше обращение. ")
            let four = classMessages(date: "15.05.2018", out: "1", id: "1", message: "Отлично, спасибо!")
            
            messages.append(one)
            messages.append(two)
            messages.append(three)
            messages.append(four)
        }
        
        if let savedDocs = defaults.object(forKey: "documents") as? Data {
            documents = NSKeyedUnarchiver.unarchiveObject(with: savedDocs) as! [classDocuments]
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newChat {
            return messages.count+1
        }
        else {
            return messages.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if newChat {
            if indexPath.row == 0 {
                if type == .curator {
                    return 260+cellHeight
                }
                else {
                    return 250
                }
            }
            else {
                let height = MessageViewCell.height(for: messages[indexPath.row-1])
                return height
            }
        }
        else {
            let height = MessageViewCell.height(for: messages[indexPath.row])
            return height
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if newChat {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "greetingCell", for: indexPath) as? greetingTableViewCell else { fatalError() }
                cell.selectionStyle = .none
                
                cell.setUp(documents: documents)
                cell.collectionForDoc.collectionDidLoad(cellWidth: cell.greetingView.frame.width)
                
                cell.delegate = self
                return cell
            } 
            else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageViewCell else { fatalError() }
                cell.selectionStyle = .none
                
                let message = messages[indexPath.row-1]
                cell.apply(message: message)
                
                return cell
            }
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageViewCell else { fatalError() }
            cell.selectionStyle = .none
            
            let message = messages[indexPath.row]
            cell.apply(message: message)
            
            return cell
        }
    }
    
    // Выбран тип вопроса (общий/куратору)
    func tapped(type: chatType, height: CGFloat) {
        tableView.beginUpdates()
        self.type = type
        self.cellHeight = height
        tableView.endUpdates()
    }
    
    // Изменен размер текстового поля
    func heightChanged(height: CGFloat) {
        tableView.frame.origin.y -= height
        if newChat {
            tableView.scrollToRow(at: IndexPath(row: messages.count, section: 0), at: .bottom, animated: true)
        }
        else {
            tableView.scrollToRow(at: IndexPath(row: messages.count-1, section: 0), at: .bottom, animated: true)
        }
    }
    
    func sendWasTapped(message: String) {
        let element = classMessages(date: "", out: "1", id: "1", message: message)
        insertNewMessageCell(element)
    }
    
    func insertNewMessageCell(_ message: classMessages) {
        messages.append(message)
        var indexPath = IndexPath()
        if newChat {
            indexPath = IndexPath(row: messages.count, section: 0)
        }
        else {
            indexPath = IndexPath(row: messages.count - 1, section: 0)
        }
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .bottom)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let height = messTextView.frame.height
            let viewOriginY = keyboardSize.origin.y-height
            
            let tHeight = tableView.frame.height
            let tableOriginY = keyboardSize.origin.y-tHeight-49
            
            UIView.animate(withDuration: 0.25) {
                self.messTextView.frame.origin.y = viewOriginY
                self.tableView.frame.origin.y = tableOriginY
                if self.newChat {
                    self.tableView.scrollToRow(at: IndexPath(row: self.messages.count, section: 0), at: .bottom, animated: true)
                }
                else {
                    self.tableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom, animated: true)
                }
            }
            
            tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
            view.addGestureRecognizer(tapGesture)
        }
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let ac = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
    //        ac.addAction(UIAlertAction(title: "Копировать", style: .default, handler: { (_) in
    //            let element = self.messages[indexPath.row]
    //            UIPasteboard.general.addItems([["copyText": element.message]])
    //        }))
    //        ac.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in
    //            tableView.deselectRow(at: indexPath, animated: true)
    //        }))
    //        present(ac, animated: true)
    //    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

