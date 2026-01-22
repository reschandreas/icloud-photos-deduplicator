//
//  Deduplicator.swift
//  ipd
//
//  Created by Andreas Resch on 20.01.26.
//

import Foundation
import OrderedCollections
import Photos

class Deduplicator {
    
    
    var map: OrderedDictionary<String, Set<IPDImage>> = [:]
    
    init(assets: [IPDImage]) {
        var tmpMap: Dictionary<String, Set<IPDImage>> = [:]
        assets.forEach { asset in
            let identifier = (asset.imagename ?? "unmapped") + asset.creationDate.ISO8601Format()
                              // + asset.creationDate.ISO8601Format() + asset.modificationDate.ISO8601Format())
            var value = tmpMap[identifier]
            if value == nil {
                value = Optional(Set())
            }
            value?.insert(asset)
            tmpMap.updateValue(value!, forKey: identifier)
        }
        self.map = OrderedDictionary(uniqueKeys: tmpMap.keys, values: tmpMap.values)
    }
    
    var duplicates: OrderedDictionary<String, Set<IPDImage>> {
        self.map.filter {
            $1.count > 1
        }
    }
    
    func countDuplicates() -> Int {
        self.duplicates.count
    }
}
