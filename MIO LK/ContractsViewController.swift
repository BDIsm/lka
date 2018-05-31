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
    
    let inactiveQueue = DispatchQueue(
        label: "com.payments.Queue",
        attributes: .concurrent)
    
    @IBOutlet weak var scroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedDocs = defaults.object(forKey: "documents") as? Data {
            documents = NSKeyedUnarchiver.unarchiveObject(with: savedDocs) as! [classDocuments]
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
        
        DispatchQueue.main.async {
            for i in 0..<self.documents.count {
                let element = self.documents[i]
                
                let yPos = 60+(height+20)*CGFloat(i)
                
                let docView = viewDocument(frame: CGRect(x: 10, y: yPos, width: width, height: height))
                docView.addSeparators(number: element.number, date: element.date, type: element.type, owner: element.owner)
                
                let payScrollView = UIScrollView(frame: CGRect(x: 0, y: docView.bounds.maxY - 70, width: docView.bounds.width, height: 60))
                payScrollView.showsHorizontalScrollIndicator = false
                
                docView.addSubview(payScrollView)
                /*let indicator = UIActivityIndicatorView()
                 indicator.frame.origin = CGPoint(x: (docView.frame.width-indicator.frame.width)/2, y: docView.bounds.midY-indicator.frame.height/2)
                 indicator.activityIndicatorViewStyle = .gray
                 indicator.hidesWhenStopped = true
                 docView.addSubview(indicator)
                 indicator.startAnimating()*/
                
                self.scroll.addSubview(docView)
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
