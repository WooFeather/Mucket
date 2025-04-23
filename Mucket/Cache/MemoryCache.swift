//
//  MemoryCache.swift
//  Moving
//
//  Created by 조우현 on 3/25/25.
//

import UIKit

final class MemoryCache: Cacheable {
    static let shared = MemoryCache()
    let cache = NSCache<NSString, UIImage>()
    
    private init() { }
    
    func loadImage(url: URL) -> UIImage? {
        let key = createKey(from: url)
        return cache.object(forKey: key as NSString)
    }
    
    func saveImage(image: UIImage, url: URL, option: SaveOption) async {
        guard option != .onlyDisk, option != .none else { return }
        
        let key = createKey(from: url) as NSString
        cache.setObject(image, forKey: key)
    }
}

