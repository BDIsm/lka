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
        
        viewForMessage.frame.size.width = width(message.message, size: viewForMessage.frame.size)
        viewForMessage.frame.origin.x = self.bounds.maxX-10-viewForMessage.frame.width
        
        messageOut = message.out
        if messageOut == "0" {
            viewForMessage.frame.origin.x = 10
        }
        setNeedsLayout()
    }
    
    // Ширина view начисления в ячейке
    func width(_ message: String, size: CGSize) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        label.numberOfLines = 0
        label.text = message
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.sizeToFit()
        label.setNeedsDisplay()
        
        return label.frame.width+20
    }
    
    // Размер ячейки сообщения в TableView
    class func height(for message: classMessages) -> CGFloat {
        let maxSize = CGSize(width: 2*(UIScreen.main.bounds.size.width/3), height: CGFloat.greatestFiniteMagnitude)
        let messageHeight = height(forText: message.message, fontSize: 17, maxSize: maxSize)
        
        return messageHeight + 20
    }
    
    private class func height(forText text: String, fontSize: CGFloat, maxSize: CGSize) -> CGFloat {
        let font = UIFont(name: "Helvetica", size: fontSize)!
        let attrString = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white])
        let textHeight = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size.height
        
        return textHeight
    }

}

