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
    
    var overdue = [classPayments]()
    var actual = [classPayments]()
    var payed = [classPayments]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! forPaysViewCell
        
        cell.customize()
        
        if cell.frame.height == 200 {
            cell.paysCollection.frame.origin.y -= 70
            cell.paysCollection.frame.size.height = 130
        }
        
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
