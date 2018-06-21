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
    
    func customize() {
        paysCollection.dataSource = self
        paysCollection.delegate = self
        /*
        self.layer.masksToBounds = false
        
        self.backgroundColor = UIColor.white
        //Shape
        self.layer.cornerRadius = 10.0
        //Shadow
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10.0*/
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 10, 0, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "paymentCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! paymentViewCell
        
        let element = array[indexPath.row]
        if element.status == "Оплачено" {
            cell.customize(image: #imageLiteral(resourceName: "gray"), a: element.accrual, d: element.date)
        }
        else if element.status == "Не оплачено (неоплаченное начисление прошлого периода)" {
            cell.customize(image: #imageLiteral(resourceName: "red"), a: element.accrual, d: element.date)
        }
        else {
            cell.customize(image: #imageLiteral(resourceName: "blue"), a: element.accrual, d: element.date)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dict = [String: classPayments]()
        
        let element = array[indexPath.row]
        dict.updateValue(element, forKey: "chosenPayInPays")
        
        NotificationCenter.default.post(name: NSNotification.Name("chooseCellInPays"), object: nil, userInfo: dict)
    }
}
