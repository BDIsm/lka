//
//  MessageViewCell.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 06.08.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class MessageViewCell: UITableViewCell {
    @IBOutlet weak var viewForMessage: messageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var messageOut = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func apply(message: classMessages) {
        messageLabel.text = message.message
        messageOut = message.out
        if messageOut == "0" {
            viewForMessage.frame.origin.x = 10
        }
        setNeedsLayout()
    }
    
    class func height(for message: classMessages) -> CGFloat {
        let maxSize = CGSize(width: 2*(UIScreen.main.bounds.size.width/3), height: CGFloat.greatestFiniteMagnitude)
        let messageHeight = height(forText: message.message, fontSize: 17, maxSize: maxSize)
        
        return messageHeight + 32 + 16
    }
    
    private class func height(forText text: String, fontSize: CGFloat, maxSize: CGSize) -> CGFloat {
        let font = UIFont(name: "Helvetica", size: fontSize)!
        let attrString = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white])
        let textHeight = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size.height
        
        return textHeight
    }

}
