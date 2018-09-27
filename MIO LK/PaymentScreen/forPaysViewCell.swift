//
//  forPaysViewCell.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 04.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class forPaysViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var paysCollection: UICollectionView!
    @IBOutlet weak var line: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var array = [classPayments]()
    
    override func prepareForReuse() {
        array = [classPayments]()
        paysCollection.reloadData()
        line.isHidden = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func customize() {
        paysCollection.dataSource = self
        paysCollection.delegate = self
//
//        self.layer.masksToBounds = false
//
//        self.backgroundColor = UIColor.white
//        //Shape
//        self.layer.cornerRadius = 10.0
//        //Shadow
//        self.layer.shadowColor = UIColor.lightGray.cgColor
//        self.layer.shadowOpacity = 0.8
//        self.layer.shadowOffset = CGSize.zero
//        self.layer.shadowRadius = 10.0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "paymentCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! paymentViewCell
        
        let element = array[indexPath.row]
        cell.customize(element.status, element.accrual, element.date)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dict = [String: classPayments]()
        
        let element = array[indexPath.row]
        dict.updateValue(element, forKey: "chosenPayInPays")
        
        NotificationCenter.default.post(name: NSNotification.Name("chooseCellInPays"), object: nil, userInfo: dict)
    }
}
