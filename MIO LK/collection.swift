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
    let numberOfItemsPerRow: CGFloat = 7.0
    let cellReuseIdentifier = "docInChat"
    let flowLayout = UICollectionViewFlowLayout()
    
    var numberItems = Int()
    var width = CGFloat()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func collection(items: Int, w: CGFloat) {
        self.isUserInteractionEnabled = true
        numberItems = items
        width = w
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 5
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.register(docInChatViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.layer.masksToBounds = false
        
        self.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! docInChatViewCell
        
        
        //cell.backgroundColor = UIColor.green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width: CGFloat = 150// (screenSize.width-leftAndRightPaddings)/numberOfItemsPerRow
        let size = CGSize(width: width, height: self.bounds.height/2-6)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You select this Shit in \(indexPath.row)")
    }
}
