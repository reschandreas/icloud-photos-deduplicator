//
//  MainView.swift
//  ipd
//
//  Created by Andreas Resch on 19.01.26.
//

import SwiftUI
import SwiftData
import Photos
import OrderedCollections

struct MainView: View {
    
    @State var model: MainViewModel
    @State var currentItem: Optional<String> = nil
    
    init(cachingImageManager: PHCachingImageManager) {
        self.model = MainViewModel(cachingImageManager: cachingImageManager)
    }

    var body: some View {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) != .authorized {
            ProgressView("please authorize IPD to access your Photo Library and restart the application.")
        } else if model.assets.count > 0 {
            NavigationSplitView {
                List {
                    if let elements = model.deduplicator?.duplicates.elements {
                        ForEach(elements, id: \.key) { item in
                            HStack {
                                Text(item.value.first?.imagename ?? "noname")
                                Spacer()
                            }
                            .onTapGesture {
                                withAnimation {
                                    if item.key == currentItem {
                                        currentItem = nil
                                    } else {
                                        currentItem = item.key
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationSplitViewColumnWidth(min: 180, ideal: 200)
                .toolbar {
                    ToolbarItem {
                        Button(action: (syncLibrary)) {
                            Label("Sync Photo Library", systemImage: "arrow.trianglehead.2.clockwise.rotate.90")
                        }
                    }
                }
            } detail: {
                if currentItem == nil {
                    VStack {
                        Text("You have \(model.counter) photos and videos")
                        Text("of which \(model.deduplicator?.countDuplicates().description ?? "NaN") have the same name and date")
                        Text("select one on the left to merge")
                    }
                } else {
                    if let item = model.deduplicator?.duplicates[currentItem ?? "noname"] {
                        VStack {
                            Spacer()
                            MergeView(images: Array(item))
                            Spacer()
                        }
                    }
                }
                
            }
        } else {
            ProgressView("fetching your photos and videos")
        }
    }
    
    func syncLibrary() {
        DispatchQueue.main.async {
            model.fetchAssets()
        }
    }
}
