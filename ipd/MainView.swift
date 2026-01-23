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
    
    @State var model: MainViewModel = MainViewModel()
    @State var currentItem: Optional<String> = nil
    
    @State var hasAccess = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    
    func loadingStatus() -> String {
        if model.totals == 0 {
            return ""
        }
        let totals = model.totals.description
        return " " + String(format: "%0\(totals.count)d", model.liveCounter) + "/" + totals
    }

    var body: some View {
        if hasAccess != .authorized {
            Text("Please authorize IPD to access your Photo Library.").monospaced()
        } else if model.assets.count > 0 {
            NavigationSplitView {
                List {
                    if let elements = model.deduplicator?.duplicates.elements {
                        ForEach(elements, id: \.key) { item in
                            if let image = item.value.first {
                                SmallIPDImageListView(image: image)
                                    .contentShape(Rectangle())
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
                }
                .navigationSplitViewColumnWidth(min: 180, ideal: 200)
                .toolbar {
                    ToolbarItem {
                        Button(action: (syncLibrary)) {
                            Label("Sync Photo Library", systemImage: "arrow.trianglehead.2.clockwise.rotate.90")
                        }.buttonStyle(GlassButtonStyle())
                    }
                }
            } detail: {
                if currentItem == nil {
                    VStack {
                        Text("You have \(model.counter) photos and videos").monospaced()
                        if model.deduplicator != nil {
                            Text("of which \(model.deduplicator?.countDuplicates().description ?? "NaN") have the same name and date").monospaced()
                            Text("Select one on the left to merge").monospaced()
                        } else {
                            Button("Check for duplicates") {
                                model.detectDuplicates()
                            }.monospaced()
                            .buttonStyle(GlassButtonStyle())
                        }
                    }
                } else {
                    if let item = model.deduplicator?.duplicates[currentItem ?? "noname"] {
                        MergeView(images: Array(item), onDelete: {
                            Task {
                                item.forEach { asset in
                                    model.assets = model.assets.filter { b in
                                        b.id != asset.id
                                    }
                                }
                                model.deduplicator?.removeEntry(key: currentItem ?? "noname")
                            }
                        }).padding()
                    }
                }
            }
        } else {
            ProgressView("fetching your photos and videos\(loadingStatus())")
                .contentTransition(.numericText())
                .monospaced()
                .onAppear {
                if hasAccess == .authorized {
                    syncLibrary()
                }
            }
        }
    }
    
    func syncLibrary() {
        model.fetchAssets()
    }
}

