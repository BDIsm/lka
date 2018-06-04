//
//  MyCollectionViewCell.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 04.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class docViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var paysCollection: UICollectionView!
    
    var overdue = [classPayments]()
    var actual = [classPayments]()
    
    init(frame: CGRect, overdue: [classPayments], actual: [classPayments]) {
        super.init(frame: frame)
        self.overdue = overdue
        self.actual = actual
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func customize() {
        number.layer.cornerRadius = 10
        date.layer.cornerRadius = 10
        
        paysCollection.dataSource = self
        paysCollection.delegate = self
        
        self.layer.masksToBounds = false
        
        self.backgroundColor = UIColor.white
        //Shape
        self.layer.cornerRadius = 10.0
        //Shadow
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10.0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section != 0 {
            if overdue.count == 0 {
                return UIEdgeInsetsMake(0, 0, 0, 10)
            }
            else {
                return UIEdgeInsetsMake(0, 10, 0, 10)
            }
        }
        else {
            return UIEdgeInsetsMake(0, 10, 0, 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            print(overdue.count)
            return overdue.count
        }
        else {
            return actual.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "payCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! payViewCell
        
        if indexPath.section == 0 {
            let element = overdue[indexPath.row]
            cell.customize(image: #imageLiteral(resourceName: "red"), a: element.accrual, d: element.date)
        }
        else {
            let element = actual[indexPath.row]
            cell.customize(image: #imageLiteral(resourceName: "blue"), a: element.accrual, d: element.date)
        }
        
        return cell
    }
}
