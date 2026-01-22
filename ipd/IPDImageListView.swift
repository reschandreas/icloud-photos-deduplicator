//
//  IPDImageListView.swift
//  ipd
//
//  Created by Andreas Resch on 20.01.26.
//

import SwiftUI
import Photos

struct IPDImageListView: View {
    
    var size = 16
    
    var showDetails = false
    
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
        VStack {
            if let image = getImage(image: image, loader: loader) {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: CGFloat(size), height: CGFloat(size))
            } else {
                ProgressView()
            }
            Spacer()
            if showDetails {
                VStack {
                    Text(image.imagename ?? "no-name")
                        .fontDesign(.monospaced)
                        .lineLimit(1)
                        .truncationMode(.middle)
                    Text((image.ext ?? "no-name").uppercased())
                        .padding(CGFloat(4))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 1))
                    Text(image.creationDate.ISO8601Format())
                        .fontDesign(.monospaced)
                    Text(image.modificationDate.ISO8601Format())
                        .fontDesign(.monospaced)
                    Text(image.converByteToHumanReadable(image.size))
                        .lineLimit(1)
                        .truncationMode(.middle)
                    Text(image.editHash.description)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
            } else {
                Text(image.imagename ?? "no-name")
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .padding()
            }
            Spacer()
        }
        .padding(CGFloat(4))
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 1))
        .onAppear {
            if image.asset != nil {
                loader.load(
                    asset: image.asset!,
                    size: CGSize(width: size, height: size),
                    highQuality: showDetails
                )
            }
        }
    }
}


struct IPDImageListView_Previews: PreviewProvider {
    
    static var previews: some View {
        IPDImageListView(size: 256, showDetails: true, image: IPDImage(name: "lenna.heic", image: Image("lenna")))
    }
}
