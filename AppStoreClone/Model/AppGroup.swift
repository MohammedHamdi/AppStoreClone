//
//  AppGroup.swift
//  AppStoreClone
//
//  Created by Mohammed Hamdi on 2/8/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import Foundation

struct AppGroup: Decodable {
    let feed: Feed
}

struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}

struct FeedResult: Decodable {
    let id, name, artistName, artworkUrl100: String
}
