//
//  MergeView.swift
//  ipd
//
//  Created by Andreas Resch on 20.01.26.
//

import SwiftUI
import Photos

struct MergeView: View {
    
    var images: [IPDImage]
    @StateObject private var loader = AssetImageLoader()
        
    var body: some View {
        VStack {
            HStack {
                ForEach(images) { item in
                    IPDImageListView(size: 128, showDetails: true, image: item)
                        .padding()
                }
            }
            Button("Delete low res images") {
                var sorted = images.sorted { a, b in
                    a.size > b.size
                }
                sorted.remove(at: 0)
                PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.deleteAssets(sorted.map({ item in
                        item.asset
                    }) as NSFastEnumeration)
                } completionHandler: { success, error in
                    print("Finished updating asset. " + (success ? "Success." : error!.localizedDescription))
                }
            }
        }
    }
}
#Preview("Empty") {
    MergeView(images: [])
}

