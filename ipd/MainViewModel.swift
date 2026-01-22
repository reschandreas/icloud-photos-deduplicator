//
//  MainViewModel.swift
//  ipd
//
//  Created by Andreas Resch on 20.01.26.
//

import SwiftUI
import SwiftData
import Photos

@Observable
class MainViewModel {
    var cachingImageManager: PHCachingImageManager
    
    var deduplicator: Optional<Deduplicator>
    
    var reloadImage: Bool = false
    
    var assets: [IPDImage] = []
    
    var counter: Int {
        self.assets.count
    }
    
    func fetchAssets() {
        self.assets = []
        let options = PHFetchOptions()
//        options.fetchLimit = 1000
        let result = PHAsset.fetchAssets(with: options)
        var list: [IPDImage] = []
        list.reserveCapacity(result.count)
        result.enumerateObjects { asset, _, _ in
            if let image = IPDImage(asset: asset) {
                list.append(image)
            }
        }
        self.assets = list
        self.deduplicator = Optional(Deduplicator(assets: self.assets))
    }
    
    init(cachingImageManager: PHCachingImageManager) {
        self.cachingImageManager = cachingImageManager
        self.deduplicator = nil
        DispatchQueue.main.async {
            self.fetchAssets()
        }
    }
}
