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
    
    private var documents = [classDocuments]()
    private var payments = [classPayments]()
    
    private var paymentsDict = [String:[classPayments]]()
    
    public func authorize(uuid: String, finished: @escaping ((_ isSuccess: Bool) -> Void)) {
        let url = URL(string: "http://mob.razvitie-mo.ru:8080/backend/api/v1/init?uuid=\(uuid)")
        
        _ = TaskManager.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print ("ERROR IN TOKEN")
            }
            
            if let content = data {
                do {
                    if let myJsonObject = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        if let esiaUrl = myJsonObject["Url"] as? String {
                            self.defaults.set(esiaUrl, forKey: "url")
                        }
                    }
                }
                catch {
                }
            }
            
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                
                if httpResponse.statusCode == 200 {
                    finished(true)
                }
                else {
                    finished(false)
                }
            }
        }
        
        
    }
    
    public func getSecurityToken(type: String, inn: String, snilsOgrn: String, finished: @escaping ((_ isSuccess: Bool) -> Void)) {
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
                print ("ERROR IN TOKEN")
            }
            
            if let content = data {
                do {
                    let myJsonObject = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    if let response = myJsonObject["response"] as? NSDictionary {
                        if let token = response["securityToken"] as? String {
                            self.defaults.set(token, forKey: "token")
                            print(token)
                        }
                        
                        let name = response["tenantName"] as AnyObject
                        self.defaults.set("\(name)", forKey: "tenant")
                    }
                    else if (myJsonObject["error"] as? NSDictionary) != nil {
                    }
                }
                catch {
                }
            }
            
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                
                if httpResponse.statusCode == 200 {
                    finished(true)
                }
                else {
                    finished(false)
                }
            }
            
        }
    }
    
    public func getContracts(finished: @escaping (_ isSuccess: Bool) -> Void) {
        let token = defaults.object(forKey: "token") as! String
        
        let url = URL(string: "https://srv-saumi-ci.bftcom.com/ws/tpo/leaseContract?securityToken=\(token)&showClosed=0")
        
        TaskManager.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print ("ERROR IN DOCS")
            }
            
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
                                    
                                    let element = classDocuments(address: "\(address)", use: "\(use)", date: "\(date)", number: "\(number)", id: "\(id)", type: "\(type)", owner: "\(owner)", payDate: "\(payDate)", rent: "\(rent)")
                                    self.documents.append(element)
                                }
                            }
                        }
                        let savedData = NSKeyedArchiver.archivedData(withRootObject: self.documents)
                        self.defaults.set(savedData, forKey: "documents")
                        
                        print("complete")
                    }
                }
                catch {
                }
            }
            
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                
                if httpResponse.statusCode == 200 {
                    finished(true)
                }
                else {
                    finished(false)
                }
            }
        }
    }
    
    public func getPayments(id: String) {//, finished: @escaping (_ isSuccess: Bool) -> Void) {
        let token = defaults.object(forKey: "token") as! String
        
        var overdue = [classPayments]()
        var actual = [classPayments]()
        
        let url = URL(string: "https://srv-saumi-ci.bftcom.com/ws/tpo/leaseContract/\(id)?securityToken=\(token)&payedAccruals=1")
        
        TaskManager.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print ("ERROR IN PAYS")
            }
            
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
                                    
                                    let element = classPayments(id: "\(idPay)", accrual: "\(accrual)", date: "\(date)", payment: "\(payment)", period: "\(period)", status: "\(status)", type: "\(type)")
                                    
                                    switch "\(status)" {
                                    case "Не оплачено (неоплаченное начисление прошлого периода)":
                                        overdue.append(element)
                                    case "Не оплачено (неоплаченное начисление текущего периода)", "Не оплачено (неоплаченное начисление будущих периодов)":
                                        actual.append(element)
                                    default: break
                                    }
                                    
                                    self.payments.append(element)
                                }
                            }
                        }
                        let savedData = NSKeyedArchiver.archivedData(withRootObject: self.payments)
                        self.defaults.set(savedData, forKey: "allPayments")
                        
                        self.paymentsDict.updateValue(overdue, forKey: "\(id)Overdue")
                        self.paymentsDict.updateValue(actual, forKey: "\(id)Actual")
                        
                        let savedDict = NSKeyedArchiver.archivedData(withRootObject: self.paymentsDict)
                        self.defaults.set(savedDict, forKey: "sortPayments")
                        
                        print("complete")
                    }
                }
                catch {
                }
            }
            
            NotificationCenter.default.post(name: NSNotification.Name("pay"), object: nil)
        }
    }
    
    
}
