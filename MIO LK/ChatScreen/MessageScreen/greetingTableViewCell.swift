//
//  greetingTableViewCell.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 07.08.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class greetingTableViewCell: UITableViewCell {
    @IBOutlet weak var greetingView: messageView!
    @IBOutlet weak var greetingLabel: UILabel!
    
    @IBOutlet weak var techSupportButton: UIButton!
    @IBOutlet weak var curSupportButton: UIButton!
    
    @IBAction func techSuppTapped(_ sender: UIButton) {
    }
    
    @IBAction func curSuppTapped(_ sender: UIButton) {
        
    }
    
    @IBOutlet weak var collectionForDoc: collectionDoc!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(documents: [classDocuments]) {
        //techSupportButton.frame.origin.y = 210
        //curSupportButton.frame.origin.y = 210
        curSupportButton.frame.origin.x = 10+techSupportButton.frame.width+5
        
        if documents.count == 0 {
            //collectionForDoc.frame.origin.y = techSupportButton.frame.maxY+5
            collectionForDoc.frame.size.height = 75
        }
        else {
            //collectionForDoc.frame.origin.y = techSupportButton.frame.maxY+5
            collectionForDoc.frame.size.height = 150
        }
        
        setNeedsLayout()
    }
    
    class func height(_ docs: [classDocuments]) -> CGFloat {
        let collectionHeight = heightForCollection(documents: docs)
        return 260 + collectionHeight
    }
    
    
    private class func heightForCollection(documents: [classDocuments]) -> CGFloat {
        if documents.count == 1 {
            return 75
        }
        else {
            return 150
        }
    }

}
