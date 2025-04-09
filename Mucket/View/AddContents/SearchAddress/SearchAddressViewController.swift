//
//  SearchAddressViewController.swift
//  Mucket
//
//  Created by 조우현 on 4/9/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class SearchAddressViewController: BaseViewController {
    
    private let searchAddressView = SearchAddressView()
    
    override func loadView() {
        view = searchAddressView
    }
    
    override func configureView() {
        view.backgroundColor = .backgroundPrimary
    }
}
