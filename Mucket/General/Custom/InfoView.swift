//
//  NutritionInfoView.swift
//  Mucket
//
//  Created by 조우현 on 3/30/25.
//

import UIKit
import SnapKit

final class InfoView: BaseView {
     private let titleLabel = UILabel()
     private let dividerView = UIView()
     let valueLabel = UILabel()
     private let unitLabel = UILabel()
     private let valueStack = UIStackView()
     private let mainStack = UIStackView()
     private var unitText: String = ""
     
     init(title: String, unit: String = "g") {
         super.init(frame: .zero)
         titleLabel.text = title
         unitLabel.text = unit
         valueLabel.text = "--"
     }
     
     override func configureHierarchy() {
         valueStack.addArrangedSubview(valueLabel)
         valueStack.addArrangedSubview(unitLabel)
         
         mainStack.addArrangedSubview(titleLabel)
         mainStack.addArrangedSubview(dividerView)
         mainStack.addArrangedSubview(valueStack)
         
         addSubview(mainStack)
     }
     
     override func configureLayout() {
         mainStack.snp.makeConstraints { make in
             make.edges.equalToSuperview()
         }
         
         dividerView.snp.makeConstraints { make in
             make.height.equalTo(2)
             make.width.equalTo(30)
         }
     }
     
     override func configureView() {
         titleLabel.font = .Body.body4
         titleLabel.textColor = .textPrimary
         titleLabel.textAlignment = .center
         
         dividerView.backgroundColor = .themePrimary
         
         valueLabel.font = .Body.body2
         valueLabel.textColor = .textPrimary
         
         unitLabel.font = .Body.body2
         unitLabel.textColor = .textPrimary
         
         valueStack.axis = .horizontal
         valueStack.spacing = 2
         valueStack.alignment = .center
         
         mainStack.axis = .vertical
         mainStack.spacing = 6
         mainStack.alignment = .center
     }
     
     func updateValue(_ value: Double) {
         valueLabel.text = String(format: "%.1f", value)
     }
}
