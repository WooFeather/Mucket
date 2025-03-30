//
//  RecipeDetailView.swift
//  Mucket
//
//  Created by 조우현 on 3/30/25.
//

import UIKit
import SnapKit

final class RecipeDetailView: BaseView {
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let nutritionHeaderLabel = UILabel()
    private let ingredientHeaderLabel = UILabel()
    private let makingHeaderLabel = UILabel()
    
    private let navigationStackView = UIStackView()
    let backButton = UIButton()
    let naviTitleLabel = UILabel()
    let bookmarkButton = UIButton()
    
    let ingredientBackground = UIView()
    let ingredientLabel = UILabel()
    let thumbImageView = UIImageView()
    
    private let infoStackView = UIStackView()
    let carInfoView = InfoView(title: "탄수화물")
    let proInfoView = InfoView(title: "지방")
    let fatInfoView = InfoView(title: "지방")
    let naInfoView = InfoView(title: "나트륨", unit: "mg")
    
    let makingTableView = UITableView()
    
    override func configureHierarchy() {
        addSubview(navigationStackView)
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        [thumbImageView, nutritionHeaderLabel, infoStackView, ingredientHeaderLabel,
         ingredientBackground, makingHeaderLabel, makingTableView].forEach {
            contentView.addSubview($0)
        }

        ingredientBackground.addSubview(ingredientLabel)

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
            make.height.equalTo(200)
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

        ingredientBackground.snp.makeConstraints { make in
            make.top.equalTo(ingredientHeaderLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        ingredientLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }

        makingHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(ingredientBackground.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
        }

        makingTableView.snp.makeConstraints { make in
            make.top.equalTo(makingHeaderLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(800)
            make.bottom.equalToSuperview().offset(-32)
        }
    }
    
    // TODO: 이전 뷰에서 전달받은 값 넣을 예정
    override func configureView() {
        navigationStackView.axis = .horizontal
        navigationStackView.alignment = .center
        navigationStackView.distribution = .equalSpacing
        
        backButton.setImage(.chevronLeft, for: .normal)
        backButton.tintColor = .textPrimary
        
        naviTitleLabel.text = "간편 카레 레시피"
        naviTitleLabel.font = .Head.head4
        naviTitleLabel.textColor = .textPrimary
        
        // TODO: 북마크 상태에 따라서 이미지 대응
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
        
        ingredientBackground.backgroundColor = .backgroundSecondary
        ingredientBackground.layer.cornerRadius = 6
        
        ingredientLabel.numberOfLines = 0
        ingredientLabel.font = .Body.body4
        ingredientLabel.textColor = .textPrimary
        ingredientLabel.text = "닭고기(1마리), 가시오가피(10g), 대파(20g), 다시마(10g), 건새우(20g), 실곤약(100g), 비트(30g), 치자가루(10g), 마늘(20g), 소금(0.3g), 후춧가루(0.01g), 양파(50g),오이(50g), 겨자가루(10g), 식초(20g), 설탕(20g)"
        
        makingTableView.backgroundColor = .lightGray
        makingTableView.isScrollEnabled = false
        makingTableView.separatorStyle = .none
        makingTableView.rowHeight = UITableView.automaticDimension
        makingTableView.estimatedRowHeight = 100
    }
}
