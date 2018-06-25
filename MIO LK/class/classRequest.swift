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
    
    private let tokenNot = NSNotification.Name("token")
    private let urlNot = NSNotification.Name("url")
    private let docNot = NSNotification.Name("documents")
    private let payNot = NSNotification.Name("pay")
    
    private var documents = [classDocuments]()
    
    private var allOverdues = [classPayments]()
    private var allActual = [classPayments]()
    private var allPayed = [classPayments]()
    
    private var paymentsDict = [String:[classPayments]]()
    
    public func authorize(uuid: String) {
        let url = URL(string: "https://mob.razvitie-mo.ru/backend/api/v1/init?uuid=\(uuid)")
        
        _ = TaskManager.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                NotificationCenter.default.post(name: self.urlNot, object: nil, userInfo: ["error": error!.localizedDescription, "response": "nil"])
            }
            else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let content = data {
                        do {
                            if let myJsonObject = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                                if let esiaUrl = myJsonObject["Url"] as? String {
                                    self.defaults.set(esiaUrl, forKey: "url")
                                    NotificationCenter.default.post(name: self.urlNot, object: nil, userInfo: ["error": "nil", "response": esiaUrl])
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
    }
    
    public func getSecurityToken(type: String, inn: String, snilsOgrn: String) {
        var snils = String()
        var ogrn = String()
        
        if type == "entity" {
            snils = ""
            ogrn = "=\(snilsOgrn)"
        }
        else if type == "individual" {
            snils = "=\(snilsOgrn)"
            ogrn = ""
        }
        
        let url = URL(string: "https://srv-saumi-ci.bftcom.com/ws/tpo/login?sessionId=4324234&tenantType=\(type)&inn=\(inn)&snils\(snils)&ogrn\(ogrn)")
        
        _ = TaskManager.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                NotificationCenter.default.post(name: self.tokenNot, object: nil, userInfo: ["error": error!.localizedDescription, "response": "nil"])
                print("ERROR IN TOKEN") // Внутренняя ошибка приложения
            }
            else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 { // Ответ получен
                    if let content = data {
                        do {
                            let myJsonObject = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            if let response = myJsonObject["response"] as? NSDictionary {
                                if let token = response["securityToken"] as? String {
                                    self.defaults.set(token, forKey: "token")
                                    NotificationCenter.default.post(name: self.tokenNot, object: nil, userInfo: ["error": "nil", "response": token])
                                    print(token)
                                }
                            }
                            else if (myJsonObject["error"] as? NSDictionary) != nil {
                            }
                        }
                        catch {
                        }
                    }
                }
                else { // Ошибка сервера
                   NotificationCenter.default.post(name: self.tokenNot, object: nil, userInfo: ["error": "\(httpResponse.statusCode)", "response": "nil"])
                }
            }
            
        }
    }
    
    public func getContracts(token: String) {
        let url = URL(string: "https://srv-saumi-ci.bftcom.com/ws/tpo/leaseContract?securityToken=\(token)&showClosed=0")
        
        TaskManager.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                NotificationCenter.default.post(name: self.docNot, object: nil, userInfo: ["error": error!.localizedDescription, "response": "nil"])
            }
            else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let content = data {
                        do {
                            let myJsonObject = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                            if let response = myJsonObject["response"] as? NSDictionary {
                                if let items = response["items"] as? NSArray {
                                    for i in 0 ..< items.count {
                                        if let contract = items[i] as? NSDictionary {
                                            let address = contract["addresses"] as AnyObject
                                            let use = contract["allowedUseType"] as AnyObject
                                            let date = contract["docDate"] as AnyObject
                                            let number = contract["docNumber"] as AnyObject
                                            let id = contract["id"] as AnyObject
                                            let type = contract["objectType"] as AnyObject
                                            let owner = contract["ownerName"] as AnyObject
                                            let payDate = contract["paymentDate"] as AnyObject
                                            let rent = contract["rentAmount"] as AnyObject
                                            
                                            DispatchQueue.main.async {
                                                self.getPayments(id: "\(id)", token: token)
                                            }
                                            
                                            let element = classDocuments(address: "\(address)", use: "\(use)", date: "\(date)", number: "\(number)", id: "\(id)", type: "\(type)", owner: "\(owner)", payDate: "\(payDate)", rent: "\(rent)")
                                            self.documents.append(element)
                                        }
                                    }
                                }
                                let savedData = NSKeyedArchiver.archivedData(withRootObject: self.documents)
                                self.defaults.set(savedData, forKey: "documents")
                                NotificationCenter.default.post(name: self.docNot, object: nil, userInfo: ["error": "nil", "response": "\(self.documents.count)"])
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
    }
    
    public func getPayments(id: String, token: String) {
        var overdue = [classPayments]()
        var actual = [classPayments]()
        
        let url = URL(string: "https://srv-saumi-ci.bftcom.com/ws/tpo/leaseContract/\(id)?securityToken=\(token)&payedAccruals=1")
        
        TaskManager.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                NotificationCenter.default.post(name: self.payNot, object: nil, userInfo: ["error": error!.localizedDescription, "response": "nil"])
            }
            else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let content = data {
                        do {
                            let myJsonObject = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
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
                                
                                self.defaults.set(savedOverdues, forKey: "overdue")
                                self.defaults.set(savedActual, forKey: "actual")
                                self.defaults.set(savedPayed, forKey: "payed")
                                
                                self.paymentsDict.updateValue(overdue, forKey: "\(id)Overdue")
                                self.paymentsDict.updateValue(actual, forKey: "\(id)Actual")
                                
                                let savedDict = NSKeyedArchiver.archivedData(withRootObject: self.paymentsDict)
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
    }
    
}
