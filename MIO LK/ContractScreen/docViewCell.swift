//
//  MyCollectionViewCell.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 04.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit
import GoogleMaps

class docViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var map: GMSMapView!
    @IBOutlet weak var paysCollection: UICollectionView!
    
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
    
    var coordinates: CLLocationCoordinate2D? {
        didSet {
            let marker = GMSMarker()
            marker.position = coordinates!
            marker.icon = GMSMarker.markerImage(with: UIColor.darkGray)
            marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
            marker.title = self.docAddress
            marker.snippet = "Земельный участок"
            marker.map = self.map
            
            let camera = GMSCameraPosition.camera(withLatitude: coordinates!.latitude, longitude: coordinates!.longitude, zoom: 9.0)
            self.map.animate(to: camera)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.map.clear()
        self.paysCollection.reloadData()
        
        // reset custom properties to default values
    }
    
    func customize() {
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
            if overdue?.count == 0 {
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
                cell.customize(image: #imageLiteral(resourceName: "red"), a: element.accrual, d: element.date)
            }
        }
        else {
            if actual != nil {
                let element = actual![indexPath.row]
                cell.customize(image: #imageLiteral(resourceName: "blue"), a: element.accrual, d: element.date)
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
