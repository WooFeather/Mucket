//
//  AddCookingView.swift
//  Mucket
//
//  Created by 조우현 on 4/1/25.
//

import UIKit
import SnapKit

final class AddCookingView: BaseView {
    let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    
    private let nameHeaderLabel = UILabel()
    private let linkHeaderLabel = UILabel()
    private let photoHeaderLabel = UILabel()
    private let memoHeaderLabel = UILabel()
    private let ratingHeaderLabel = UILabel()
    private let folderHeaderLabel = UILabel()
    
    private lazy var nameView = BackgroundContentView(contentView: nameTextField)
    private lazy var linkView = BackgroundContentView(contentView: linkTextField)
    private lazy var memoView = BackgroundContentView(contentView: memoTextView)
    private lazy var folderView = BackgroundContentView(contentView: folderSelectButton)
    
    let nameTextField = UITextField()
    let linkTextField = UITextField()
    let photoUploadView = UIView() // TODO: 추후 컬렉션뷰로 구성 예정
    let memoTextView = UITextView()
    let ratingView = UIView() // TODO: CosmosView로 교체 예정
    let folderSelectButton = UIButton()

    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        [nameHeaderLabel, nameView,
         linkHeaderLabel, linkView,
         photoHeaderLabel, photoUploadView,
         memoHeaderLabel, memoView,
         ratingHeaderLabel, ratingView,
         folderHeaderLabel, folderView
        ].forEach {
            stackView.addArrangedSubview($0)
        }
    }

    override func configureLayout() {
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }

        photoUploadView.snp.makeConstraints { $0.height.equalTo(80) }
        ratingView.snp.makeConstraints { $0.height.equalTo(44) }
        memoView.snp.makeConstraints { $0.height.equalTo(120) }
        folderView.snp.makeConstraints { $0.height.equalTo(48) }
    }

    override func configureView() {
        backgroundColor = .white
        
        stackView.axis = .vertical
        stackView.spacing = 16

        [nameHeaderLabel, linkHeaderLabel, photoHeaderLabel, memoHeaderLabel, ratingHeaderLabel, folderHeaderLabel].forEach {
            $0.font = .Body.body2
            $0.textColor = .textSecondary
        }

        nameHeaderLabel.text = "요리 이름"
        linkHeaderLabel.text = "레시피 유튜브 링크"
        photoHeaderLabel.text = "사진"
        memoHeaderLabel.text = "메모"
        ratingHeaderLabel.text = "별점"
        folderHeaderLabel.text = "폴더 선택"

        nameTextField.placeholder = "요리 이름 입력"
        linkTextField.placeholder = "유튜브 링크 입력"

        nameTextField.borderStyle = .none
        linkTextField.borderStyle = .none

        [nameTextField, linkTextField].forEach {
            $0.font = .Body.body4
            $0.textColor = .textPrimary
        }
        
        memoTextView.backgroundColor = .clear
        memoTextView.font = .Body.body4

        folderSelectButton.setTitle("기본 폴더", for: .normal)
        folderSelectButton.setTitleColor(.textPrimary, for: .normal)
        folderSelectButton.contentHorizontalAlignment = .left
        folderSelectButton.setImage(.chevronRight, for: .normal)
        folderSelectButton.semanticContentAttribute = .forceRightToLeft
        folderSelectButton.tintColor = .textPrimary
        folderSelectButton.titleLabel?.font = .Body.body4

        photoUploadView.backgroundColor = .lightGray
        ratingView.backgroundColor = .lightGray
    }
}
