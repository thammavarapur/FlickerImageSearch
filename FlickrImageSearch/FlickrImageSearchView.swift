//
//  FlickrImageSearchView-.swift
//  FlickrImageSearch
//
//  Created by Rajesh Thammavarapu on 11/19/24.
//

import SwiftUI

struct FlickrImageSearchView: View {
    @StateObject private var viewModel = FlickrImageSearchViewModel()
    @State private var searchText = ""
    @State private var selectedImage: FlickrImage? = nil

    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search Flickr", text: $searchText, onEditingChanged: { _ in
                    viewModel.fetchImages(for: searchText)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                // Progress Indicator
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                }
                
                // Image Grid
                if viewModel.images.isEmpty && !viewModel.isLoading {
                    Text("No images found. Start searching!")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(viewModel.images) { image in
                                AsyncImage(url: image.imageURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                } placeholder: {
                                    ProgressView()
                                }
                                .onTapGesture {
                                    selectedImage = image
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Flickr Search")
            .sheet(item: $selectedImage) { image in
                FlickrImageDetailView(image: image)
            }
        }
    }
}
