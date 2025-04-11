//
//  AddRestaurantView.swift
//  Mucket
//
//  Created by 조우현 on 4/1/25.
//

import UIKit
import SnapKit
import Cosmos

final class AddPlaceView: BaseView {
    let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()

    private let nameHeaderLabel = UILabel()
    private let addressHeaderLabel = UILabel()
    private let photoHeaderLabel = UILabel()
    private let memoHeaderLabel = UILabel()
    private let ratingContainerView = UIView()
    private let ratingHeaderLabel = UILabel()
    private let folderHeaderLabel = UILabel()

    private lazy var nameView = BackgroundContentView(contentView: nameTextField)
    private lazy var addressView = BackgroundContentView(contentView: addressButton)
    private lazy var memoView = BackgroundContentView(contentView: memoTextView)
    private lazy var folderView = BackgroundContentView(contentView: folderSelectButton)

    let nameTextField = UITextField()
    let addressButton = UIButton()
    let photoContainerView = UIView()
    let photoStackView = UIStackView()
    let addPhotoButton = UIButton()
    let previewPhotoView = UIImageView()
    let memoTextView = UITextView()
    let ratingView = CosmosView()
    let folderSelectButton = UIButton()

    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        ratingContainerView.addSubview(ratingHeaderLabel)
        ratingContainerView.addSubview(ratingView)
        
        photoContainerView.addSubview(photoStackView)
        
        [nameHeaderLabel, nameView,
         addressHeaderLabel, addressView,
         photoHeaderLabel, photoContainerView,
         memoHeaderLabel, memoView,
         ratingContainerView,
         folderHeaderLabel, folderView
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [addPhotoButton, previewPhotoView].forEach {
            photoStackView.addArrangedSubview($0)
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

        photoContainerView.snp.makeConstraints {
            $0.height.equalTo(100)
        }
        
        photoStackView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.lessThanOrEqualTo(220)
        }
        
        [addPhotoButton, previewPhotoView].forEach {
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(100)
            }
        }
        
        ratingContainerView.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        ratingHeaderLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        ratingView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        memoView.snp.makeConstraints { $0.height.equalTo(120) }
        folderView.snp.makeConstraints { $0.height.equalTo(48) }
    }

    override func configureView() {
        backgroundColor = .white
        
        stackView.axis = .vertical
        stackView.spacing = 16
        
        photoStackView.axis = .horizontal
        photoStackView.spacing = 16
        photoStackView.distribution = .fillEqually

        [nameHeaderLabel, addressHeaderLabel, photoHeaderLabel,
         memoHeaderLabel, ratingHeaderLabel, folderHeaderLabel].forEach {
            $0.font = .Body.body2
            $0.textColor = .textSecondary
        }

        nameHeaderLabel.text = "맛집 이름"
        addressHeaderLabel.text = "주소"
        photoHeaderLabel.text = "사진"
        memoHeaderLabel.text = "메모"
        ratingHeaderLabel.text = "별점"
        folderHeaderLabel.text = "폴더 선택"

        nameTextField.placeholder = "맛집 이름 입력"
        nameTextField.borderStyle = .none
        nameTextField.font = .Body.body4
        nameTextField.textColor = .textPrimary

        addressButton.setTitle("주소 검색", for: .normal)
        addressButton.setTitleColor(.textPrimary, for: .normal)
        addressButton.contentHorizontalAlignment = .left
        addressButton.setImage(.chevronRight, for: .normal)
        addressButton.semanticContentAttribute = .forceRightToLeft
        addressButton.tintColor = .textPrimary
        addressButton.titleLabel?.font = .Body.body4

        addPhotoButton.backgroundColor = .themeSecondary
        addPhotoButton.layer.cornerRadius = 6
        addPhotoButton.setImage(.plus, for: .normal)
        addPhotoButton.tintColor = .textPrimary
        
        previewPhotoView.layer.cornerRadius = 6
        previewPhotoView.backgroundColor = .backgroundPrimary
        previewPhotoView.clipsToBounds = true
        previewPhotoView.contentMode = .scaleAspectFill
        previewPhotoView.tintColor = .textPrimary
        
        memoTextView.backgroundColor = .clear
        memoTextView.font = .Body.body4

        folderSelectButton.setTitle("기본 폴더", for: .normal)
        folderSelectButton.setTitleColor(.textPrimary, for: .normal)
        folderSelectButton.contentHorizontalAlignment = .left
        folderSelectButton.setImage(.chevronRight, for: .normal)
        folderSelectButton.semanticContentAttribute = .forceRightToLeft
        folderSelectButton.tintColor = .textPrimary
        folderSelectButton.titleLabel?.font = .Body.body4

        ratingView.backgroundColor = .clear
        ratingView.settings.starSize = 30
        ratingView.settings.fillMode = .half
        ratingView.settings.starMargin = 5
        ratingView.rating = 0
        ratingView.settings.minTouchRating = 0
        ratingView.settings.updateOnTouch = true
    }
}
