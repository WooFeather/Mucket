//
//  ImageCacheManager.swift
//  Moving
//
//  Created by 조우현 on 3/25/25.
//

import UIKit

final class ImageCacheManager {
    enum CacheError: Error {
        case invalidURL
        case loadFail
    }
    
    static let shared = ImageCacheManager()
    
    private var memoryCache = MemoryCache.shared
    private var diskCache = DiskCache.shared
    
    private init() { }
    
    func load(url: URL?, saveOption: SaveOption) async throws -> UIImage? {
        guard let url else {
            throw CacheError.invalidURL
        }
        
        // Memory Cache에 존재하면 바로 반환
        if let cachedImage = memoryCache.loadImage(url: url) {
            // print("💿 Memory Cache에서 로드")
            return cachedImage
        }
        
        // Disk Cache에서 로드 (비동기 처리)
        if let cachedImage = await diskCache.loadImage(url: url) {
            await memoryCache.saveImage(image: cachedImage, url: url, option: saveOption)
            // print("💾 Disk Cache에서 로드")
            return cachedImage
        }
        
        // 서버에서 데이터 요청 (비동기 URLSession 사용)
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                print("❌ 서버로부터 이미지 로드 실패 (데이터 변환 오류)")
                return nil
            }
            
            // 캐시에 저장 (비동기 처리)
            await memoryCache.saveImage(image: image, url: url, option: saveOption)
            await diskCache.saveImage(image: image, url: url, option: saveOption)
            // print("🌐 서버에서 로드", url)
            
            return image
        } catch {
            print("❌ 서버로부터 이미지 로드 실패: \(error.localizedDescription)")
            throw CacheError.loadFail
        }
    }
}
