//
//  collection.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 07.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation
import UIKit

class collectionDoc: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let defaults = UserDefaults.standard
    var documents = [classDocuments]()
    
    let cellReuseIdentifier = "docInChat"
    let flowLayout = UICollectionViewFlowLayout()
    var width = CGFloat()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let savedDocs = defaults.object(forKey: "documents") as? Data {
            documents = NSKeyedUnarchiver.unarchiveObject(with: savedDocs) as! [classDocuments]
        }
        
        self.isUserInteractionEnabled = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let savedDocs = defaults.object(forKey: "documents") as? Data {
            documents = NSKeyedUnarchiver.unarchiveObject(with: savedDocs) as! [classDocuments]
        }
        
        self.isUserInteractionEnabled = true
    }
    
    func collectionDidLoad(cellWidth: CGFloat) {
        self.isUserInteractionEnabled = true
        
        width = cellWidth
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.register(docInChatViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Customize
        collectionView.backgroundColor = UIColor.clear
        collectionView.layer.masksToBounds = false
        collectionView.allowsMultipleSelection = false
        collectionView.indicatorStyle = .white
        
        self.addSubview(collectionView)
    }
    
    func remove() {
        for i in subviews {
            i.removeFromSuperview()
        }
    }
    
    func selectionDisable() {
        self.isUserInteractionEnabled = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! docInChatViewCell
        cell.redraw()
        
        let element = documents[indexPath.row]
        cell.numberLabel.text = "Док. №\(element.number)"
        cell.dateLabel.text = "от \(element.date)"
        cell.addressLabel.text = "Адрес: \(element.address)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if documents.count == 1 {
            let size = CGSize(width: width, height: self.bounds.height-2.5)
            return size
        }
        else {
            let size = CGSize(width: width, height: self.bounds.height/2-2.5)
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        
        let element = documents[indexPath.row]
        NotificationCenter.default.post(name: NSNotification.Name("isChosen"), object: nil, userInfo: ["docID": element.id])
    }
}
