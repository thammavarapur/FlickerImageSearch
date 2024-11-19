//
//  FlickrImageSearchViewModel.swift
//  FlickrImageSearch
//
//  Created by Rajesh Thammavarapu on 11/19/24.
//

import SwiftUI

struct FlickrImage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let author: String
    let publishDate: Date
    let imageURL: URL
}

class FlickrImageSearchViewModel: ObservableObject {
    @Published var images: [FlickrImage] = []
    @Published var isLoading: Bool = false
    
    func fetchImages(for tags: String) {
        let formattedTags = tags.replacingOccurrences(of: " ", with: ",")
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(formattedTags)"
        
        guard let url = URL(string: urlString) else { return }
        
        isLoading = true
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            defer { DispatchQueue.main.async { self?.isLoading = false } }
            guard let data = data, error == nil else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let items = json["items"] as? [[String: Any]] {
                    let dateFormatter = ISO8601DateFormatter()
                    
                    let flickrImages = items.compactMap { item -> FlickrImage? in
                        guard let title = item["title"] as? String,
                              let author = item["author"] as? String,
                              let description = item["description"] as? String,
                              let media = item["media"] as? [String: String],
                              let imageURLString = media["m"],
                              let imageURL = URL(string: imageURLString),
                              let publishDateString = item["published"] as? String,
                              let publishDate = dateFormatter.date(from: publishDateString)
                        else { return nil }
                        
                        return FlickrImage(
                            title: title,
                            description: description,
                            author: author,
                            publishDate: publishDate,
                            imageURL: imageURL
                        )
                    }
                    
                    DispatchQueue.main.async {
                        self?.images = flickrImages
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }.resume()
    }
}
