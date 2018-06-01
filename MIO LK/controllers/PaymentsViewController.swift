//
//  PaymentsViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 31.05.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class PaymentsViewController: UIViewController {
    let defaults = UserDefaults.standard

    var overdue = [classPayments]()
    var actual = [classPayments]()
    var payed = [classPayments]()
    
    var overdueHeight = CGFloat()
    var actualHeight = CGFloat()
    var payedHeight = CGFloat()
    
    var overdueScroll = UIScrollView()
    var actualScroll = UIScrollView()
    var payedScroll = UIScrollView()
    
    @IBOutlet weak var scroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = scroll.frame.width-20

        if let savedOverdues = defaults.object(forKey: "overdue") as? Data {
            overdue = NSKeyedUnarchiver.unarchiveObject(with: savedOverdues) as! [classPayments]
        }
        
        overdueScroll.showsHorizontalScrollIndicator = false
        if overdue.count < 12 {
            overdueHeight = 110
            overdueScroll.frame.size = CGSize(width: width, height: 60)
        }
        else {
            overdueHeight = 180
            overdueScroll.frame.size = CGSize(width: width, height: 130)
        }
        
        // Актуальные
        if let savedActual = defaults.object(forKey: "actual") as? Data {
            actual = NSKeyedUnarchiver.unarchiveObject(with: savedActual) as! [classPayments]
        }
        
        actualScroll.showsHorizontalScrollIndicator = false
        if actual.count < 12 {
            actualHeight = 110
            actualScroll.frame.size = CGSize(width: width, height: 60)
        }
        else {
            actualHeight = 180
            actualScroll.frame.size = CGSize(width: width, height: 130)
        }
        
        // Оплаченные
        if let savedPayed = defaults.object(forKey: "payed") as? Data {
            payed = NSKeyedUnarchiver.unarchiveObject(with: savedPayed) as! [classPayments]
        }
        
        payedScroll.showsHorizontalScrollIndicator = false
        if payed.count < 12 {
            payedHeight = 110
            payedScroll.frame.size = CGSize(width: width, height: 60)
        }
        else {
            payedHeight = 180
            payedScroll.frame.size = CGSize(width: width, height: 130)
        }
        
        scroll.contentSize.height = 100+overdueHeight+actualHeight+payedHeight
        
        DispatchQueue.main.async {
            self.addLabelsAndSeparators()
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addLabelsAndSeparators() {
        let xCenter = scroll.bounds.midX
        
        var yPos: CGFloat = 40
        var centerScroll = CGFloat()
        
        let titleOverdue = BALabel()
        titleOverdue.initializeLabel(input: "Просроченные", size: 20, lines: 1, color: UIColor.darkGray)
        titleOverdue.frame.origin = CGPoint(x: 20, y: yPos)
        scroll.addSubview(titleOverdue)
        
        yPos += overdueHeight
        
        centerScroll = (yPos+titleOverdue.frame.maxY)/2
        overdueScroll.center = CGPoint(x: xCenter, y: centerScroll)
        
        scroll.addSubview(overdueScroll)
        DispatchQueue.main.async {
            self.addPaysToScroll(scrll: &self.overdueScroll, array: self.overdue, height: self.overdueHeight, background: "red", completion: {_ in
                
            })
        }
        
        let separator = UIView(frame: CGRect(x: 10, y: yPos, width: view.frame.width-20, height: 0.5))
        separator.backgroundColor = UIColor(white: 0.7, alpha: 1)
        scroll.addSubview(separator)
        
        yPos += 20
        
        //Текущие начисления
        let titleActual = BALabel()
        titleActual.initializeLabel(input: "Текущие", size: 20, lines: 1, color: UIColor.darkGray)
        titleActual.frame.origin = CGPoint(x: 20, y: yPos)
        scroll.addSubview(titleActual)
        
        yPos += actualHeight
        
        centerScroll = (yPos+titleActual.frame.maxY)/2
        actualScroll.center = CGPoint(x: xCenter, y: centerScroll)
        
        scroll.addSubview(actualScroll)
        DispatchQueue.main.async {
            self.addPaysToScroll(scrll: &self.actualScroll, array: self.actual, height: self.actualHeight, background: "blue", completion: {_ in
                
            })
        }
        
        let separator1 = UIView(frame: CGRect(x: 10, y: yPos, width: view.frame.width-20, height: 0.5))
        separator1.backgroundColor = UIColor(white: 0.7, alpha: 1)
        scroll.addSubview(separator1)
        
        yPos += 20
        
        // Оплаченные
        let titlePayed = BALabel()
        titlePayed.initializeLabel(input: "Оплаченные", size: 20, lines: 1, color: UIColor.darkGray)
        titlePayed.frame.origin = CGPoint(x: 20, y: yPos)
        scroll.addSubview(titlePayed)
        
        yPos += payedHeight
        
        centerScroll = (yPos+titlePayed.frame.maxY)/2
        payedScroll.center = CGPoint(x: xCenter, y: centerScroll)
        
        scroll.addSubview(payedScroll)
        DispatchQueue.main.async {
            self.addPaysToScroll(scrll: &self.payedScroll, array: self.payed, height: self.payedHeight, background: "gray", completion: { _ in
                
            })
        }
        
        let separator2 = UIView(frame: CGRect(x: 10, y: yPos, width: view.frame.width-20, height: 0.5))
        separator2.backgroundColor = UIColor(white: 0.7, alpha: 1)
        scroll.addSubview(separator2)
    }
    
    func addPaysToScroll(scrll: inout UIScrollView, array: [classPayments], height: CGFloat, background: String, completion: @escaping (UIScrollView) -> Void) {
            let indicator = UIActivityIndicatorView()
            indicator.frame.origin = CGPoint(x: (scroll.frame.width-indicator.frame.width)/2, y: scroll.bounds.midY-indicator.frame.height/2)
            indicator.activityIndicatorViewStyle = .gray
            indicator.hidesWhenStopped = true
            scrll.addSubview(indicator)
            indicator.startAnimating()
            
            if height == 110 {
                scrll.contentSize.width = 10+CGFloat(array.count)*70
            }
            else {
                scrll.contentSize.width = 10+CGFloat(array.count/2+1)*70
            }
            
            if array.count == 0 {
                scrll.contentSize.width = scroll.frame.width
                
                let label = BALabel()
                label.initializeLabel(input: "Нет начислений", size: 20, lines: 1, color: UIColor.gray)
                label.center = CGPoint(x: scrll.bounds.midX, y: scrll.bounds.midY)
                scrll.addSubview(label)
                
                indicator.stopAnimating()
            }
            else {
                DispatchQueue.main.async { [scrll] in
                    let scrll = scrll
                    for i in 0..<array.count {
                        
                        var xPos = CGFloat()
                        var yPos = CGFloat()
                        
                        if height == 110 {
                            xPos = 10+CGFloat(i)*70
                        }
                        else {
                            let rest = CGFloat(i).truncatingRemainder(dividingBy: 2)
                            
                            xPos = 10+CGFloat(i/2)*70
                            yPos = rest*70
                        }
                    
                    let cell = viewPayment(frame: CGRect(x: xPos, y: yPos, width: 60, height: 60))
                    cell.customize(status: background, amount: array[i].accrual, date: array[i].date)
                    
                    scrll.addSubview(cell)
                    completion(scrll)
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
