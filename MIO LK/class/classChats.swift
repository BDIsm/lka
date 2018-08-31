//
//  classChat.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 01.08.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation

class classChats: NSObject, NSCoding {
    var type = String()
    var date = String()
    var id = String()
    var recipient = String()
    var status = String()
    var theme = String()
    
    init(type: String, date: String, id: String, status: String, theme: String) {
        self.type = type
        self.id = id
        self.status = status
        self.theme = theme
        
        super.init()
        
        let dateNew = filterFormat(symbol: "T", string: date)
        let dateArray = dateNew.split(separator: "-")
        if dateArray.count == 3 {
            let dateForView = dateArray[2] + "." + dateArray[1] + "." + dateArray[0]
            self.date = dateForView
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        type = aDecoder.decodeObject(forKey: "chatType") as! String
        date = aDecoder.decodeObject(forKey: "chatDate") as! String
        id = aDecoder.decodeObject(forKey: "chatID") as! String
        status = aDecoder.decodeObject(forKey: "chatStatus") as! String
        theme = aDecoder.decodeObject(forKey: "chatTheme") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(type, forKey: "chatType")
        aCoder.encode(date, forKey: "chatDate")
        aCoder.encode(id, forKey: "chatID")
        aCoder.encode(status, forKey: "chatStatus")
        aCoder.encode(theme, forKey: "chatTheme")
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
