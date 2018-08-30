//
//  TabBarController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 07.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    let line = UIImageView()
    
    var offline = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Ekibastuz-Bold", size: 10)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Ekibastuz-Black", size: 10)!], for: .selected)

        let fullLine = UIImageView(frame: CGRect(x: 0, y: -1, width: self.tabBar.frame.width, height: 0.5))
        fullLine.backgroundColor = UIColor(white: 0.8, alpha: 1.0)

        self.tabBar.addSubview(fullLine)
        
        let image = UIImageView(frame: self.tabBar.bounds.insetBy(dx: 0, dy: -1))
        image.backgroundColor = .white

        self.tabBar.insertSubview(image, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        if item == (self.tabBar.items)![0]{
//            UIView.animate(withDuration: 0.5) {
//                self.line.frame.origin.x = 0
//            }
//        }
//        else if item == (self.tabBar.items)![1]{
//            UIView.animate(withDuration: 0.5) {
//                self.line.frame.origin.x = self.tabBar.frame.width/4
//            }
//        }
//        else if item == (self.tabBar.items)![2]{
//            UIView.animate(withDuration: 0.5) {
//                self.line.frame.origin.x = self.tabBar.frame.width/4*2
//            }
//        }
//        else {
//            UIView.animate(withDuration: 0.5) {
//                self.line.frame.origin.x = self.tabBar.frame.width/4*3
//            }
//        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
