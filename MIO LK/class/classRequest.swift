//
//  classRequest.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 30.05.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation

class classRequest {
    let defaults = UserDefaults.standard
    
    private let authNot = NSNotification.Name("authViaEsia")
    private let urlNot = NSNotification.Name("url")
    
    private let docNot = NSNotification.Name("documents")
    private let payNot = NSNotification.Name("pay")
    private let chatNot = NSNotification.Name("chat")
    private let chatMNot = NSNotification.Name("chatM")
    
    private let chatInitNot = NSNotification.Name("chatInit")
    
    private var documents = [classDocuments]()
    
    public var allOverdues = [classPayments]()
    public var allActual = [classPayments]()
    public var allPayed = [classPayments]()
    
    public var paymentsDict = [String:[classPayments]]()
    
    private var chats = [classChats]()
    private var messages = [classMessages]()
    
    enum NetworkError: Error {
        case unauthorised
        case timeout
        case serverError
        case invalidResponse
    }
    
    public func authorize(uuid: String) {
        let url = URL(string: "https://mob.razvitie-mo.ru/backend/api/v1/init?uuid=\(uuid)")!
        
        var quest = URLRequest(url: url)
        quest.timeoutInterval = 5.0
        
        let authSession = URLSession.shared.dataTask(with: quest) { (data, response, error) in
            if error != nil {
                NotificationCenter.default.post(name: self.urlNot, object: nil, userInfo: ["error": error!.localizedDescription, "response": "nil"])
            }
            else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let content = data {
                        do {
                            if let myJsonObject = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                                if let esiaUrl = myJsonObject["Url"] as? String {
                                    let serverStatus = myJsonObject["Regim"] as! String
                                    NotificationCenter.default.post(name: self.urlNot, object: nil, userInfo: ["error": "nil", "response": esiaUrl, "server": serverStatus])
                                }
                            }
                        }
                        catch {
                        }
                    }
                }
                else {
                    NotificationCenter.default.post(name: self.urlNot, object: nil, userInfo: ["error": "\(httpResponse.statusCode)", "response": "nil"])
                }
            }
        }
        authSession.resume()
    }
    
    public func checkAuth(_ uuid: String) {
        let url = URL(string: "https://mob.razvitie-mo.ru/backend/api/v1/author?uuid=\(uuid)")
        
        _ = TaskManager.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                NotificationCenter.default.post(name: self.authNot, object: nil, userInfo: ["error": error!.localizedDescription, "response": "nil"])
            }
            else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let content = data {
                        do {
                            if let myJsonObject = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                                if let code = myJsonObject["Code:"] as? String {
                                    NotificationCenter.default.post(name: self.authNot, object: nil, userInfo: ["error": "nil", "response": code])
                                }
                            }
                        }
                        catch {
                        }
                    }
                }
                else {
                    NotificationCenter.default.post(name: self.authNot, object: nil, userInfo: ["error": "\(httpResponse.statusCode)", "response": "nil"])
                }
            }
        }
    }
    
    public func getContractsFromBack(_ uuid: String) {
        let url = URL(string: "https://mob.razvitie-mo.ru/backend/api/v1/lka?uuid=\(uuid)&query=%2FleaseContract%3FsecurityToken%3D%5ftoken%5f%26showClosed%3D0")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 5.0
        print(request)
        
        let newTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                NotificationCenter.default.post(name: self.docNot, object: nil, userInfo: ["error": error!.localizedDescription, "response": "nil"])
            }
            else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let content = data {
                        do {
                            if let myJsonObject = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableDictionary {
                                print(myJsonObject)
                                if let response = myJsonObject["response"] as? NSDictionary {                                    if let items = response["items"] as? NSArray {
                                    for i in 0 ..< items.count {
                                        if let contract = items[i] as? NSDictionary {
                                            var address = String()
                                            if let addresses = contract["addresses"] as? NSArray {
                                                let additional = addresses.firstObject as AnyObject
                                                address = "\(additional)"
                                            }
                                            let use = contract["allowedUseType"] as AnyObject
                                            let date = contract["docDate"] as AnyObject
                                            let number = contract["docNumber"] as AnyObject
                                            let id = contract["id"] as AnyObject
                                            let type = contract["objectType"] as AnyObject
                                            let owner = contract["ownerName"] as AnyObject
                                            let payDate = contract["paymentDate"] as AnyObject
                                            let rent = contract["rentAmount"] as AnyObject
                                            
                                            DispatchQueue.main.async {
                                                self.getPaymentsFromBack(uuid, id: "\(id)")
                                            }
                                            
                                            let element = classDocuments(address: address, use: "\(use)", date: "\(date)", number: "\(number)", id: "\(id)", type: "\(type)", owner: "\(owner)", payDate: "\(payDate)", rent: "\(rent)")
                                            self.documents.append(element)
                                        }
                                    }
                                    }
                                    let savedData = NSKeyedArchiver.archivedData(withRootObject: self.documents)
                                    self.defaults.removeObject(forKey: "documents")
                                    self.defaults.set(savedData, forKey: "documents")
                                    NotificationCenter.default.post(name: self.docNot, object: nil, userInfo: ["error": "nil", "response": "\(self.documents.count)"])
                                }
                            }
                            else {
                                print("fuckIT")
                            }
                        }
                        catch {
                        }
                    }
                }
                else { // Ошибка сервера
                    NotificationCenter.default.post(name: self.docNot, object: nil, userInfo: ["error": "\(httpResponse.statusCode)", "response": "nil"])
                }
            }
        }
        newTask.resume()
    }
    
    public func getPaymentsFromBack(_ uuid: String, id: String) {
        var overdue = [classPayments]()
        var actual = [classPayments]()
        
        let url = URL(string: "https://mob.razvitie-mo.ru/backend/api/v1/lka?uuid=\(uuid)&query=%2FleaseContract%2F\(id)%3FsecurityToken%3D%5ftoken%5f%26payedAccruals%3D1")
        
        let session = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                NotificationCenter.default.post(name: self.payNot, object: nil, userInfo: ["error": error!.localizedDescription, "response": "nil"])
            }
            else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let content = data {
                        do {
                            let myJsonObject = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                            print(myJsonObject)
                                if let response = myJsonObject["response"] as? NSDictionary {
                                    if let accruals = response["accruals"] as? NSArray {
                                        for i in 0 ..< accruals.count {
                                            if let pay = accruals[i] as? NSDictionary {
                                                let accrual = pay["accrualAmount"] as AnyObject
                                                let date = pay["date"] as AnyObject
                                                let idPay = pay["id"] as AnyObject
                                                let payment = pay["paymentAmount"] as AnyObject
                                                let period = pay["period"] as AnyObject
                                                let status = pay["status"] as AnyObject
                                                let type = pay["type"] as AnyObject
                                                
                                                let element = classPayments(id: "\(idPay)", accrual: "\(accrual)", date: "\(date)", payment: "\(payment)", period: "\(period)", status: "\(status)", type: "\(type)", docId: "\(id)")
                                                
                                                switch "\(status)" {
                                                case "Не оплачено (неоплаченное начисление прошлого периода)":
                                                    overdue.append(element)
                                                    self.allOverdues.append(element)
                                                case "Не оплачено (неоплаченное начисление текущего периода)", "Начисление будущих периодов (неоплаченные начисления будущих периодов)":
                                                    actual.append(element)
                                                    self.allActual.append(element)
                                                default:
                                                    self.allPayed.append(element)
                                                }
                                            }
                                        }
                                    }
                                    let savedOverdues = NSKeyedArchiver.archivedData(withRootObject: self.allOverdues)
                                    let savedActual = NSKeyedArchiver.archivedData(withRootObject: self.allActual)
                                    let savedPayed = NSKeyedArchiver.archivedData(withRootObject: self.allPayed)
                                    
                                    self.defaults.removeObject(forKey: "overdue")
                                    self.defaults.set(savedOverdues, forKey: "overdue")
                                    self.defaults.removeObject(forKey: "actual")
                                    self.defaults.set(savedActual, forKey: "actual")
                                    self.defaults.removeObject(forKey: "payed")
                                    self.defaults.set(savedPayed, forKey: "payed")
                                    
                                    self.paymentsDict.updateValue(overdue, forKey: "\(id)Overdue")
                                    self.paymentsDict.updateValue(actual, forKey: "\(id)Actual")
                                    
                                    let savedDict = NSKeyedArchiver.archivedData(withRootObject: self.paymentsDict)
                                    self.defaults.removeObject(forKey: "sortPayments")
                                    self.defaults.set(savedDict, forKey: "sortPayments")
                                    
                                    NotificationCenter.default.post(name: self.payNot, object: nil, userInfo: ["error": "nil", "response": "complete"])
                                }
                        }
                        catch {
                        }
                    }
                }
                else {
                    NotificationCenter.default.post(name: self.payNot, object: nil, userInfo: ["error": "\(httpResponse.statusCode)", "response": "nil"])
                }
            }
        }
        session.resume()
    }
    
    public func getChatsFromBack(_ uuid: String, active: Int) {
        let url = URL(string: "https://mob.razvitie-mo.ru/backend/api/v1/lka?uuid=\(uuid)&query=%2Fchat%3FsecurityToken%3D%5ftoken%5f%26active%3D\(active)")
        
        var request = URLRequest(url: url!)
        request.timeoutInterval = 5
        
        let newTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                NotificationCenter.default.post(name: self.chatNot, object: nil, userInfo: ["error": error!.localizedDescription, "response": "nil"])
            }
            else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let content = data {
                        do {
                            let myJsonObject = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                            print(myJsonObject)
                            if let response = myJsonObject["response"] as? NSDictionary {
                                if let items = response["items"] as? NSArray {
                                    for i in 0 ..< items.count {
                                        if let chat = items[i] as? NSDictionary {
                                            let type = chat["chatType"] as AnyObject
                                            let date = chat["createDate"] as AnyObject
                                            let id = chat["id"] as AnyObject
                                            let status = chat["status"] as AnyObject
                                            let theme = chat["theme"] as AnyObject
                                            
                                            DispatchQueue.main.async {
                                                self.getChatMFromBack(uuid, id: "\(id)")
                                            }
                                            
                                            let element = classChats(type: "\(type)", date: "\(date)", id: "\(id)", status: "\(status)", theme: "\(theme)")
                                            self.chats.append(element)
                                        }
                                    }
                                }
                                let savedData = NSKeyedArchiver.archivedData(withRootObject: self.chats)
                                self.defaults.removeObject(forKey: "chats")
                                self.defaults.set(savedData, forKey: "chats")
                                NotificationCenter.default.post(name: self.chatNot, object: nil, userInfo: ["error": "nil", "response": "\(self.chats.count)"])
                            }
                        }
                        catch {
                        }
                    }
                }
                else { // Ошибка сервера
                    NotificationCenter.default.post(name: self.chatNot, object: nil, userInfo: ["error": "\(httpResponse.statusCode)", "response": "nil"])
                }
            }
        }
        newTask.resume()
    }
    
    public func getChatMFromBack(_ uuid: String, id: String) {
        let url = URL(string: "https://mob.razvitie-mo.ru/backend/api/v1/lka?uuid=\(uuid)&query=%2Fchat%2F\(id)%3FsecurityToken%3D%5ftoken%5f")
        
        let newTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                NotificationCenter.default.post(name: self.chatMNot, object: nil, userInfo: ["error": error!.localizedDescription, "response": "nil"])
            }
            else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let content = data {
                        do {
                            let myJsonObject = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                            if let response = myJsonObject["response"] as? NSDictionary {
                                if let items = response["items"] as? NSArray {
                                    for i in 0 ..< items.count {
                                        if let messages = items[i] as? NSDictionary {
                                            let date = messages["dateTime"] as AnyObject
                                            let out = messages["fromLka"] as AnyObject
                                            let id = messages["id"] as AnyObject
                                            let message = messages["message"] as AnyObject
                                            
                                            let element = classMessages(date: "\(date)", out: "\(out)", id: "\(id)", message: "\(message)")
                                            self.messages.append(element)
                                        }
                                    }
                                }
                                let savedData = NSKeyedArchiver.archivedData(withRootObject: self.messages)
                                self.defaults.removeObject(forKey: "chatM")
                                self.defaults.set(savedData, forKey: "chatM")
                                NotificationCenter.default.post(name: self.chatMNot, object: nil, userInfo: ["error": "nil", "response": "complete"])
                            }
                        }
                        catch {
                        }
                    }
                }
                else { // Ошибка сервера
                    NotificationCenter.default.post(name: self.chatMNot, object: nil, userInfo: ["error": "\(httpResponse.statusCode)", "response": "nil"])
                }
            }
        }
        newTask.resume()
    }
    
    public func chatInit(_ uuid: String, _ type: String, _ message: String, _ id: String) {
        let url = URL(string: "https://mob.razvitie-mo.ru/backend/api/v1/lka?uuid=\(uuid)&query=%2Fchat%2Finit%3FsecurityToken%3D%5ftoken%5f%26chatType%3D\(type)%26chatTheme%26chatMessage%3D\(message)%26lawInstanceId%3D\(id)")!
        
        print(url)
        var quest = URLRequest(url: url)
        quest.httpMethod = "POST"
        
        let session = URLSession.shared.dataTask(with: quest) { (data, response, error) in
            if error != nil {
                NotificationCenter.default.post(name: self.chatInitNot, object: nil, userInfo: ["error": error!.localizedDescription, "response": "nil"])
            }
            else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let content = data {
                        do {
                            if let myJsonObject = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                                print(myJsonObject)
                                //if let authCode = myJsonObject["Code:"] as? String {
                                NotificationCenter.default.post(name: self.chatInitNot, object: nil, userInfo: ["error": "nil", "response": ""])
                                //}
                            }
                        }
                        catch {
                        }
                    }
                }
                else {
                    NotificationCenter.default.post(name: self.chatInitNot, object: nil, userInfo: ["error": "\(httpResponse.statusCode)", "response": "nil"])
                }
            }
        }
        session.resume()
    }
    //    public func getSecurityToken(type: String, inn: String, snilsOgrn: String) {
    //        var snils = String()
    //        var ogrn = String()
    //
    //        if type == "entity" {
    //            snils = ""
    //            ogrn = "=\(snilsOgrn)"
    //        }
    //        else if type == "individual" {
    //            snils = "=\(snilsOgrn)"
    //            ogrn = ""
    //        }
    //
    //        let url = URL(string: "https://srv-saumi-ci.bftcom.com/ws/tpo/login?sessionId=4324234&tenantType=\(type)&inn=\(inn)&snils\(snils)&ogrn\(ogrn)")
    //
    //        _ = TaskManager.shared.dataTask(with: url!) { (data, response, error) in
    //            if error != nil {
    //                NotificationCenter.default.post(name: self.tokenNot, object: nil, userInfo: ["error": error!.localizedDescription, "response": "nil"])
    //                print("ERROR IN TOKEN") // Внутренняя ошибка приложения
    //            }
    //            else if let httpResponse = response as? HTTPURLResponse {
    //                if httpResponse.statusCode == 200 { // Ответ получен
    //                    if let content = data {
    //                        do {
    //                            let myJsonObject = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
    //                            if let response = myJsonObject["response"] as? NSDictionary {
    //                                if let token = response["securityToken"] as? String {
    //                                    self.defaults.set(token, forKey: "token")
    //                                    NotificationCenter.default.post(name: self.tokenNot, object: nil, userInfo: ["error": "nil", "response": token])
    //                                    print(token)
    //                                }
    //                            }
    //                            else if (myJsonObject["error"] as? NSDictionary) != nil {
    //                            }
    //                        }
    //                        catch {
    //                        }
    //                    }
    //                }
    //                else { // Ошибка сервера
    //                    NotificationCenter.default.post(name: self.tokenNot, object: nil, userInfo: ["error": "\(httpResponse.statusCode)", "response": "nil"])
    //                }
    //            }
    //
    //        }
    //    }
    
    //    public func getContracts(token: String) {
    //        let url = URL(string: "https://srv-saumi-ci.bftcom.com/ws/tpo/leaseContract?securityToken=\(token)&showClosed=0")
    //
    //        TaskManager.shared.dataTask(with: url!) { (data, response, error) in
    //            if error != nil {
    //                NotificationCenter.default.post(name: self.docNot, object: nil, userInfo: ["error": error!.localizedDescription, "response": "nil"])
    //            }
    //            else if let httpResponse = response as? HTTPURLResponse {
    //                if httpResponse.statusCode == 200 {
    //                    if let content = data {
    //                        do {
    //                            let myJsonObject = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
    //                            if let response = myJsonObject["response"] as? NSDictionary {
    //                                if let items = response["items"] as? NSArray {
    //                                    for i in 0 ..< items.count {
    //                                        if let contract = items[i] as? NSDictionary {
    //                                            let address = contract["addresses"] as AnyObject
    //                                            let use = contract["allowedUseType"] as AnyObject
    //                                            let date = contract["docDate"] as AnyObject
    //                                            let number = contract["docNumber"] as AnyObject
    //                                            let id = contract["id"] as AnyObject
    //                                            let type = contract["objectType"] as AnyObject
    //                                            let owner = contract["ownerName"] as AnyObject
    //                                            let payDate = contract["paymentDate"] as AnyObject
    //                                            let rent = contract["rentAmount"] as AnyObject
    //
    //                                            DispatchQueue.main.async {
    //                                                self.getPayments(id: "\(id)", token: token)
    //                                            }
    //
    //                                            let element = classDocuments(address: "\(address)", use: "\(use)", date: "\(date)", number: "\(number)", id: "\(id)", type: "\(type)", owner: "\(owner)", payDate: "\(payDate)", rent: "\(rent)")
    //                                            self.documents.append(element)
    //                                        }
    //                                    }
    //                                }
    //                                let savedData = NSKeyedArchiver.archivedData(withRootObject: self.documents)
    //                                self.defaults.set(savedData, forKey: "documents")
    //                                NotificationCenter.default.post(name: self.docNot, object: nil, userInfo: ["error": "nil", "response": "\(self.documents.count)"])
    //                            }
    //                        }
    //                        catch {
    //                        }
    //                    }
    //                }
    //                else { // Ошибка сервера
    //                    NotificationCenter.default.post(name: self.docNot, object: nil, userInfo: ["error": "\(httpResponse.statusCode)", "response": "nil"])
    //                }
    //            }
    //        }
    //    }
    //
    //    public func getPayments(id: String, token: String) {
    //        var overdue = [classPayments]()
    //        var actual = [classPayments]()
    //
    //        let url = URL(string: "https://srv-saumi-ci.bftcom.com/ws/tpo/leaseContract/\(id)?securityToken=\(token)&payedAccruals=1")
    //
    //        TaskManager.shared.dataTask(with: url!) { (data, response, error) in
    //            if error != nil {
    //                NotificationCenter.default.post(name: self.payNot, object: nil, userInfo: ["error": error!.localizedDescription, "response": "nil"])
    //            }
    //            else if let httpResponse = response as? HTTPURLResponse {
    //                if httpResponse.statusCode == 200 {
    //                    if let content = data {
    //                        do {
    //                            let myJsonObject = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
    //                            if let response = myJsonObject["response"] as? NSDictionary {
    //                                if let accruals = response["accruals"] as? NSArray {
    //                                    for i in 0 ..< accruals.count {
    //                                        if let pay = accruals[i] as? NSDictionary {
    //                                            let accrual = pay["accrualAmount"] as AnyObject
    //                                            let date = pay["date"] as AnyObject
    //                                            let idPay = pay["id"] as AnyObject
    //                                            let payment = pay["paymentAmount"] as AnyObject
    //                                            let period = pay["period"] as AnyObject
    //                                            let status = pay["status"] as AnyObject
    //                                            let type = pay["type"] as AnyObject
    //
    //                                            let element = classPayments(id: "\(idPay)", accrual: "\(accrual)", date: "\(date)", payment: "\(payment)", period: "\(period)", status: "\(status)", type: "\(type)", docId: "\(id)")
    //
    //                                            switch "\(status)" {
    //                                            case "Не оплачено (неоплаченное начисление прошлого периода)":
    //                                                overdue.append(element)
    //                                                self.allOverdues.append(element)
    //                                            case "Не оплачено (неоплаченное начисление текущего периода)", "Начисление будущих периодов (неоплаченные начисления будущих периодов)":
    //                                                actual.append(element)
    //                                                self.allActual.append(element)
    //                                            default:
    //                                                self.allPayed.append(element)
    //                                            }
    //                                        }
    //                                    }
    //                                }
    //                                let savedOverdues = NSKeyedArchiver.archivedData(withRootObject: self.allOverdues)
    //                                let savedActual = NSKeyedArchiver.archivedData(withRootObject: self.allActual)
    //                                let savedPayed = NSKeyedArchiver.archivedData(withRootObject: self.allPayed)
    //
    //                                self.defaults.set(savedOverdues, forKey: "overdue")
    //                                self.defaults.set(savedActual, forKey: "actual")
    //                                self.defaults.set(savedPayed, forKey: "payed")
    //
    //                                self.paymentsDict.updateValue(overdue, forKey: "\(id)Overdue")
    //                                self.paymentsDict.updateValue(actual, forKey: "\(id)Actual")
    //
    //                                let savedDict = NSKeyedArchiver.archivedData(withRootObject: self.paymentsDict)
    //                                self.defaults.set(savedDict, forKey: "sortPayments")
    //
    //                                NotificationCenter.default.post(name: self.payNot, object: nil, userInfo: ["error": "nil", "response": "complete"])
    //                            }
    //                        }
    //                        catch {
    //                        }
    //                    }
    //                }
    //                else {
    //                    NotificationCenter.default.post(name: self.payNot, object: nil, userInfo: ["error": "\(httpResponse.statusCode)", "response": "nil"])
    //                }
    //            }
    //        }
    //    }
}
