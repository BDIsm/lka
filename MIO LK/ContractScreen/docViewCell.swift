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
    @IBOutlet weak var rent: UILabel!
    
    @IBOutlet weak var paysCollection: UICollectionView!
    
    var noPays = UILabel()
    
    var docType: String? {
        didSet {
            type.text = docType
        }
    }
    
    var docOwner: String? {
        didSet {
            owner.text = docOwner
        }
    }
    
    var docAddress: String? {
        didSet {
            address.text = docAddress
        }
    }
    
    var docRent: String? {
        didSet {
            rent.text = docRent
        }
    }
    
    var docNumber: String? {
        didSet {
            number.text = docNumber
        }
    }
    
    var docDate: String? {
        didSet {
            date.text = docDate
        }
    }
    
    var overdue: [classPayments]? {
        didSet {
            paysCollection.dataSource = self
            paysCollection.delegate = self
        }
    }
    
    var actual: [classPayments]? {
        didSet {
            paysCollection.dataSource = self
            paysCollection.delegate = self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //self.paysCollection.reloadData()
        noPays.removeFromSuperview()
    }
    
    func customize() {
        self.layer.masksToBounds = false
        
        self.backgroundColor = UIColor.white
        
        self.layer.cornerRadius = 20.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 12.0
        self.layer.shadowOpacity = 0.7
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section != 0 {
            if overdue?.count == 0 {
                return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 10)
            }
            else {
                return UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
            }
        }
        else {
            return UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if overdue != nil {
                return overdue!.count
            }
            else {
                return 0
            }
        }
        else {
            if actual != nil {
                return actual!.count
            }
            else {
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "payCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! payViewCell
        
        if indexPath.section == 0 {
            if overdue != nil {
                let element = overdue![indexPath.row]
                cell.customize(element.status, element.accrual, element.date)
            }
        }
        else {
            if actual != nil {
                let element = actual![indexPath.row]
                cell.customize(element.status, element.accrual, element.date)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dict = [String: classPayments]()
        
        if indexPath.section == 0 {
            let element = overdue![indexPath.row]
            dict.updateValue(element, forKey: "chosenPayInDoc")
        }
        else {
            let element = actual![indexPath.row]
            dict.updateValue(element, forKey: "chosenPayInDoc")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("chooseCellInDocs"), object: nil, userInfo: dict)
    }
}
