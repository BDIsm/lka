//
//  infoMapView.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 24.08.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import Foundation
import UIKit

class infoMapView: UIView, UITableViewDelegate, UITableViewDataSource {
    private let reuse = "infoMapCell"
    
    let infoTable = UITableView()
    
    var document: classDocuments?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        shape()
        gradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .white
        
        shape()
        gradient()
    }
    
    func addInfoTable() {
        infoTable.frame = self.bounds.insetBy(dx: 5, dy: 5)
        infoTable.backgroundColor = .clear
        
        infoTable.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        infoTable.separatorColor = UIColor(white: 0.9, alpha: 1)
        infoTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: infoTable.frame.width, height: 1))
        
        infoTable.delegate = self
        infoTable.dataSource = self
        
        infoTable.register(mapInfoViewCell.self, forCellReuseIdentifier: reuse)
        self.addSubview(infoTable)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 25
        default:
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = infoTable.dequeueReusableCell(withIdentifier: reuse, for: indexPath) as? mapInfoViewCell else {
            fatalError("oh shit")
        }
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Договор №\(document?.number ?? "б/н") от \(document?.date ?? "нет даты")"
            cell.titleLabel.textAlignment = .center
            
            cell.valueLabel.removeFromSuperview()
        case 1:
            cell.titleLabel.text = "Объект:"
            cell.valueLabel.text = document?.type
        case 2:
            cell.titleLabel.text = "Адрес:"
            cell.valueLabel.text = document?.address
        case 3:
            cell.titleLabel.text = "Арендодатель:"
            cell.valueLabel.text = document?.owner
        default: break
        }
        
        return cell
    }
    
    func gradient() {
        let colorTop =  UIColor(red: 44.0/255.0, green: 191.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        let colorBottom = UIColor(red: 38.0/255.0, green: 127.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
    
    func shape() {
        let bounds = self.bounds
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height-5), cornerRadius: 20)
        
        path.move(to: CGPoint(x: bounds.midX-10, y: bounds.maxY-5))
        path.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.midX+10, y: bounds.maxY-5))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        self.layer.mask = shapeLayer
    }
}
