//
//  IPDImageListView.swift
//  ipd
//
//  Created by Andreas Resch on 20.01.26.
//

import SwiftUI
import Photos

struct IPDImageListView: View {
    
    var size = 256
    
    var showDetails = false
    
    var image: IPDImage
    @StateObject private var loader = AssetImageLoader()
    
    var onDelete: () -> Void
    
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
            if showDetails {
                HStack {
                    Spacer()
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        onDelete()
                    }
                    .monospaced()
                    .foregroundColor(.red)
                    .buttonStyle(GlassButtonStyle())
                }
                Spacer()
            }
            if let image = getImage(image: image, loader: loader) {
                GeometryReader { geometry in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            } else {
                ProgressView()
            }
            Spacer()
            if showDetails {
                Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 8) {
                    GridRow {
                        Text("Name")
                            .monospaced()
                        Text(image.imagename ?? "no-name")
                            .monospaced()
                    }
                    GridRow {
                        Text("Extension")
                            .monospaced()
                        Text((image.ext ?? "no-name").uppercased()).padding(CGFloat(2))
                            .monospaced()
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 1))
                            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 10))
                    }
                    GridRow {
                        Text("Creation Date")
                            .monospaced()
                        Text(image.creationDate.ISO8601Format())
                            .monospaced()
                    }
                    GridRow {
                        Text("Modification Date")
                            .monospaced()
                        Text(image.modificationDate.ISO8601Format())
                            .monospaced()
                    }
                    GridRow {
                        Text("Size")
                            .monospaced()
                        Text(IPDImage.converByteToHumanReadable(image.size))
                            .monospaced()
                    }
                    GridRow {
                        Text("Edits")
                            .monospaced()
                        Text(image.editHash.description)
                            .monospaced()
                    }
                }.padding()
            } else {
                Text(image.imagename ?? "no-name")
                    .padding()
            }
            Spacer()
        }
        .padding(8)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 10))
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
