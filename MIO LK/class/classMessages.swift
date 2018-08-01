//
//  classMessages.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 01.08.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation

class classMessages: NSObject, NSCoding {
    var date = String()
    var out = String()
    var id = String()
    var message = String()
    var sender = String()
    
    init(date: String, out: String, id: String, message: String) {
        self.out = out
        self.id = id
        self.message = message
        //self.sender = sender
        
        super.init()
        
        let dateNew = filterFormat(symbol: "T", string: date)
        let dateArray = dateNew.split(separator: "-")
        if dateArray.count == 3 {
            let dateForView = dateArray[2] + "." + dateArray[1] + "." + dateArray[0]
            self.date = dateForView
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        date = aDecoder.decodeObject(forKey: "chatMDate") as! String
        out = aDecoder.decodeObject(forKey: "chatMOut") as! String
        id = aDecoder.decodeObject(forKey: "chatMID") as! String
        message = aDecoder.decodeObject(forKey: "chatMMessage") as! String
        sender = aDecoder.decodeObject(forKey: "chatMSender") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "chatMDate")
        aCoder.encode(out, forKey: "chatMOut")
        aCoder.encode(id, forKey: "chatMID")
        aCoder.encode(message, forKey: "chatMMessage")
        aCoder.encode(sender, forKey: "chatMSender")
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
