//
//  CustomTableHeader.swift
//  Stocks
//
//  Created by Anton Zyryanov on 22.07.2025.
//

import UIKit

class CustomTableHeader: UIView {
    
    var leftLabel = UILabel()
    var rightLabel = UILabel()
    var rightLabelTapAction: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(leftLabel)
        addSubview(rightLabel)
        leftLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self)
            make.leading.equalTo(self).inset(4)
        }
        rightLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self)
            make.trailing.equalTo(self).inset(4)
        }
    }
    
    func configureWith(model: CustomTableHeaderModel) {
        leftLabel.text = model.leftLabelText
        leftLabel.textColor = model.leftLabelStyle.textColor
        leftLabel.font = model.leftLabelStyle.font
        rightLabel.text = model.rightLabelText
        rightLabel.textColor = model.rightLabelStyle.textColor
        rightLabel.font = model.rightLabelStyle.font
        rightLabelTapAction = model.rightLabelTapAction
        leftLabel.textAlignment = .left
        rightLabel.textAlignment = .right
    }
    
}
