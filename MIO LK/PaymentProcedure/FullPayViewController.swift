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
    
    var element: classPayments? {
        didSet {
            let background = gradient.setColour(for: content, status: element!.status, radius: 20)
            content.layer.insertSublayer(background.0, at: 0)
            payButton.setTitleColor(background.1, for: .normal)
            
            let arrow = arrowView(origin: topView.center)
            let colors = gradient.setColour(for: arrow, status: element!.status, radius: 0)
            arrow.colorBottom = colors.1
            arrow.colorTop = colors.2
            topView.addSubview(arrow)
            
            if let contract = documents.first(where: {$0.id == element!.docId}) {
                number.text = "по договору №\(contract.number)"
                address.text = contract.address
            }
            
            date.text = element?.date != "" ? element!.date : "не указана"
            type.text = element!.type
            period.text = element!.period
            if let pay = Float(element!.payment), let acc = Float(element!.accrual)  {
                amount.text = "\(acc)₽, из которых оплачено \(acc-pay)₽"
            }
            else {
                amount.text = element?.accrual
            }
            
            switch element?.status {
            case "Оплачено":
                payButton.isEnabled = false
                payButton.setTitle("Оплачено", for: .disabled)
            default:
                if element?.payment != nil {
                    payButton.setTitle("Оплатить "+element!.payment+"₽", for: .normal)
                }
                else {
                    payButton.setTitle("Оплатить", for: .normal)
                }
            }
        }
    }
    
    var documents = [classDocuments]()
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var period: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var payButton: UIButton!
    
    @IBAction func pressPay(_ sender: UIButton) {
        if element?.uin != "<null>" {
            performSegue(withIdentifier: "toPayURL", sender: self)
        }
        else {
            let ac = UIAlertController(title: nil, message: "УИН не найден", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            present(ac, animated: true)
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
        if let savedDocs = defaults.object(forKey: "documents") as? Data {
            documents = NSKeyedUnarchiver.unarchiveObject(with: savedDocs) as! [classDocuments]
        }
        
        // Настройка контроллера
        self.view.layer.masksToBounds = false
        self.view.layer.cornerRadius = 10
        
        content.layer.masksToBounds = false
        content.layer.cornerRadius = 20.0
        content.layer.shadowColor = UIColor.gray.cgColor
        content.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        content.layer.shadowRadius = 12.0
        content.layer.shadowOpacity = 0.7
        
        // Углы у кнопки
        let radiusPath = UIBezierPath(roundedRect: payButton.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 19, height: 19))
        
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
            removeFrom(view: vc.content, frame: vc.view.frame, bg: vc.bgView)
        }
        else if let vc = parent as? PayViewController {
            removeFrom(view: vc.content, frame: vc.view.frame, bg: vc.bgView)
        }
    }
    
    func moveTo(view: UIView, frame: CGRect) {
        let scaleX = 1-20/frame.width
        let scaleY = 1-40/frame.height
        
        // Указание размеров контроллера с начислением
        self.view.frame = CGRect(x: 0, y: frame.maxY-40, width: frame.width, height: frame.height-20)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .preferredFramesPerSecond60, animations: {
            let transformScale = CGAffineTransform(scaleX: scaleX, y: scaleY)
            view.transform = transformScale
            
            self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.maxY
            
            // Смена статус бара
            UIApplication.shared.statusBarStyle = .lightContent
            // Закругление углов
            view.layer.cornerRadius = 10
            // Анимация child контроллера
            self.view.frame.origin.y = 30
        }) { (true) in
            view.isUserInteractionEnabled = false
        }
    }
    
    func removeFrom(view: UIView, frame: CGRect, bg: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .preferredFramesPerSecond60, animations: {
            let transformScale = CGAffineTransform(scaleX: 1, y: 1)
            view.transform = transformScale
            
            let tbFrame = (self.tabBarController?.tabBar.frame)!
            self.tabBarController?.tabBar.frame.origin.y = UIScreen.main.bounds.maxY - tbFrame.height
            
            // Смена статус бара
            UIApplication.shared.statusBarStyle = .default
            
            // Закругление углов
            view.layer.cornerRadius = 0
            
            bg.alpha = 0
            
            // Анимация child контроллера
            self.view.frame.origin.y = frame.maxY-40
        }) { (true) in
            self.view.removeFromSuperview()
            
            bg.removeFromSuperview()
            bg.alpha = 1
            
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UINavigationController {
            if let wkVc = vc.topViewController as? BrowserViewController {
                UIApplication.shared.statusBarStyle = .default
                wkVc.payURL = URL(string: "https://www.gosuslugi.ru/payment/\(element?.uin ?? "")")
            }
        }
    }
    
}
