//
//  Service.swift
//  AppStoreClone
//
//  Created by Mohammed Hamdi on 2/6/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import Foundation

class Service {
    
    static let shared = Service() // singleton
    
    func fetchApps(searchTerm: String, completion: @escaping ([Result], Error?) -> ()) {
        print("Fetching iTunes apps from service layer")
        
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        guard let url = URL(string: urlString) else { return }

        // Fetch data from the internet
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch apps: ", error)
                completion([], nil)
                return
            }

            // Success
            guard let data = data else { return }

            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)

                completion(searchResult.results, nil)
            } catch {
                print("Failed to decode json: ", error)
                completion([], error)
            }

        }.resume() //Fires off the request
    }
}
