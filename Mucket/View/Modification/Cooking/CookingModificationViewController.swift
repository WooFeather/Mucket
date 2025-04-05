//
//  CookingModificationViewController.swift
//  Mucket
//
//  Created by 조우현 on 4/5/25.
//

import UIKit

final class CookingModificationViewController: BaseViewController {
    private let cookingModificationView = CookingModificationView()
    var editingCookingId: String?
    private lazy var dataViewControllers: [UIViewController] = [AddCookingViewController(reactor: AddCookingReactor(editingCookingId: editingCookingId))]
    
    init(editingCookingId: String) {
        super.init(nibName: nil, bundle: nil)
        self.editingCookingId = editingCookingId
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = cookingModificationView
    }
    
    override func configureView() {
        super.configureView()
        view.backgroundColor = .backgroundPrimary
    }
    
    override func configureData() {
        cookingModificationView.pageViewController.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
    }
    
    override func configureAction() {
        cookingModificationView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        cookingModificationView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Action
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        guard let addCookingVC = dataViewControllers[0] as? AddCookingViewController,
              let reactor = addCookingVC.reactor,
              let editingCookingId = editingCookingId else { return }
        
        let trimmedName = addCookingVC.addCookingView.nameTextField.text?.trimmingCharacters(in: .whitespaces)
        
        if trimmedName != "" {
            let name = trimmedName ?? "이름 없음"
            let memo = addCookingVC.addCookingView.memoTextView.text
            let rating = addCookingVC.addCookingView.ratingView.rating
            let image = addCookingVC.addCookingView.previewPhotoView.image
            let youtubeLink = addCookingVC.addCookingView.linkTextField.text
            let selectedFolder = reactor.currentState.selectedFolder
            
            if !isValidYoutubeLink(youtubeLink) {
                showAlert(title: "링크 확인", message: "유효한 유튜브 링크만 입력할 수 있어요 :)", button: "확인") { }
                return
            }
            
            let repository = MyCookingRepository()
            
            if let cookingObject = repository.fetchById(editingCookingId) {
                var imageURL: String? = cookingObject.imageFileURL
                
                // 이미지가 변경되었다면 새로 저장
                if let newImage = image {
                    if let oldImagePath = cookingObject.imageFileURL, !oldImagePath.isEmpty {
                        let fileManager = FileManager.default
                        // 전체 경로인지 확인하고 처리
                        let oldImageURL: URL
                        if oldImagePath.hasPrefix("/") {
                            // 절대 경로인 경우
                            oldImageURL = URL(fileURLWithPath: oldImagePath)
                        } else {
                            // 상대 경로인 경우, 문서 디렉토리에 추가
                            oldImageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(oldImagePath)
                        }
                        
                        // 파일 존재 여부 확인 후 삭제 시도
                        if fileManager.fileExists(atPath: oldImageURL.path) {
                            do {
                                try fileManager.removeItem(at: oldImageURL)
                                print("이전 이미지 삭제 성공: \(oldImageURL.path)")
                            } catch {
                                print("이전 이미지 삭제 실패: \(error.localizedDescription)")
                            }
                        } else {
                            print("삭제할 이미지 파일이 존재하지 않음: \(oldImageURL.path)")
                        }
                    }
                    
                    imageURL = saveImageToDocumentsDirectory(image: newImage)
                    print("새 이미지 저장 경로: \(imageURL ?? "없음")")
                }
                
                // 업데이트할 엔티티 생성
                let updatedEntity = MyCookingEntity(
                    id: editingCookingId,
                    name: name,
                    youtubeLink: youtubeLink,
                    imageFileURL: imageURL,
                    memo: memo,
                    rating: rating,
                    createdAt: cookingObject.createdAt,
                    folderId: selectedFolder?.id
                    
                )
                
                // 엔티티 업데이트
                repository.update(updatedEntity)
                
                // 알림 발송 (필요하다면)
                NotificationCenter.default.post(name: NSNotification.Name("CookingDataUpdated"), object: nil)
            }
            
            self.dismiss(animated: true)
        } else {
            showAlert(title: "요리 이름은 필수 사항입니다!", message: "요리 이름을 다시 한 번 확인해주세요 :)", button: "확인") { }
        }
    }
    
    private func saveImageToDocumentsDirectory(image: UIImage) -> String? {
        guard let imageData = image.pngData() else {
            return nil
        }
        
        // 파일명만 생성
        let fileName = UUID().uuidString + ".png"
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: filePath)
            return fileName // 파일명만 반환
        } catch {
            print("이미지 저장 실패: \(error)")
            return nil
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        // 사용자 문서 디렉토리 경로 반환
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func isValidYoutubeLink(_ link: String?) -> Bool {
        guard let link = link?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), !link.isEmpty else {
            return true // 비어있으면 유효하다고 간주
        }
        
        return link.contains("youtube.com") || link.contains("youtu.be")
    }
}
