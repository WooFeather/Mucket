//
//  PlaceModificationViewController.swift
//  Mucket
//
//  Created by 조우현 on 4/12/25.
//

import UIKit

final class PlaceModificationViewController: BaseViewController {
    private let placeModificationView = PlaceModificationView()
    var editingPlaceId: String?
    private lazy var dataViewControllers: [UIViewController] = [AddPlaceViewController(reactor: AddPlaceReactor(editingPlaceId: editingPlaceId))]
    
    init(editingPlaceId: String) {
        super.init(nibName: nil, bundle: nil)
        self.editingPlaceId = editingPlaceId
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = placeModificationView
    }
    
    override func configureView() {
        super.configureView()
        view.backgroundColor = .backgroundPrimary
    }
    
    override func configureData() {
        placeModificationView.pageViewController.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
    }
    
    override func configureAction() {
        placeModificationView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        placeModificationView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Action
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        guard let addPlaceVC = dataViewControllers[0] as? AddPlaceViewController,
              let reactor = addPlaceVC.reactor,
              let editingPlaceId = editingPlaceId else { return }
        
        let trimmedName = addPlaceVC.addPlaceView.nameTextField.text?.trimmingCharacters(in: .whitespaces)
        
        if trimmedName != "" {
            let name = trimmedName ?? "이름 없음"
            let memo = addPlaceVC.addPlaceView.memoTextView.text
            let rating = addPlaceVC.addPlaceView.ratingView.rating
            let image = addPlaceVC.addPlaceView.previewPhotoView.image
            // 주소
            let address = reactor.currentState.addressContents
            let latitude = reactor.currentState.latitude
            let longitude = reactor.currentState.longitude
            let selectedFolder = reactor.currentState.selectedFolder

            let repository = MyPlaceRepository()
            
            if let placeObject = repository.fetchById(editingPlaceId) {
                var imageURL: String? = placeObject.imageFileURL
                
                // 이미지가 변경되었다면 새로 저장
                if let newImage = image {
                    if let oldImagePath = placeObject.imageFileURL, !oldImagePath.isEmpty {
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
                let updatedEntity = MyPlaceEntity(
                    id: editingPlaceId,
                    name: name,
                    latitude: latitude,
                    longitude: longitude,
                    address: address,
                    imageFileURL: imageURL,
                    memo: memo,
                    rating: rating,
                    createdAt: placeObject.createdAt,
                    folderId: selectedFolder?.id
                )
                
                // 엔티티 업데이트
                repository.update(updatedEntity)
                
                // 알림 발송 (필요하다면)
                NotificationCenter.default.post(name: NSNotification.Name("PlaceDataUpdated"), object: nil)
            }
            
            self.dismiss(animated: true)
        } else {
            showAlert(title: "맛집 이름은 필수 사항입니다!", message: "맛집 이름을 다시 한 번 확인해주세요 :)", button: "확인") { }
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
}
