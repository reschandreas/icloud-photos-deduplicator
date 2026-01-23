//
//  MergeView.swift
//  ipd
//
//  Created by Andreas Resch on 20.01.26.
//

import SwiftUI
import Photos

struct MergeView: View {
    
    @State private var images: [IPDImage]
    @StateObject private var loader = AssetImageLoader()
    
    var onDelete: () -> Void
    
    init(images: [IPDImage], onDelete: @escaping () -> Void) {
        let sorted = images.sorted { a, b in
            a.size > b.size
        }
        _images = State(initialValue: sorted)
        self.onDelete = onDelete
    }
    
    func getImageToKeep() -> IPDImage {
        return images[0]
    }
    
    func removeOneImage(image: IPDImage) {
        self.images.removeAll{
            $0.id == image.id
        }
        if self.images.count == 1 {
            onDelete()
        }
    }
        
    var body: some View {
        VStack {
            HStack {
                ForEach(images) { item in
                    IPDImageListView(size: 512, showDetails: true, image: item, onDelete: {
                        if let asset = item.asset {
                            PHPhotoLibrary.shared().performChanges({
                                PHAssetChangeRequest.deleteAssets([asset] as NSFastEnumeration)
                            }, completionHandler: { success, error in
                                DispatchQueue.main.async {
                                    withAnimation {
                                        removeOneImage(image: item)
                                    }
                                }
                            })
                        }
                    })
                }
            }
            Button("Keep image of Format \(getImageToKeep().ext?.uppercased() ?? "idk") with \(IPDImage.converByteToHumanReadable(getImageToKeep().size))") {
                var sorted = images.sorted { a, b in
                    a.size > b.size
                }
                sorted.remove(at: 0)
                PHPhotoLibrary.shared().performChanges({
                    let assetsToDelete: [PHAsset] = sorted.compactMap { $0.asset }
                    PHAssetChangeRequest.deleteAssets(assetsToDelete as NSFastEnumeration)
                }, completionHandler: { success, error in
                    DispatchQueue.main.async {
                        print("Finished deduplicating assets. " + (success ? "Success." : (error?.localizedDescription ?? "Unknown error")))
                        withAnimation {
                            onDelete()
                        }
                    }
                })
            }
            .monospaced()
            .buttonStyle(GlassButtonStyle())
        }
    }
}
