//
//  NavigationViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 07.08.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let fullLine = UIImageView(frame: CGRect(x: 0, y: self.navigationBar.bounds.maxY+1, width: self.navigationBar.frame.width, height: 0.5))
        fullLine.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        self.navigationBar.addSubview(fullLine)
        
        self.navigationBar.shadowImage = UIImage()
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
