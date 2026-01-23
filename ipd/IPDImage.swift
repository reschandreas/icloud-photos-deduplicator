//
//  IPDImage.swift
//  ipd
//
//  Created by Andreas Resch on 20.01.26.
//

import Foundation
import Photos
import SwiftUI

struct IPDImage: Identifiable, Hashable {
    
    var id: String {
        asset?.localIdentifier ?? UUID.init().uuidString
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var asset: Optional<PHAsset>
    var image: Optional<Image>
    var filename: Optional<String>
    var imagename: Optional<String>
    var ext: Optional<String>
    var creationDate: Date
    var modificationDate: Date
    var size: Int64
    var editHash: CLong
    
    init(name: String, image: Image) {
        self.asset = nil
        self.image = image
        self.filename = name
        let ext = IPDImage.getExtension(name: name)
        self.ext = ext
        self.imagename = IPDImage.getImageName(name: name, ext: ext)
        self.creationDate = Date()
        self.modificationDate = Date()
        self.size = Int64(name.count)
        self.editHash = 0
    }
    
    static func getExtension(name: String) -> String {
        return (name.split(separator: ".").last?.lowercased())!
    }
    
    static func getImageName(name: String, ext: String) -> String {
        let tmp = "." + ext
        return name.replacingOccurrences(of: tmp, with: "").replacingOccurrences(of: tmp.uppercased(), with: "")
    }
    
    init?(asset: Optional<PHAsset>) {
        guard let asset = asset else { return nil }
        self.asset = asset
        self.image = nil
        var resources: [PHAssetResource] = PHAssetResource.assetResources(for: self.asset!)
        guard let baseResource = resources.first else { return nil }
        resources.remove(at: 0)
        self.filename = baseResource.originalFilename
        let ext = IPDImage.getExtension(name: baseResource.originalFilename)
        self.ext = ext
        self.imagename = IPDImage.getImageName(name: baseResource.originalFilename, ext: ext)
        self.creationDate = asset.creationDate ?? Date()
        self.modificationDate = asset.modificationDate ?? self.creationDate
        
        var edit: Int = Int.max
        resources.forEach { item in
            edit = edit ^ item.hashValue
        }
        
        self.editHash = resources.count
        
        if let rawSize = baseResource.value(forKey: "fileSize") as? Int64 {
            self.size = rawSize
        } else if let rawSizeCLong = baseResource.value(forKey: "fileSize") as? CLong {
            self.size = Int64(rawSizeCLong)
        } else {
            self.size = 0
        }
    }
    
    static func converByteToHumanReadable(_ bytes:Int64) -> String {
        let formatter:ByteCountFormatter = ByteCountFormatter()
        formatter.countStyle = .binary
        
        return formatter.string(fromByteCount: Int64(bytes))
    }
}

