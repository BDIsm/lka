//
//  classPayments.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 29.05.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation

class classPayments: NSObject, NSCoding {
    var id = String()
    
    var accrual = String()
    var date = String()
    var payment = String()
    var period = String()
    var status = String()
    var type = String()
    var docId = String()
    var uin = String()
    
    var year = String()
    
    init(id: String, accrual: String, date: String, payment: String, period: String, status: String, type: String, docId: String, uin: String) {
        self.id = id
        self.accrual = accrual
        
        self.payment = payment
        self.period = period
        self.status = status
        self.type = type
        self.docId = docId
        self.uin = uin
        
        super.init()
        
        let dateNew = filterFormat(symbol: "T", string: String(describing: date))
        let dateArray = dateNew.split(separator: "-")
        if dateArray.count == 3 {
            let dateForView = dateArray[2] + "." + dateArray[1] + "." + dateArray[0]
            self.date = dateForView
            self.year = String(dateArray[0])
        }
        else {
            self.date = ""
            self.year = ""
        }
        // Удаление более 2 цифр после запятой
        let accrualNew = accrual.split(separator: ".")
        let i = accrualNew[1].count
        self.accrual = accrualNew[0]+"."+accrualNew[1].dropLast(i-2)
    }
    
    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "payID") as! String
        date = aDecoder.decodeObject(forKey: "payDate") as! String
        status = aDecoder.decodeObject(forKey: "payStatus") as! String
        period = aDecoder.decodeObject(forKey: "payPeriod") as! String
        payment = aDecoder.decodeObject(forKey: "payPayment") as! String
        accrual = aDecoder.decodeObject(forKey: "payAccrual") as! String
        type = aDecoder.decodeObject(forKey: "payType") as! String
        docId = aDecoder.decodeObject(forKey: "payDId") as! String
        uin = aDecoder.decodeObject(forKey: "payUIN") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "payID")
        aCoder.encode(date, forKey: "payDate")
        aCoder.encode(status, forKey: "payStatus")
        aCoder.encode(period, forKey: "payPeriod")
        aCoder.encode(payment, forKey: "payPayment")
        aCoder.encode(accrual, forKey: "payAccrual")
        aCoder.encode(type, forKey: "payType")
        aCoder.encode(docId, forKey: "payDId")
        aCoder.encode(uin, forKey: "payUIN")
    }
    
    func filterFormat (symbol: Character, string: String) -> String{
        var text = ""
        for i in string {
            if i == symbol {
                break
            } else {
                text.append(i)
            }
        }
        return text
    }
}

