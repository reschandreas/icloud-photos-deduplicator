//
//  AssetLoader.swift
//  ipd
//
//  Created by Andreas Resch on 20.01.26.
//

import SwiftUI
import Combine
import Photos

@MainActor
final class AssetImageLoader: ObservableObject {
    @Published var image: Image?

    func load(asset: PHAsset, size: CGSize, highQuality: Bool = false) {
        let options = PHImageRequestOptions()
        if highQuality {
            options.deliveryMode = .highQualityFormat
        } else {
            options.deliveryMode = .opportunistic
        }
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true

        PHImageManager.default().requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFit,
            options: options
        ) { [weak self] uiImage, _ in
            guard let uiImage else { return }
            self?.image = Image(nsImage: uiImage)
        }
    }
}
