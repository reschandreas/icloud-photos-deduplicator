//
//  IPDApp.swift
//  ipd
//
//  Created by Andreas Resch on 19.01.26.
//

import SwiftUI
import SwiftData
import Photos

@main
struct IPDApp: App {
    
    var cachingImageManager = PHCachingImageManager()

    var body: some Scene {
        WindowGroup {
            MainView(cachingImageManager: cachingImageManager)
        }
    }
}
