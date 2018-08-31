//
//  BrowserViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 22.08.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    let progress = UIProgressView()
    
    var payURL: URL? 
    
    @IBOutlet weak var wk: WKWebView!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true) {
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bar = (navigationController?.navigationBar.bounds)!
        progress.frame.origin = CGPoint(x: 0, y: bar.maxY-1)
        progress.frame.size = CGSize(width: bar.width, height: 1)
        progress.trackTintColor = UIColor(white: 0.97, alpha: 1)
        progress.progressTintColor = UIColor(red:0.00, green:0.59, blue:1.00, alpha:1.0)
        navigationController?.navigationBar.addSubview(progress)

        wk.uiDelegate = self
        wk.navigationDelegate = self
        
        wk.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        let request = URLRequest(url: payURL!)
        wk.load(request)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progress.progress = Float(wk.estimatedProgress)
            if Float(wk.estimatedProgress) == 1.0 {
                progress.isHidden = true
            }
            else {
                progress.isHidden = false
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
