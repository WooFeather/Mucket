//
//  SelectFolderVewController.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import Foundation
import ReactorKit
import RxCocoa

final class SelectFolderViewController: BaseViewController {
    private let selectFolderView = SelectFolderView()
    
    override func loadView() {
        view = selectFolderView
    }
    
    override func configureView() {
        super.configureView()
        view.backgroundColor = .backgroundPrimary
    }
}
