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
    
    func load(url: URL?, saveOption: SaveOption, thumbSize: CGSize) async throws -> UIImage? {
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
        
        // 서버에서 데이터 요청
        let (data, _) = try await URLSession.shared.data(from: url)

        // 다운샘플링 우선 시도
        if let down = await UIImage.downsampled(
            from: data,
            to: thumbSize,
            scale: UIScreen.main.scale
        ) {
            // 캐시에 저장
            await memoryCache.saveImage(image: down, url: url, option: saveOption)
            await diskCache.saveImage(image: down, url: url, option: saveOption)
            return down
        }

        // 다운샘플링 실패 시에는 기본 디코딩
        guard let full = UIImage(data: data) else { return nil }
        await memoryCache.saveImage(image: full, url: url, option: saveOption)
        await diskCache.saveImage(image: full, url: url, option: saveOption)
        return full
    }
}
