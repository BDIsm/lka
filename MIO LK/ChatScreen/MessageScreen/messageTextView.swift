//
//  messageTextView.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 06.08.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation
import UIKit

protocol messageTextDelegate {
    func sendWasTapped(message: String)
    func heightChanged(height: CGFloat)
}

class messageTextView: UIView, UITextViewDelegate {
    var delegate: messageTextDelegate?
    
    let sendButton = UIButton()
    let textInput = UITextView()
    
    var beginFrame = CGRect()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    func initialize(frame: CGRect) {
        sendButton.frame = CGRect(x: self.bounds.maxX-49, y: 0, width: 49, height: 49)
        sendButton.setImage(#imageLiteral(resourceName: "send"), for: .normal)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        sendButton.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin]
        
        textInput.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        textInput.text = "Введите сообщение"
        textInput.textColor = UIColor.lightGray
        textInput.font = UIFont(name: "Ekibastuz-Regular", size: 17)
        textInput.sizeToFit()
        textInput.frame.size.width = self.bounds.maxX-57
        textInput.frame.origin.x = 8
        textInput.center.y = self.bounds.midY
        textInput.layer.cornerRadius = 10
        textInput.delegate = self
        textInput.autoresizingMask = [.flexibleRightMargin, .flexibleHeight, .flexibleWidth]
    
        let line = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 0.5))
        line.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        
        addSubview(line)
        addSubview(textInput)
        addSubview(sendButton)
        
        beginFrame = frame
    }
    
    @objc func sendTapped() {
        let str = textInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if let delegate = delegate, str != "" && textInput.textColor != .lightGray {
            delegate.sendWasTapped(message: str)
            
            textInput.text = ""
            textInput.resignFirstResponder()
            self.frame = beginFrame
        }
        else {
            textInput.text = "Введите сообщение"
            textInput.textColor = .lightGray
            textInput.resignFirstResponder()
            self.frame = beginFrame
        }
    }
    
    // Изменение высоты текстового поля при вводе
    func textViewDidChange(_ textView: UITextView) {
        textInput.isScrollEnabled = false
        let heightChange = getHeightChange(fixedWidth: textInput.frame.width, text: textInput.text)
        
        if self.frame.height+heightChange < 49 {
        }
        else if self.frame.height+heightChange < 147 {
            delegate?.heightChanged(height: heightChange)
            
            self.frame.size.height += heightChange
            self.frame.origin.y -= heightChange
        }
        else {
            textInput.isScrollEnabled = true
        }
    }
    
    // Вычисление высоты текстового поля
    func getHeightChange(fixedWidth: CGFloat, text: String) -> CGFloat {
        let newSize: CGSize = textInput.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
        
        var newFrame = textInput.frame
        
        newFrame.size = CGSize(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))), height: newSize.height)
        
        let diff = newFrame.height - textInput.frame.height
        return diff
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Введите сообщение"
            textView.textColor = UIColor.lightGray
        }
    }
}

