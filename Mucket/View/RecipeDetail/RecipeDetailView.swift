//
//  RecipeDetailView.swift
//  Mucket
//
//  Created by 조우현 on 3/30/25.
//

import UIKit
import SnapKit

final class RecipeDetailView: BaseView {
    let scrollView = UIScrollView()
    private let contentView = UIView()

    private let nutritionHeaderLabel = UILabel()
    private let ingredientHeaderLabel = UILabel()
    let makingHeaderLabel = UILabel()
    
    // TODO: title이 길 경우 backButton이 잘리는 문제
    let navigationStackView = UIStackView()
    let backButton = UIButton()
    let naviTitleLabel = UILabel()
    let bookmarkButton = UIButton()
    
    lazy var ingredientView = ColorBackgroundContentView(contentView: ingredientTextView)
    let ingredientTextView = UITextView()
    let thumbImageView = UIImageView()
    
    private let infoStackView = UIStackView()
    let carInfoView = InfoView(title: "탄수화물")
    let proInfoView = InfoView(title: "지방")
    let fatInfoView = InfoView(title: "지방")
    let naInfoView = InfoView(title: "나트륨", unit: "mg")
    
    let makingStackView = UIStackView()
    
    override func configureHierarchy() {
        addSubview(navigationStackView)
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        [thumbImageView, nutritionHeaderLabel, infoStackView, ingredientHeaderLabel,
         ingredientView, makingHeaderLabel, makingStackView].forEach {
            contentView.addSubview($0)
        }

        [backButton, naviTitleLabel, bookmarkButton].forEach {
            navigationStackView.addArrangedSubview($0)
        }

        [carInfoView, proInfoView, fatInfoView, naInfoView].forEach {
            infoStackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        navigationStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        naviTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationStackView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        thumbImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(240)
        }

        nutritionHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbImageView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
        }

        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(nutritionHeaderLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }

        ingredientHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
        }

        ingredientView.snp.makeConstraints { make in
            make.top.equalTo(ingredientHeaderLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(120)
        }

        makingHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(ingredientView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
        }
        
        makingStackView.snp.makeConstraints { make in
            make.top.equalTo(makingHeaderLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        scrollView.showsVerticalScrollIndicator = false
        
        navigationStackView.axis = .horizontal
        navigationStackView.alignment = .center
        navigationStackView.distribution = .equalSpacing
        
        backButton.setImage(.chevronLeft, for: .normal)
        backButton.tintColor = .textPrimary
        
        naviTitleLabel.font = .Head.head4
        naviTitleLabel.textColor = .textPrimary
        naviTitleLabel.textAlignment = .center
        
        bookmarkButton.setImage(.bookmark, for: .normal)
        bookmarkButton.tintColor = .textPrimary
        
        thumbImageView.image = .placeholderSmall
        thumbImageView.backgroundColor = .backgroundPrimary
        thumbImageView.layer.cornerRadius = 6
        thumbImageView.clipsToBounds = true
        thumbImageView.contentMode = .scaleAspectFill
        
        nutritionHeaderLabel.text = "영양정보"
        ingredientHeaderLabel.text = "재료"
        makingHeaderLabel.text = "만드는 법"
        
        [nutritionHeaderLabel, ingredientHeaderLabel, makingHeaderLabel].forEach {
            $0.font = .Body.body2
            $0.textColor = .textSecondary
        }
        
        infoStackView.axis = .horizontal
        infoStackView.spacing = 16
        infoStackView.distribution = .fillEqually
        
        ingredientTextView.isEditable = false
        ingredientTextView.isScrollEnabled = true
        ingredientTextView.font = .Body.body4
        ingredientTextView.textColor = .textPrimary
        ingredientTextView.backgroundColor = .clear
        
        makingStackView.axis = .vertical
        makingStackView.spacing = 16
        makingStackView.alignment = .fill
        makingStackView.distribution = .fill
    }
}
