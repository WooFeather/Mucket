//
//  CookingDetailView.swift
//  Mucket
//
//  Created by 조우현 on 3/31/25.
//

import UIKit
import SnapKit
import Cosmos

final class CookingDetailView: BaseView {
    private let ratingHeaderLabel = UILabel()
    private let memoHeaderLabel = UILabel()
    private let videoHeaderLabel = UILabel()
    let emptyVideoBackground = UIView()
    private let emptyVideoLabel = UILabel()
    private lazy var memoView = ColorBackgroundContentView(contentView: memoTextView)
    
    private let navigationStackView = UIStackView()
    let backButton = UIButton()
    let naviTitleLabel = UILabel()
    let editButton = UIButton()
    
    // 스크롤뷰와 콘텐츠뷰 추가
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let thumbImageView = UIImageView() // TODO: pageControl 들어갈 예정
    let ratingView = CosmosView()
    let memoTextView = UITextView()
    let emptyVideoView = UIView()
    
    let youtubePlayerContainerView = UIView()
    
    private let contextMenuItems = ["수정하기", "삭제하기"]
    var didSelectEditMenu: (() -> Void)?
    var didSelectDeleteMenu: (() -> Void)?
    
    override func configureHierarchy() {
        [navigationStackView, scrollView].forEach {
            addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        
        [thumbImageView, ratingHeaderLabel, ratingView, memoHeaderLabel, memoView, videoHeaderLabel, emptyVideoView, emptyVideoBackground, youtubePlayerContainerView].forEach {
            contentView.addSubview($0)
        }
        
        emptyVideoBackground.addSubview(emptyVideoLabel)
        
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

        videoHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(memoView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(18)
        }

        emptyVideoView.snp.makeConstraints {
            $0.top.equalTo(videoHeaderLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(180)
        }
        
        youtubePlayerContainerView.snp.makeConstraints {
            $0.top.equalTo(videoHeaderLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(180)
        }
        
        emptyVideoBackground.snp.makeConstraints {
            $0.top.equalTo(videoHeaderLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(180)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        emptyVideoLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
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
        videoHeaderLabel.text = "레시피 영상"

        [ratingHeaderLabel, memoHeaderLabel, videoHeaderLabel].forEach {
            $0.font = .Body.body2
            $0.textColor = .textSecondary
        }
        
        ratingView.settings.updateOnTouch = false
        ratingView.settings.starSize = 30
        ratingView.settings.fillMode = .half
        ratingView.settings.starMargin = 5
        
        emptyVideoBackground.backgroundColor = .themeSecondary
        emptyVideoBackground.layer.cornerRadius = 6
        
        emptyVideoLabel.text = """
        영상 링크가 없습니다.
        편집 버튼을 눌러 추가해보세요.
        """
        emptyVideoLabel.numberOfLines = 2
        emptyVideoLabel.textColor = .textSecondary
        emptyVideoLabel.font = .Body.body4
        emptyVideoLabel.textAlignment = .center

        memoTextView.isEditable = false
        memoTextView.isScrollEnabled = true
        memoTextView.font = .Body.body4
        memoTextView.textColor = .textPrimary
        memoTextView.backgroundColor = .clear
        memoTextView.text = "불조절이 너무 어려웠다!! 특히 볶을 때말이지!! 다음부터는 중불로 하기~~~~~불조절이 너무 어려웠다!! 특히 볶을 때말이지!! 다음부터는 중불로 하기~~~~~불조절이 너무 어려웠다!! 특히 볶을 때말이지!! 다음부터는 중불로 하기~~~~~불조절이 너무 어려웠다!! 특히 볶을 때말이지!! 다음부터는 중불로 하기~~~~~불조절이 너무 어려웠다!! 특히 볶을 때말이지!! 다음부터는 중불로 하기~~~~~불조절이 너무 어려웠다!! 특히 볶을 때말이지!! 다음부터는 중불로 하기~~~~~"
        
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
