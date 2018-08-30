//
//  PayViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 04.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import MapKit

class DocViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let defaults = UserDefaults.standard
    var offline = Bool()
    
    var documents = [classDocuments]()
    var payDict = [String:[classPayments]]()
    
    let reuseIdentifier = "docViewCell"
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var docsCollection: UICollectionView!
    
    let bgView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = tabBarController as! TabBarController
        let offline: Bool = vc.offline
        if offline {
            let offlineView = viewOffline(frame: CGRect(x: view.bounds.midX-view.frame.width/4.0, y: 20, width: view.frame.width/2.0, height: 40))
            view.addSubview(offlineView)
        }
        
        if let savedDocs = defaults.object(forKey: "documents") as? Data {
            documents = NSKeyedUnarchiver.unarchiveObject(with: savedDocs) as! [classDocuments]
        }
        
        if let savedPays = defaults.object(forKey: "sortPayments") as? Data {
            payDict = NSKeyedUnarchiver.unarchiveObject(with: savedPays) as! [String:[classPayments]]
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(showFullPayment(notification: )), name: NSNotification.Name("chooseCellInDocs"), object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func showFullPayment(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String,classPayments> {
            if let element = userInfo["chosenPayInDoc"] {
                let controller = storyboard?.instantiateViewController(withIdentifier: "fullPay") as! FullPayViewController
                self.addChildViewController(controller)
                
                bgView.frame = self.view.bounds
                bgView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
                self.view.addSubview(bgView)
                
                // Настройка контроллера
                self.view.addSubview(controller.view)
                controller.element = element
                
                controller.didMove(toParentViewController: self)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! docViewCell
        
        let element = documents[indexPath.row]
        
        // Добавление начислений
        if payDict["\(element.id)Overdue"] != nil {
            cell.overdue = payDict["\(element.id)Overdue"]!
        }
        else {
            cell.overdue = []
        }
        if payDict["\(element.id)Actual"] != nil {
            cell.actual = payDict["\(element.id)Actual"]!
        }
        else {
            cell.actual = []
        }
        cell.paysCollection.reloadData()
    
        // Информация в ячейке
        cell.docNumber = "Договор №\(element.number)"
        cell.docDate = "от \(element.date)"
        cell.docType = element.type
        cell.docOwner = element.owner
        cell.docAddress = element.address
        
        if cell.overdue?.count == 0 && cell.actual?.count == 0 {
            cell.noPays.frame = cell.paysCollection.frame
            cell.noPays.font = UIFont.preferredFont(forTextStyle: .title2)
            cell.noPays.textColor = .gray
            cell.noPays.textAlignment = .center
            cell.noPays.text = "Нет текущих начислений"
            cell.addSubview(cell.noPays)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "reusableView", for: indexPath) as! settingReusableView
        
        reusableview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        reusableview.decrease()
        
        return reusableview
    }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
