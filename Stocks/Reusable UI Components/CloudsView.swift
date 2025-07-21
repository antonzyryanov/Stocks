//
//  CloudsView.swift
//  Stocks
//
//  Created by Anton Zyryanov on 21.07.2025.
//

import UIKit
import SnapKit

import UIKit
import SnapKit

class LabelContainerView: UIView {
    let label = UILabel()
    var tapAction: ((String) -> Void)?
    private var labelText: String

    init(text: String, font: UIFont, tapAction: ((String) -> Void)? = nil) {
        self.labelText = text
        self.tapAction = tapAction
        super.init(frame: .zero)
        setupLabel(with: text)
        setupConstraints()
        setupBackground()
        addTapGesture()
        self.label.font = font
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabel(with text: String) {
        label.text = text
        label.numberOfLines = 1
        label.textAlignment = .center
        addSubview(label)
    }

    private func setupBackground() {
        self.backgroundColor = .stocksBGGray
        self.layer.cornerRadius = 20
    }

    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }

    @objc private func handleTap() {
        tapAction?(labelText)
    }

    override var intrinsicContentSize: CGSize {
        let labelSize = label.intrinsicContentSize
        return CGSize(width: labelSize.width + 32, height: 40)
    }
}

class CloudsView: UIView {
    private let titleLabel = UILabel()
    
    private let scrollView = UIScrollView()
    private let stackContainer = UIStackView()

    private let verticalStackView = UIStackView()
    private let firstHorizontalStackView = UIStackView()
    private let secondHorizontalStackView = UIStackView()
    
    private var itemsFont: UIFont = .systemFont(ofSize: 16)

    var tapAction: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }

    private func setupView() {
        backgroundColor = .white
        titleLabel.textColor = .black
        addSubview(titleLabel)

        addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false

        scrollView.addSubview(stackContainer)
        stackContainer.axis = .horizontal
        stackContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }

        stackContainer.addSubview(verticalStackView)
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        [firstHorizontalStackView, secondHorizontalStackView].forEach { hStack in
            hStack.axis = .horizontal
            hStack.alignment = .center
            hStack.spacing = 8
        }

        verticalStackView.addArrangedSubview(firstHorizontalStackView)
        verticalStackView.addArrangedSubview(secondHorizontalStackView)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(0)
            make.leading.equalTo(self).offset(4)
            make.height.equalTo(20)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.leading.trailing.bottom.equalTo(self)
        }
    }

    func setTitle(_ text: String) {
        titleLabel.text = text
    }

    private func createLabelView(with text: String, font: UIFont) -> LabelContainerView {
        let view = LabelContainerView(text: text, font: font, tapAction: tapAction)
        return view
    }

    func configureFirstStackView(with texts: [String], font: UIFont) {
        firstHorizontalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for text in texts {
            let view = createLabelView(with: text, font: font)
            view.snp.makeConstraints { make in
                make.height.equalTo(40)
            }
            firstHorizontalStackView.addArrangedSubview(view)
        }
    }

    func configureSecondStackView(with texts: [String], font: UIFont) {
        secondHorizontalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for text in texts {
            let view = createLabelView(with: text, font: font)
            view.snp.makeConstraints { make in
                make.height.equalTo(40)
            }
            secondHorizontalStackView.addArrangedSubview(view)
        }
    }

    func configure(with model: CloudsModel) {
        var unevenTexts: [String] = []
        var evenTexts: [String] = []

        for (index, text) in model.prompts.items.enumerated() {
            if index % 2 == 0 {
                evenTexts.append(text)
            } else {
                unevenTexts.append(text)
            }
        }

        titleLabel.font = model.titleFont
        itemsFont = model.itemsFont
        configureFirstStackView(with: evenTexts, font: model.itemsFont)
        configureSecondStackView(with: unevenTexts, font: model.itemsFont)
    }
}
