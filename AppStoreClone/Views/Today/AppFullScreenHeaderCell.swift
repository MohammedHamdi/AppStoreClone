//
//  AppFullScreenHeaderCell.swift
//  AppStoreClone
//
//  Created by Mohammed Hamdi on 2/11/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import UIKit

class AppFullScreenHeaderCell: UITableViewCell {
    
    let todayCell = TodayCell()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(todayCell)
        todayCell.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
