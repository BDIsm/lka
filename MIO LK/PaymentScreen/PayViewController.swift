//
//  PayViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 04.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class PayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let reuseIdentifier = "forPays"
    
    let defaults = UserDefaults.standard
    let request = classRequest()
    let payNot = NSNotification.Name("pay")
    
    var numberOfPays = Int()
    
    var documents = [classDocuments]()
    var overdue = [classPayments]()
    var actual = [classPayments]()
    var payed = [classPayments]()

    @IBOutlet weak var content: UIView!
    @IBOutlet weak var collection: UICollectionView!
    
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.isScrollEnabled = true
        
        self.refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refreshStream), for: .valueChanged)
        collection.addSubview(refresher)
        
        if let savedDocs = defaults.object(forKey: "documents") as? Data {
            documents = NSKeyedUnarchiver.unarchiveObject(with: savedDocs) as! [classDocuments]
        }
        if let savedOverdues = defaults.object(forKey: "overdue") as? Data {
            overdue = NSKeyedUnarchiver.unarchiveObject(with: savedOverdues) as! [classPayments]
        }
        // Актуальные
        if let savedActual = defaults.object(forKey: "actual") as? Data {
            actual = NSKeyedUnarchiver.unarchiveObject(with: savedActual) as! [classPayments]
        }
        // Оплаченные
        if let savedPayed = defaults.object(forKey: "payed") as? Data {
            payed = NSKeyedUnarchiver.unarchiveObject(with: savedPayed) as! [classPayments]
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(showFullPayment(notification: )), name: NSNotification.Name("chooseCellInPays"), object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func refreshStream() {
        NotificationCenter.default.addObserver(self, selector: #selector(payComplete), name: payNot, object: nil)
        
        numberOfPays = 0
        let uuid = defaults.object(forKey: "uuid") as! String
        
        request.allOverdues.removeAll()
        request.allActual.removeAll()
        request.allPayed.removeAll()
        
        for i in documents {
            request.getPaymentsFromBack(uuid, id: i.id)
        }
    }
    
    @objc func payComplete() {
        self.numberOfPays += 1
        print(numberOfPays, documents.count)
        if numberOfPays == documents.count {
            NotificationCenter.default.removeObserver(self, name: payNot, object: nil)
            
            overdue.removeAll()
            actual.removeAll()
            payed.removeAll()
            
            if let savedOverdues = defaults.object(forKey: "overdue") as? Data {
                overdue = NSKeyedUnarchiver.unarchiveObject(with: savedOverdues) as! [classPayments]
            }
            // Актуальные
            if let savedActual = defaults.object(forKey: "actual") as? Data {
                actual = NSKeyedUnarchiver.unarchiveObject(with: savedActual) as! [classPayments]
            }
            // Оплаченные
            if let savedPayed = defaults.object(forKey: "payed") as? Data {
                payed = NSKeyedUnarchiver.unarchiveObject(with: savedPayed) as! [classPayments]
            }
            
            DispatchQueue.main.async {
                self.collection.reloadData()
                self.refresher.endRefreshing()
            }
        }
    }
    
    @objc func showFullPayment(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String,classPayments> {
            if let element = userInfo["chosenPayInPays"] {
                let controller = storyboard?.instantiateViewController(withIdentifier: "fullPay") as! FullPayViewController
                self.addChildViewController(controller)
                
                // Настройка контроллера
                self.view.addSubview(controller.view)
                controller.setLabels(element: element)
                
                controller.didMove(toParentViewController: self)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width-20
        
        if indexPath.row == 0 {
            let size = getHeight(array: overdue, width: width)
            return size
        }
        else if indexPath.row == 1 {
            return getHeight(array: actual, width: width)
        }
        else {
            return getHeight(array: payed, width: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 40, left: 0, bottom: 20, right: 0)
        }
        else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! forPaysViewCell
        
        cell.customize()
        
        if indexPath.row == 0 {
            cell.titleLabel.text = "Просроченные"
            cell.array = overdue
        }
        else if indexPath.row == 1 {
            cell.titleLabel.text = "Текущие"
            cell.array = actual
        }
        else {
            cell.titleLabel.text = "Оплаченные"
            cell.array = payed
            cell.line.isHidden = true
        }
        cell.paysCollection.reloadData()
        
        cell.layoutSubviews()
        cell.line.frame.origin.y = cell.bounds.maxY-1
        
        if cell.frame.height == 200 {
            cell.paysCollection.frame.size.height = 130
            cell.paysCollection.frame.origin.y = 60
        }
        else {
            cell.paysCollection.frame.size.height = 60
            cell.paysCollection.frame.origin.y = 60
        }
        
        return cell
    }
    
    func getHeight(array: [classPayments], width: CGFloat) -> CGSize {
        switch array.count {
        case 0...12:
            return CGSize(width: width, height: 130)
        default:
            return CGSize(width: width, height: 200)
        }
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
