//
//  DiskCache.swift
//  Moving
//
//  Created by 조우현 on 3/25/25.
//

import UIKit

final class DiskCache: Cacheable {
    static let shared = DiskCache()
    private var fileManager = FileManager.default
    
    private init() { }
    
    func loadImage(url: URL) async -> UIImage? {
        guard let filePath = checkPath(url),
              fileManager.fileExists(atPath: filePath) else { return nil }
        
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                let image = UIImage(contentsOfFile: filePath)
                continuation.resume(returning: image)
            }
        }
    }
    
    func saveImage(image: UIImage, url: URL, option: SaveOption) async {
        guard option != .onlyMemory, option != .none else { return }
        
        guard let filePath = checkPath(url),
              !fileManager.fileExists(atPath: filePath) else { return }
        
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                if self.fileManager.createFile(atPath: filePath,
                                               contents: image.jpegData(compressionQuality: 1.0),
                                               attributes: nil) {
                    print("💾 Disk에 저장했습니다.")
                } else {
                    print("⚠️ Disk 공간이 부족합니다.")
                }
                continuation.resume()
            }
        }
    }
    
    // URL로 fileManager 내에서 데이터를 찾을 fileURL 생성
    private func checkPath(_ url: URL) -> String? {
        let key = createKey(from: url)
        
        /// Home 디렉토리에 있는 Cache 디렉토리 경로
        let documentsURL = try? fileManager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true)
        let fileURL = documentsURL?.appendingPathComponent(key)
        
        return fileURL?.path
    }
}
