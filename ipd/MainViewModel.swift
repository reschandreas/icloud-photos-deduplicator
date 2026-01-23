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
    
    var deduplicator: Optional<Deduplicator> = nil
    
    var reloadImage: Bool = false
    
    var assets: [IPDImage] = []
    
    var counter: Int {
        self.assets.count
    }
    
    var liveCounter: Int = 0
    var totals: Int = 0
    
    func fetchAssets() {
        Task { @MainActor in
            var list: [IPDImage] = []
            let options = PHFetchOptions()
//            options.fetchLimit = 2000
            let result = PHAsset.fetchAssets(with: options)
            list.reserveCapacity(result.count)
            self.totals = result.count
            
            for index in 0..<result.count {
                if let image = IPDImage(asset: result.object(at: index)) {
                    list.append(image)
                    await MainActor.run {
                        withAnimation {
                            liveCounter = list.count
                        }
                    }
                }
            }
            
            assets = list
        }
    }
    
    func detectDuplicates() {
        self.deduplicator = Optional(Deduplicator(assets: self.assets))
    }
}

