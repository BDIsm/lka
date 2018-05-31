//
//  ContractsViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 29.05.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class ContractsViewController: UIViewController {
    let defaults = UserDefaults.standard
    
    var documents = [classDocuments]()
    var payments = [classPayments]()
    
    var payDict = [String:[classPayments]]()
    
    let inactiveQueue = DispatchQueue(
        label: "com.payments.Queue",
        attributes: .concurrent)
    
    @IBOutlet weak var scroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedDocs = defaults.object(forKey: "documents") as? Data {
            documents = NSKeyedUnarchiver.unarchiveObject(with: savedDocs) as! [classDocuments]
        }
        
        if let savedPays = defaults.object(forKey: "sortPayments") as? Data {
            payDict = NSKeyedUnarchiver.unarchiveObject(with: savedPays) as! [String:[classPayments]]
        }
        
        addDocuments()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addDocuments() {
        let height = self.view.frame.height*2/3
        let width = self.view.frame.width-20
        
        scroll.contentSize.height = 60+CGFloat(documents.count)*(height+20)
        
        //DispatchQueue.main.async {
            for i in 0..<self.documents.count {
                let element = self.documents[i]
                
                let yPos = 60+(height+20)*CGFloat(i)
                
                let docView = viewDocument(frame: CGRect(x: 10, y: yPos, width: width, height: height))
                docView.addSeparators(number: element.number, date: element.date, type: element.type, owner: element.owner, address: element.address, rent: element.rent)
                
                let payScrollView = UIScrollView(frame: CGRect(x: 0, y: docView.bounds.maxY - 70, width: docView.bounds.width, height: 60))
                payScrollView.showsHorizontalScrollIndicator = false
                
                docView.addSubview(payScrollView)
                
                let indicator = UIActivityIndicatorView()
                indicator.frame.origin = CGPoint(x: (payScrollView.frame.width-indicator.frame.width)/2, y: payScrollView.bounds.midY-indicator.frame.height/2)
                indicator.activityIndicatorViewStyle = .gray
                indicator.hidesWhenStopped = true
                payScrollView.addSubview(indicator)
                indicator.startAnimating()
                
                self.scroll.addSubview(docView)
                
                DispatchQueue.main.async {
                    self.addPaysToScroll(id: element.id, scroll: payScrollView, indicator: indicator)
                }
            }
        //}
    }
    
    func addPaysToScroll(id: String, scroll: UIScrollView, indicator: UIActivityIndicatorView) {
        var overdue = [classPayments]()
        var actual = [classPayments]()
        
        if payDict["\(id)Overdue"] != nil {
            overdue = payDict["\(id)Overdue"]!
        }
        if payDict["\(id)Actual"] != nil {
            actual = payDict["\(id)Actual"]!
        }
        
        let numberOverdues = overdue.count
        let numberActuals = actual.count
        
        scroll.contentSize.width = 10+CGFloat(numberActuals+numberOverdues)*70
        
        if numberOverdues == 0 && numberActuals == 0 {
            scroll.contentSize.width = scroll.frame.width
            
            let label = BALabel()
            label.initializeLabel(input: "Нет актуальных начислений", size: 20, lines: 1, color: UIColor.gray)
            label.center = CGPoint(x: scroll.bounds.midX, y: scroll.bounds.midY)
            scroll.addSubview(label)
            
            indicator.stopAnimating()
        }
        else {
            DispatchQueue.main.async {
                if numberOverdues != 0 {
                    for i in 0..<numberOverdues {
                        let xPos = 10+CGFloat(i)*70
                        
                        let cell = viewPayment(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
                        cell.customize(status: "red", amount: overdue[i].accrual, date: overdue[i].date)
                        cell.frame.origin = CGPoint(x: xPos, y: 0)
                        
                        scroll.addSubview(cell)
                    }
                    indicator.stopAnimating()
                }
            }
            
            DispatchQueue.main.async {
                if numberActuals != 0 {
                    for i in 0..<numberActuals {
                        let xPos = 10+CGFloat(numberOverdues)*70+CGFloat(i)*70
                        
                        let cell = viewPayment(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
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
