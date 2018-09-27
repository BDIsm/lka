//
//  mapInfoViewCell.swift
//  MIO LK
//
//  Created by Исматуллоев Бежан on 27.08.2018.
//  Copyright © 2018 Исматуллоев Бежан. All rights reserved.
//

import UIKit

class mapInfoViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let valueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        
        titleLabel.frame = CGRect(x: 10, y: 5, width: 270, height: 15)
        titleLabel.font = UIFont(name: "Ekibastuz-Bold", size: 15.0)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        self.addSubview(titleLabel)
        
        valueLabel.frame = CGRect(x: 10, y: 25, width: 270, height: 25)
        valueLabel.font = UIFont(name: "Ekibastuz-Regular", size: 10.0)
        valueLabel.numberOfLines = 0
        valueLabel.textAlignment = .left
        valueLabel.textColor = .white
        self.addSubview(valueLabel)
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        valueLabel.text = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
