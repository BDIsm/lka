//
//  TabBarController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 07.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blur = UIVisualEffectView.init(effect: UIBlurEffect(style: .light))
        blur.frame = self.tabBar.bounds.insetBy(dx: 0, dy: -1)
        
        //let image = UIImageView(frame: self.tabBar.bounds.insetBy(dx: 0, dy: -1))
        //image.backgroundColor = .white
        
        self.tabBar.insertSubview(blur, at: 0)
        self.tabBar.shadowImage = UIImage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == (self.tabBar.items)![0]{
            
        }
        else if item == (self.tabBar.items)![1]{
            
        }
        else {
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
