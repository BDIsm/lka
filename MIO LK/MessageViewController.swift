//
//  MessageViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 06.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    
    var leftFrame = CGRect()
    var rightFrame = CGRect()
    
    var greeting = messageView()
    
    var techButt = buttonView()
    var contractButt = buttonView()
    
    var collection = collectionDoc()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftFrame = leftLabel.frame
        
        contentView.frame = CGRect(x: 0, y: scroll.bounds.maxY, width: scroll.frame.width, height: 0)
        
        addGreeting()
        addButtons()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addGreeting() {
        let text = "Добрый день!\nПрежде чем написать нам свою хрень, пожалуйста, выберите категорию или засуньте палец себе поглубже в задницу, вы – потные драные тролли!"
        
        greeting = messageView(frame: leftFrame, text: text, width: leftFrame.width)
        greeting.frame.origin = CGPoint(x: 8, y: 8)
        
        let heightAdd = greeting.frame.height+16
        contentView.frame.size.height += heightAdd
        contentView.frame.origin.y -= heightAdd
        
        print(greeting.frame)

        contentView.addSubview(greeting)
    }
    
    func addButtons() {
        let originOne = CGPoint(x: 8, y: greeting.frame.height+16)
        let size = CGSize(width: greeting.frame.width/2-2, height: 50)
        
        techButt = buttonView(frame: CGRect(origin: originOne, size: size), title: "Тех. поддержка")
        techButt.addTarget(self, action: #selector(technical), for: .touchUpInside)
        
        let originTwo = CGPoint(x: techButt.frame.width+12, y: greeting.frame.height+16)
        
        contractButt = buttonView(frame: CGRect(origin: originTwo, size: size), title: "Вопрос по договору")
        contractButt.addTarget(self, action: #selector(contractsShow), for: .touchUpInside)
        
        
        let heightAdd = techButt.frame.height+8
        contentView.frame.size.height += heightAdd
        contentView.frame.origin.y -= heightAdd
        
        contentView.addSubview(techButt)
        contentView.addSubview(contractButt)
    }
    
    @objc func technical() {
        print("YEAH")
    }
    
    @objc func contractsShow() {
        print("YEAH")
        collection.frame = CGRect(x: 8, y: techButt.frame.maxY+8, width: scroll.frame.width-16, height: 150)
        collection.collection(items: 100, w: greeting.frame.width)
        
        
        let heightAdd = collection.frame.height+8
        contentView.frame.size.height += heightAdd
        contentView.frame.origin.y -= heightAdd
        
        contentView.addSubview(collection)
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 20, left: 8, bottom: 5, right: 8)
    }*/
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
