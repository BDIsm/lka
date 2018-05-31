//
//  classDocuments.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 29.05.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation

class classDocuments: NSObject, NSCoding {
    var address = String()
    var use = String()
    var date = String()
    var number = String()
    var id = String()
    var type = String()
    var owner = String()
    var payDate = String()
    var rent = String()
    
    init(address: String, use: String, date: String, number: String, id: String, type: String, owner: String, payDate: String, rent: String) {
        self.address = address
        self.use = use
        
        self.number = number
        self.id = id
        self.type = type
        self.owner = owner
        self.payDate = payDate
        self.rent = rent
        
        super.init()
        
        let dateNew = filterFormat(symbol: "T", string: date)
        let dateArray = dateNew.split(separator: "-")
        if dateArray.count == 3 {
            let dateForView = dateArray[2] + "." + dateArray[1] + "." + dateArray[0]
            self.date = dateForView
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        address = aDecoder.decodeObject(forKey: "docAddress") as! String
        use = aDecoder.decodeObject(forKey: "docUse") as! String
        number = aDecoder.decodeObject(forKey: "docNumber") as! String
        date = aDecoder.decodeObject(forKey: "docDate") as! String
        id = aDecoder.decodeObject(forKey: "docID") as! String
        type = aDecoder.decodeObject(forKey: "docType") as! String
        owner = aDecoder.decodeObject(forKey: "docOwner") as! String
        payDate = aDecoder.decodeObject(forKey: "docPayDate") as! String
        rent = aDecoder.decodeObject(forKey: "docRent") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(address, forKey: "docAddress")
        aCoder.encode(use, forKey: "docUse")
        aCoder.encode(number, forKey: "docNumber")
        aCoder.encode(date, forKey: "docDate")
        aCoder.encode(id, forKey: "docID")
        aCoder.encode(type, forKey: "docType")
        aCoder.encode(owner, forKey: "docOwner")
        aCoder.encode(payDate, forKey: "docPayDate")
        aCoder.encode(rent, forKey: "docRent")
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

