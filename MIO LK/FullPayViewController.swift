//
//  FullPayViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 09.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class FullPayViewController: UIViewController {
    var element: classPayments?
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var imageBack: UIImageView!
    
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var period: UILabel!
    @IBOutlet weak var document: UILabel!
    
    @IBOutlet weak var payButton: UIButton!
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.tabBarController?.tabBar.alpha = 1
            self.view.alpha = 0
        }) { (true) in
            self.view.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Тень
        content.layer.shadowColor = UIColor.lightGray.cgColor
        content.layer.shadowOpacity = 0.8
        content.layer.shadowOffset = CGSize.zero
        content.layer.shadowRadius = 10.0
        content.layer.masksToBounds = false
        
        content.layer.cornerRadius = 10
        imageBack.layer.cornerRadius = 10
        
        date.layer.cornerRadius = 10
        number.layer.cornerRadius = 10
        
        let radiusPath = UIBezierPath(roundedRect: payButton.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = radiusPath.cgPath
        maskLayer.frame = payButton.bounds
        
        payButton.layer.mask = maskLayer
        
        UIView.animate(withDuration: 0.5) {
            self.tabBarController?.tabBar.alpha = 0
        }
        
        if element != nil {
            switch element!.status {
            case "Оплачено":
                imageBack.image = #imageLiteral(resourceName: "gray")
            case "Не оплачено (неоплаченное начисление прошлого периода)":
                imageBack.image = #imageLiteral(resourceName: "red")
            default:
                imageBack.image = #imageLiteral(resourceName: "blue")
            }
            
            date.text = "от \(element!.date)"
            type.text = element!.type
            period.text = element!.period
            document.text = element!.docId
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
