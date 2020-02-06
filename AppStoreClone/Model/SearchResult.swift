//
//  SearchResult.swift
//  AppStoreClone
//
//  Created by Mohammed Hamdi on 2/6/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Decodable {
    let trackName: String
    let primaryGenreName: String
}
