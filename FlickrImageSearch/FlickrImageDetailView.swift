//
//  FlickrImageDetailView.swift
//  FlickrImageSearch
//
//  Created by Rajesh Thammavarapu on 11/19/24.
//

import Foundation
import SwiftUI

struct FlickrImageDetailView: View {
    let image: FlickrImage
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: image.imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                
                Text("Title: \(image.title)")
                    .font(.headline)
                
                Text("Description: \(image.description)")
                    .font(.body)
                
                Text("Author: \(image.author)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Published: \(formattedDate(image.publishDate))")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle("Image Details")
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
