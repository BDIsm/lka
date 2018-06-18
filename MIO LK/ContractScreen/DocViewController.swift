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
    
    var documents = [classDocuments]()
    var payDict = [String:[classPayments]]()
    
    let reuseIdentifier = "docViewCell"
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var docsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                
                // Настройка контроллера
                self.view.addSubview(controller.view)
                controller.setLabels(element: element)
                
                controller.didMove(toParentViewController: self)
            }
        }
    }
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documents.count
    }
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width-20
        let multiple = width/300
     
        return CGSize(width: width, height: 400*multiple)
    }*/
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! docViewCell
        
        let element = documents[indexPath.row]
        
        // Сбросить карту
        //cell.map.clear()
        
        /* Серая тема для карты
        do {
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                cell.map.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }
            else {
                NSLog("Unable to find style.json")
            }
        }
        catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        // Координаты участка
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = element.address
        
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            if localSearchResponse == nil {
                cell.coordinates = CLLocationCoordinate2D(latitude: 50, longitude: 50)
            }
            else {
                cell.coordinates = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            }
        }*/
        
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
        cell.docNumber = "№ \(element.number)"
        cell.docDate = "от \(element.date)"
        cell.docType = element.type
        cell.docOwner = element.owner
        cell.docAddress = element.address
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //switch kind {
        //case UICollectionElementKindSectionHeader:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "reusableView", for: indexPath) as! settingReusableView
            
            reusableview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
            reusableview.decrease()
            
            return reusableview
        //default:  fatalError("Unexpected element kind")
        //}
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
