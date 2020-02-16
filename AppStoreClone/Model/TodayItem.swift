//
//  TodayItem.swift
//  AppStoreClone
//
//  Created by Mohammed Hamdi on 2/12/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import UIKit

struct TodayItem {
    let category: String
    let title: String
    let image: UIImage
    let description: String
    let backgroundColor: UIColor
    
    // Enum
    let cellType: CellType
    
    let apps: [FeedResult]
    
    enum CellType: String {
        case single, multiple
    }
}
