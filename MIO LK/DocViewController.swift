//
//  PayViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 04.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class DocViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let defaults = UserDefaults.standard
    
    var documents = [classDocuments]()
    var payDict = [String:[classPayments]]()
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    
    @IBOutlet weak var docsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedDocs = defaults.object(forKey: "documents") as? Data {
            documents = NSKeyedUnarchiver.unarchiveObject(with: savedDocs) as! [classDocuments]
        }
        
        if let savedPays = defaults.object(forKey: "sortPayments") as? Data {
            payDict = NSKeyedUnarchiver.unarchiveObject(with: savedPays) as! [String:[classPayments]]
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! docViewCell
        
        let element = documents[indexPath.row]
        
        if payDict["\(element.id)Overdue"] != nil {
            cell.overdue = payDict["\(element.id)Overdue"]!
        }
        if payDict["\(element.id)Actual"] != nil {
            cell.actual = payDict["\(element.id)Actual"]!
        }
        
        cell.customize()
        
        cell.number.text = "№ \(element.number)"
        cell.date.text = "от \(element.date)"
        
        cell.type.text = element.type
        cell.owner.text = element.owner
        cell.address.text = element.address
        
        cell.paysCollection.reloadData()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "reusableView", for: indexPath) as! settingReusableView
            
            reusableview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
            //do other header related calls or settups
            return reusableview
            
            
        default:  fatalError("Unexpected element kind")
        }
    }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }

    func addPaysToScroll(overdue: [classPayments], actual: [classPayments], oC: Int, aC: Int, scroll: UIScrollView, indicator: UIActivityIndicatorView) {
        print(oC, aC)
        if oC == 0 && aC == 0 {
            let label = BALabel()
            label.initializeLabel(input: "Нет актуальных начислений", size: 20, lines: 1, color: UIColor.gray)
            label.center = CGPoint(x: scroll.bounds.midX, y: scroll.bounds.midY)
            scroll.addSubview(label)
            
            indicator.stopAnimating()
        }
        else {
            DispatchQueue.main.async {
                if oC != 0 {
                    for i in 0..<oC {
                        let xPos = 10+CGFloat(i)*70
                        
                        let cell = viewPayment(frame: CGRect(x: 5, y: 0, width: 60, height: 60))
                        cell.customize(status: "red", amount: overdue[i].accrual, date: overdue[i].date)
                        cell.frame.origin = CGPoint(x: xPos, y: 0)
                        
                        scroll.addSubview(cell)
                    }
                    indicator.stopAnimating()
                }
            }
            
            DispatchQueue.main.async {
                if aC != 0 {
                    for i in 0..<aC {
                        let xPos = 10+CGFloat(oC)*70+CGFloat(i)*70
                        
                        let cell = viewPayment(frame: CGRect(x: 5, y: 0, width: 60, height: 60))
                        cell.customize(status: "blue", amount: actual[i].accrual, date: actual[i].date)
                        cell.frame.origin = CGPoint(x: xPos, y: 0)
                        
                        scroll.addSubview(cell)
                    }
                    indicator.stopAnimating()
                }
            }
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
