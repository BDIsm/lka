//
//  greetingTableViewCell.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 07.08.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

enum chatType: Int {
    case curator
    case common
}

protocol chatTypeDelegate {
    func tapped(type: chatType, height: CGFloat)
}

class greetingTableViewCell: UITableViewCell {
    var delegate: chatTypeDelegate?
    
    @IBOutlet weak var greetingView: messageView!
    @IBOutlet weak var greetingLabel: UILabel!
    
    @IBOutlet weak var collectionForDoc: collectionDoc!
    
    @IBAction func segmentSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            if let delegate = delegate {
                let tappedType: chatType = .common
                delegate.tapped(type: tappedType, height: collectionForDoc.frame.height)
            }
            UIView.animate(withDuration: 0.25) {
                self.collectionForDoc.alpha = 0
            }
        default:
            if let delegate = delegate {
                let tappedType: chatType = .curator
                delegate.tapped(type: tappedType, height: collectionForDoc.frame.height)
            }
            UIView.animate(withDuration: 0.25) {
                self.collectionForDoc.alpha = 1
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setUp(documents: [classDocuments]) {
        if documents.count == 1 {
            collectionForDoc.frame.size.height = 75
        }
        else {
            collectionForDoc.frame.size.height = 150
        }
        
        setNeedsLayout()
    }
}
