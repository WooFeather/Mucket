//
//  PreviewSheetViewController.swift
//  Mucket
//
//  Created by 조우현 on 4/11/25.
//

import UIKit
import ReactorKit
import SnapKit
import Toast

// TODO: Reactor로 변경
final class PreviewSheetViewController: BaseViewController {
    private let previewSheetView = PreviewSheetView()
    private let place: MyPlaceEntity
    var onDetailRequested: ((MyPlaceEntity) -> Void)?
    
    init(place: MyPlaceEntity) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewSheetView.configureDate(entity: place)
    }
    
    override func loadView() {
        view = previewSheetView
    }
    
    override func configureView() {
        super.configureView()
        view.backgroundColor = .backgroundPrimary
    }
    
    override func configureAction() {
        previewSheetView.detailButton.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
        previewSheetView.copyButton.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Action
    @objc
    private func detailButtonTapped() {
        onDetailRequested?(place)
        dismiss(animated: true)
    }
    
    @objc
    private func copyButtonTapped() {
        guard let address = previewSheetView.addressLabel.text, !address.isEmpty else {
            print("📭 주소 없음")
            return
        }
        
        UIPasteboard.general.string = address
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first(where: { $0.isKeyWindow }) {
            window.makeToast("주소가 복사되었습니다.")
        }
    }
}
