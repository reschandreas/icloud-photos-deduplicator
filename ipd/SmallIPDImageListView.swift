//
//  SmallIPDImageListView.swift
//  ipd
//
//  Created by Andreas Resch on 23.01.26.
//

import SwiftUI
import Photos

struct SmallIPDImageListView: View {
    
    var size = 64
        
    var image: IPDImage
    @StateObject private var loader = AssetImageLoader()
    
    func getImage(image: IPDImage, loader: AssetImageLoader) -> Optional<Image> {
        if (image.asset != nil) {
            return loader.image
        }
        if (image.image != nil) {
            return image.image
        }
        return nil
    }
        
    var body: some View {
        HStack {
            if let image = getImage(image: image, loader: loader) {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: CGFloat(size * 2), height: CGFloat(size))
                    .mask(LinearGradient(gradient: Gradient(stops: [
                        .init(color: .black, location: 0),
                        .init(color: .clear, location: 1),
                        .init(color: .black, location: 1),
                        .init(color: .clear, location: 1)
                    ]), startPoint: .leading, endPoint: .trailing))
            } else {
                ProgressView()
            }
            Text(image.imagename ?? "no-name")
                .monospaced()
            Spacer()
        }
        .onAppear {
            if let asset = image.asset {
                loader.load(
                    asset: asset,
                    size: CGSize(width: size, height: size),
                    highQuality: false
                )
            }
        }
    }
}
