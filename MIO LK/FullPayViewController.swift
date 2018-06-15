//
//  FullPayViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 09.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class FullPayViewController: UIViewController {
    let defaults = UserDefaults.standard
    
    var frame = CGRect()
    var frameLayout = CGRect()
    
    var center = CGPoint()
    
    var close = Bool()
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var imageBack: UIImageView!
    
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var period: UILabel!
    @IBOutlet weak var document: UILabel!
    
    @IBOutlet weak var payButton: UIButton!
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        removeFromParentViewController()
    }
    
    @IBAction func viewIsMoving(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        let borderPoint = UIScreen.main.bounds.height*1/4
        if close {
        }
        else {
            if self.view.center.y+translation.y >= center.y {
                self.view.center.y += translation.y
                if self.view.frame.origin.y > borderPoint {
                    removeFromParentViewController()
                    close = true
                }
                else {
                    let multiplicator = self.view.frame.origin.y/borderPoint
                    
                    let xPos = 10*(1-multiplicator)
                    let yPos = 20*(1-multiplicator)
                    let width = frame.width-20*(1-multiplicator)
                    
                    frameLayout = CGRect(x: xPos, y: yPos, width: width, height: frame.height)
                    
                    let vc = parent as! DocViewController
                    vc.view.frame = frameLayout
                    vc.docsCollection.reloadData()
                }
            }
        }
        
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Настройка контроллера
        self.view.layer.masksToBounds = false
        self.view.layer.cornerRadius = 10
        
        self.view.layer.shadowColor = UIColor.lightGray.cgColor
        self.view.layer.shadowOpacity = 0.8
        self.view.layer.shadowOffset = CGSize.zero
        self.view.layer.shadowRadius = 10.0
        
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
        
        // Углы у кнопки
        let radiusPath = UIBezierPath(roundedRect: payButton.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = radiusPath.cgPath
        maskLayer.frame = payButton.bounds
        
        payButton.layer.mask = maskLayer
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        self.tabBarController?.tabBar.isHidden = true
        
        frame = parent!.view.frame
        frameLayout = CGRect(x: 10, y: 20, width: frame.width-20, height: frame.height)
        
        // Указание размеров контроллера с начислением
        self.view.frame.origin = CGPoint(x: -10, y: frame.maxY-40)
        self.view.frame.size = CGSize(width: frame.width+20, height: frame.height-20)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .preferredFramesPerSecond60, animations: {
            // Смена статус бара
            UIApplication.shared.statusBarStyle = .lightContent
            // Уменьшение родительского контроллера
            parent!.view.frame.origin = self.frameLayout.origin
            parent!.view.frame.size = self.frameLayout.size
            // Закругление углов
            parent!.view.layer.cornerRadius = 10
            // Анимация child контроллера
            self.view.frame.origin = CGPoint(x: -10, y: 10)
        }) { (true) in
            self.center = self.view.center
        }
    }
    
    override func removeFromParentViewController() {
        self.tabBarController?.tabBar.isHidden = false
        
        let vc = parent as! DocViewController
        frameLayout = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .preferredFramesPerSecond60, animations: {
            // Смена статус бара
            UIApplication.shared.statusBarStyle = .default
            // Увеличение родительского контроллера
            vc.view.frame.origin = self.frameLayout.origin
            vc.view.frame.size = self.frameLayout.size
            // Закругление углов
            vc.view.layer.cornerRadius = 0
            // Анимация child контроллера
            self.view.frame.origin = CGPoint(x: -10, y: self.frame.maxY-40)
        }) { (true) in
            //vc.docsCollection.
        }
    }
    
    func setLabels(element: classPayments) {
        switch element.status {
        case "Оплачено":
            imageBack.image = #imageLiteral(resourceName: "gray")
        case "Не оплачено (неоплаченное начисление прошлого периода)":
            imageBack.image = #imageLiteral(resourceName: "red")
        default:
            imageBack.image = #imageLiteral(resourceName: "blue")
        }
        
        date.text = "от \(element.date)"
        type.text = element.type
        period.text = element.period
        document.text = element.docId
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
