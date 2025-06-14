//
//  AddContentsViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit
import FirebaseAnalytics
import Toast

final class AddContentsViewController: BaseViewController {
    private let addContentsView = AddContentsView()
    
    private lazy var dataViewControllers: [UIViewController] = [
        AddCookingViewController(reactor: AddCookingReactor()),
        AddPlaceViewController(reactor: AddPlaceReactor())
    ]
    
    private var currentPage: Int = 0 {
        didSet {
            guard currentPage >= 0 && currentPage < dataViewControllers.count else { return }
            
            let direction: UIPageViewController.NavigationDirection = oldValue <= currentPage ? .forward : .reverse
            addContentsView.pageViewController.setViewControllers([dataViewControllers[currentPage]], direction: direction, animated: true)
            addContentsView.segmentedControl.selectedSegmentIndex = currentPage
        }
    }

    private lazy var currentType = currentPage == 0 ? "cooking" : "place"
    
    private var didLogType: Set<String> = []
    
    override func loadView() {
        view = addContentsView
    }
    
    override func configureView() {
        super.configureView()
        view.backgroundColor = .backgroundPrimary
    }
    
    override func configureData() {
        addContentsView.pageViewController.delegate = self
        addContentsView.pageViewController.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
        addContentsView.segmentedControl.selectedSegmentIndex = 0
        
        logEnterAddContentIfNeeded(type: "cooking")
    }
    
    override func configureAction() {
        addContentsView.segmentedControl.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        addContentsView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        addContentsView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    private func logEnterAddContentIfNeeded(type: String) {
        guard !didLogType.contains(type) else { return }
        didLogType.insert(type)

        Analytics.logEvent(Event.Enter.addContents, parameters: [
            "type": type
        ])
    }
    
    // MARK: - Actions
    @objc private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex

        logEnterAddContentIfNeeded(type: currentType)
    }
    
    @objc private func cancelButtonTapped() {
        Analytics.logEvent(Event.Tap.addContentsCanceled, parameters: [
            "type": currentType
        ])
        
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        switch currentPage {
        case 0:
            guard let addCookingVC = dataViewControllers[0] as? AddCookingViewController,
                  let reactor = addCookingVC.reactor else { return }

            let trimmedName = addCookingVC.addCookingView.nameTextField.text?.trimmingCharacters(in: .whitespaces)
            if trimmedName?.isEmpty ?? true {
                showAlert(title: "요리 이름은 필수 사항입니다!", message: "요리 이름을 다시 한 번 확인해주세요 :)", button: "확인") { }
                return
            }

            let name = trimmedName!
            let memo = addCookingVC.addCookingView.memoTextView.text
            let rating = addCookingVC.addCookingView.ratingView.rating
            let youtubeLink = addCookingVC.addCookingView.linkTextField.text

            if !isValidYoutubeLink(youtubeLink) {
                showAlert(title: "링크 확인", message: "유효한 유튜브 링크만 입력할 수 있어요 :)", button: "확인") { }
                return
            }

            let selectedImage = addCookingVC.addCookingView.previewPhotoView.image
            let imageURL: String?
            if let image = selectedImage {
                imageURL = saveImageToDocumentsDirectory(image: image)
            } else {
                imageURL = nil
            }

            reactor.action.onNext(.saveCooking(
                name: name,
                memo: memo,
                rating: rating,
                imageURL: imageURL,
                youtubeLink: youtubeLink
            ))

            showToastAndDismiss(message: "요리가 저장되었습니다")

        case 1:
            guard let addPlaceVC = dataViewControllers[1] as? AddPlaceViewController,
                  let reactor = addPlaceVC.reactor else { return }

            let trimmedName = addPlaceVC.addPlaceView.nameTextField.text?.trimmingCharacters(in: .whitespaces)
            if trimmedName?.isEmpty ?? true {
                showAlert(title: "맛집 이름은 필수 사항입니다!", message: "맛집 이름을 다시 한 번 확인해주세요 :)", button: "확인") { }
                return
            }

            let name = trimmedName!
            let memo = addPlaceVC.addPlaceView.memoTextView.text
            let rating = addPlaceVC.addPlaceView.ratingView.rating
            let address = reactor.currentState.addressContents
            let latitude = reactor.currentState.latitude
            let longitude = reactor.currentState.longitude
            
            let selectedImage = addPlaceVC.addPlaceView.previewPhotoView.image
            let imageURL: String?
            if let image = selectedImage {
                imageURL = saveImageToDocumentsDirectory(image: image)
            } else {
                imageURL = nil
            }

            reactor.action.onNext(.savePlace(
                name: name,
                memo: memo,
                rating: rating,
                imageURL: imageURL,
                address: address,
                latitude: latitude,
                longitude: longitude
            ))

            NotificationCenter.default.post(name: Notification.Name("PlaceSaved"), object: nil)
            showToastAndDismiss(message: "맛집이 저장되었습니다")

        default:
            break
        }
        
        Analytics.logEvent(Event.Tap.addContentsSaved, parameters: [
            "type": currentType
        ])
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
    
    private func showToastAndDismiss(message: String) {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first(where: { $0.isKeyWindow }) {
            window.makeToast(message)
        }
        self.dismiss(animated: true)
    }
}

// MARK: - PageViewController
extension AddContentsViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?[0],
              let index = self.dataViewControllers.firstIndex(of: viewController) else { return }
        
        self.currentPage = index
        addContentsView.segmentedControl.selectedSegmentIndex = index
    }
}
