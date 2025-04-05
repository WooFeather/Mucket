//
//  AddContentsViewController.swift
//  Mucket
//
//  Created by 조우현 on 3/29/25.
//

import UIKit

final class AddContentsViewController: BaseViewController {
    private let addContentsView = AddContentsView()
    
    private lazy var dataViewControllers: [UIViewController] = [
        AddCookingViewController(reactor: AddCookingReactor()),
        AddRestaurantViewController(reactor: AddRestaurantReactor())
    ]
    
    private var currentPage: Int = 0 {
        didSet {
            guard currentPage >= 0 && currentPage < dataViewControllers.count else { return }
            
            let direction: UIPageViewController.NavigationDirection = oldValue <= currentPage ? .forward : .reverse
            addContentsView.pageViewController.setViewControllers([dataViewControllers[currentPage]], direction: direction, animated: true)
            addContentsView.segmentedControl.selectedSegmentIndex = currentPage
        }
    }
    
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
    }
    
    override func configureAction() {
        addContentsView.segmentedControl.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        addContentsView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        addContentsView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        guard let addCookingVC = dataViewControllers[0] as? AddCookingViewController,
              let reactor = addCookingVC.reactor else { return }

        // 아래 필드는 AddCookingViewController 내에서 추출
        let name = addCookingVC.addCookingView.nameTextField.text ?? "이름 없음"
        let memo = addCookingVC.addCookingView.memoTextView.text
        let rating = addCookingVC.addCookingView.ratingView.rating
        let image = addCookingVC.addCookingView.previewPhotoView.image ?? .placeholderSmall
        let youtubeLink = addCookingVC.addCookingView.linkTextField.text
        
        let imageURL = saveImageToDocumentsDirectory(image: image)
        
        reactor.action.onNext(.saveCooking(
            name: name,
            memo: memo,
            rating: rating,
            imageURL: imageURL,
            youtubeLink: youtubeLink
        ))
        
        self.dismiss(animated: true)
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



// MARK: - PageViewController
extension AddContentsViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?[0],
              let index = self.dataViewControllers.firstIndex(of: viewController) else { return }
        
        self.currentPage = index
        addContentsView.segmentedControl.selectedSegmentIndex = index
    }
}
