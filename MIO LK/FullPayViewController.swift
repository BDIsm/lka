//
//  FullPayViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 09.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit
import SafariServices

class FullPayViewController: UIViewController, SFSafariViewControllerDelegate {
    let defaults = UserDefaults.standard
    
    var close = Bool()
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var imageBack: UIImageView!
    
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var period: UILabel!
    @IBOutlet weak var document: UILabel!
    
    @IBOutlet weak var payButton: UIButton!
    
    
    @IBAction func pressPay(_ sender: UIButton) {
        let urlString = "https://www.gosuslugi.ru/help/faq/avtovladelcam/2015"
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            vc.title = "Оплата"
            
            UIApplication.shared.statusBarStyle = .default
            
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                    topController.title = "Оплата"
                }
                
                topController.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func viewIsMoving(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        let edgePoint = UIScreen.main.bounds.height*9/40
        
        if close { // предотвращение вызова при анимации закрытия
        }
        else {
            if self.view.frame.origin.y > edgePoint { // контроллер прошел через точку закрытия
                removeFromParentViewController()
                close = true
            }
            else {
                if self.view.frame.origin.y+translation.y <= 30 { // попытка поднять контроллер выше начального положения
                }
                else {
                    self.view.frame.origin.y += translation.y
                    if let vc = parent as? DocViewController {
                        scaleOnDragg(view: vc.content, frame: vc.view.frame, edge: edgePoint) // увеличение заднего контроллера
                    }
                    else if let vc = parent as? PayViewController {
                        scaleOnDragg(view: vc.content, frame: vc.view.frame, edge: edgePoint)
                    }
                }
                
                if sender.state == .ended {
                    if let vc = parent as? DocViewController {
                        animateOnDraggingEnding(view: vc.content, frame: vc.view.frame) // анимация, если контроллер не закрыли
                    }
                    else if let vc = parent as? PayViewController {
                        animateOnDraggingEnding(view: vc.content, frame: vc.view.frame)
                    }
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
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        if let vc = parent! as? DocViewController {
            moveTo(view: vc.content, frame: vc.view.frame)
        }
        else if let vc = parent! as? PayViewController {
            moveTo(view: vc.content, frame: vc.view.frame)
        }
    }
    
    override func removeFromParentViewController() {
        if let vc = parent as? DocViewController {
            removeFrom(view: vc.content, frame: vc.view.frame)
        }
        else if let vc = parent as? PayViewController {
            removeFrom(view: vc.content, frame: vc.view.frame)
        }
    }
    
    func moveTo(view: UIView, frame: CGRect) {
        self.tabBarController?.tabBar.isHidden = true
        
        let scaleX = 1-20/frame.width
        let scaleY = 1-40/frame.height
        
        // Указание размеров контроллера с начислением
        self.view.frame = CGRect(x: 0, y: frame.maxY-40, width: frame.width, height: frame.height-20)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .preferredFramesPerSecond60, animations: {
            let transformScale = CGAffineTransform(scaleX: scaleX, y: scaleY)
            view.transform = transformScale
            
            // Смена статус бара
            UIApplication.shared.statusBarStyle = .lightContent
            // Закругление углов
            view.layer.cornerRadius = 10
            // Анимация child контроллера
            self.view.frame.origin.y = 30
        }) { (true) in
            self.shadow(opacity: 0.8, color: .lightGray, radius: 10.0)
            view.isUserInteractionEnabled = false
        }
    }
    
    func removeFrom(view: UIView, frame: CGRect) {
        self.tabBarController?.tabBar.isHidden = false
        
        self.shadow(opacity: 0, color: .white, radius: 0)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .preferredFramesPerSecond60, animations: {
            let transformScale = CGAffineTransform(scaleX: 1, y: 1)
            view.transform = transformScale
            
            // Смена статус бара
            UIApplication.shared.statusBarStyle = .default
            
            // Закругление углов
            view.layer.cornerRadius = 0
            // Анимация child контроллера
            self.view.frame.origin.y = frame.maxY-40
        }) { (true) in
            self.view.removeFromSuperview()
            view.isUserInteractionEnabled = true
        }
    }
    
    func scaleOnDragg(view: UIView, frame: CGRect, edge: CGFloat) {
        let scaleX = 1-20/frame.width
        let scaleY = 1-40/frame.height
        
        let multiplicator = self.view.frame.origin.y/edge
        
        let changeScaleX = scaleX+(1-scaleX)*multiplicator
        let changeScaleY = scaleY+(1-scaleY)*multiplicator
        
        let transformScale = CGAffineTransform(scaleX: changeScaleX, y: changeScaleY)
        view.transform = transformScale
    }
    
    func animateOnDraggingEnding(view: UIView, frame: CGRect) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .preferredFramesPerSecond60, animations: {
            let scaleX = 1-20/frame.width
            let scaleY = 1-40/frame.height
            
            let transformScale = CGAffineTransform(scaleX: scaleX, y: scaleY)
            view.transform = transformScale
            
            // Анимация child контроллера
            self.view.frame.origin.y = 30
        }) { (true) in
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
    
    func shadow(opacity: Float, color: UIColor, radius: CGFloat) {
        self.view.layer.shadowColor = color.cgColor
        self.view.layer.shadowOpacity = opacity
        self.view.layer.shadowOffset = CGSize.zero
        self.view.layer.shadowRadius = radius
        
        //Тень
        self.content.layer.shadowColor = color.cgColor
        self.content.layer.shadowOpacity = opacity
        self.content.layer.shadowOffset = CGSize.zero
        self.content.layer.shadowRadius = radius
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
