//
//  SupportViewController.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 06.06.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let defaults = UserDefaults.standard
    let reuseIdentifier = "chatCell"
    
    var new = Bool()
    var selectedId = String()
    
    var chats = [classChats]()
    var messages = [classMessages]()
    
    @IBAction func create(_ sender: UIBarButtonItem) {
        new = true
        performSegue(withIdentifier: "toMessages", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedChats = defaults.object(forKey: "chats") as? Data {
            chats = NSKeyedUnarchiver.unarchiveObject(with: savedChats) as! [classChats]
        }
        
        if let savedChatM = defaults.object(forKey: "chatM") as? Data {
            messages = NSKeyedUnarchiver.unarchiveObject(with: savedChatM) as! [classMessages]
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width-20
        let multiple = width/300
        
        return CGSize(width: width, height: 100*multiple)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! chatViewCell
        
        let element = chats[indexPath.row]
        switch element.status {
        case "CURATOR_QUESTION":
            cell.theme = "Вопрос по договору"
        default:
            cell.theme = "Общий вопрос"
        }
        
        let filtered = messages.filter {
            if $0.id == element.id {
                return false
            }
            else {
                return true
            }
        }
        let message = filtered.last
        cell.message = message?.message
        
        cell.date = element.date
        
        return cell
    }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        new = false
        
        let element = chats[indexPath.item]
        selectedId = element.id
        print("You selected cell #\(indexPath.item)!")
        performSegue(withIdentifier: "toMessages", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MessageViewController {
            vc.new = new
            vc.selected = selectedId
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
