//
//  PlaceDetailView.swift
//  Mucket
//
//  Created by 조우현 on 4/11/25.
//

import UIKit
import SnapKit
import Cosmos

final class PlaceDetailView: BaseView {
    private let ratingHeaderLabel = UILabel()
    private let memoHeaderLabel = UILabel()
    private let addressHeaderLabel = UILabel()
    private lazy var memoView = ColorBackgroundContentView(contentView: memoTextView)
    private lazy var addressView = BackgroundContentView(contentView: addressLabel)
    
    private let navigationStackView = UIStackView()
    let backButton = UIButton()
    let naviTitleLabel = UILabel()
    let editButton = UIButton()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let thumbImageView = UIImageView() // TODO: pageControl 들어갈 예정
    let ratingView = CosmosView()
    let memoTextView = UITextView()
    let addressLabel = UILabel()
    let copyButton = UIButton()
    
    private let contextMenuItems = ["수정하기", "삭제하기"]
    var didSelectEditMenu: (() -> Void)?
    var didSelectDeleteMenu: (() -> Void)?
    
    override func configureHierarchy() {
        [navigationStackView, scrollView].forEach {
            addSubview($0)
        }

        scrollView.addSubview(contentView)

        [thumbImageView, ratingHeaderLabel, ratingView, memoHeaderLabel, addressHeaderLabel, memoView, addressView, copyButton].forEach {
            contentView.addSubview($0)
        }
        
        [backButton, naviTitleLabel, editButton].forEach {
            navigationStackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        navigationStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        naviTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationStackView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
        }
        
        thumbImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(240)
        }

        ratingHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(thumbImageView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(18)
        }

        ratingView.snp.makeConstraints {
            $0.centerY.equalTo(ratingHeaderLabel)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(38)
        }

        memoHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(ratingView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(18)
        }

        memoView.snp.makeConstraints {
            $0.top.equalTo(memoHeaderLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(120)
        }

        memoTextView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
        
        addressHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(memoView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(18)
        }
        
        addressView.snp.makeConstraints {
            $0.top.equalTo(addressHeaderLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
//        copyButton.snp.makeConstraints {
//            $0.centerY.equalTo(addressView)
//            $0.trailing.equalToSuperview().inset(16)
//            $0.size.equalTo(40)
//        }
    }

    override func configureView() {
        navigationStackView.axis = .horizontal
        navigationStackView.alignment = .center
        navigationStackView.distribution = .equalSpacing
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        backButton.setImage(.chevronLeft, for: .normal)
        backButton.tintColor = .textPrimary

        naviTitleLabel.text = "빽쌤 유튜브 짜장면"
        naviTitleLabel.font = .Head.head4
        naviTitleLabel.textColor = .textPrimary
        naviTitleLabel.textAlignment = .center

        editButton.setImage(.pencil, for: .normal)
        editButton.tintColor = .textPrimary

        thumbImageView.image = .placeholderSmall
        thumbImageView.contentMode = .scaleAspectFill
        thumbImageView.clipsToBounds = true
        thumbImageView.layer.cornerRadius = 6

        ratingHeaderLabel.text = "별점"
        memoHeaderLabel.text = "요리 기록"
        addressHeaderLabel.text = "주소"

        [ratingHeaderLabel, memoHeaderLabel, addressHeaderLabel].forEach {
            $0.font = .Body.body2
            $0.textColor = .textSecondary
        }
        
        ratingView.settings.updateOnTouch = false
        ratingView.settings.starSize = 30
        ratingView.settings.fillMode = .half
        ratingView.settings.starMargin = 5

        memoTextView.isEditable = false
        memoTextView.isScrollEnabled = true
        memoTextView.font = .Body.body4
        memoTextView.textColor = .textPrimary
        memoTextView.backgroundColor = .clear
        memoTextView.text = "불조절이 너무 어려웠다!! 특히 볶을 때말이지!! 다음부터는 중불로 하기~~~~~불조절이 너무 어려웠다!! 특히 볶을 때말이지!! 다음부터는 중불로 하기~~~~~불조절이 너무 어려웠다!! 특히 볶을 때말이지!! 다음부터는 중불로 하기~~~~~불조절이 너무 어려웠다!! 특히 볶을 때말이지!! 다음부터는 중불로 하기~~~~~불조절이 너무 어려웠다!! 특히 볶을 때말이지!! 다음부터는 중불로 하기~~~~~불조절이 너무 어려웠다!! 특히 볶을 때말이지!! 다음부터는 중불로 하기~~~~~"
        
        addressLabel.text = "서울특별시 마포구 망원로 12길"
        addressLabel.font = .Body.body4
        memoTextView.textColor = .textPrimary
        
        copyButton.setImage(.squareOnSquare, for: .normal)
        copyButton.tintColor = .textPrimary
        
        configureContextMenu()
    }
    
    private func configureContextMenu() {
        let editAction = UIAction(title: "수정하기", image: UIImage(systemName: "pencil")) { [weak self] _ in
            self?.didSelectEditMenu?()
        }

        let deleteAction = UIAction(title: "삭제하기", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            self?.didSelectDeleteMenu?()
        }

        editButton.menu = UIMenu(title: "", children: [editAction, deleteAction])
        editButton.showsMenuAsPrimaryAction = true
    }
}
