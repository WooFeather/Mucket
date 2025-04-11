//
//  PreviewSheetViewController.swift
//  Mucket
//
//  Created by 조우현 on 4/11/25.
//

import UIKit
import ReactorKit
import SnapKit

final class PreviewSheetViewController: BaseViewController {
    private let previewSheetView = PreviewSheetView()
    private let place: MyPlaceEntity
    
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
}
