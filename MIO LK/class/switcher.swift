//
//  switcher.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 31.07.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation
import UIKit

class Switcher {
    static func updateRootVC(){
        let isAuthorized = UserDefaults.standard.bool(forKey: "isAuthorized")
        var rootVC : UIViewController?
        
        print(isAuthorized)
        
        if isAuthorized {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "docLoading") as! InitialViewController
        }
        else {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "auth") as! AuthViewController
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
    }
}
