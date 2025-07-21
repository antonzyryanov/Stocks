//
//  StocksCell.swift
//  Stocks
//
//  Created by Anton Zyryanov on 21.07.2025.
//

import UIKit

class StocksCell: UICollectionViewCell {
    
    static let cellID = "StocksCell"
    
    var favouriteTapAction: ((Int?)->Void)?
    
    private var itemIndex: Int?
    
    override func prepareForReuse() {
        self.itemIndex = nil
    }
    
    private var bgView: UIView = {
        let bg = UIView()
        bg.layer.cornerRadius = 16
        bg.backgroundColor = .clear
        bg.isUserInteractionEnabled = true
        return bg
    }()
    
    private var companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private var favoritesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private var leftTopLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var leftBottomLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var rightTopLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var rightBottomLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var favoriteImageName: String = ""
    private var notFavoriteImageName: String = ""
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        print("StocksCell HIT TEST")
//        return nil
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        bgView.addSubview(companyImageView)
        companyImageView.snp.makeConstraints { make in
            make.height.width.equalTo(52)
            make.top.bottom.leading.equalToSuperview().inset(8)
            
        }
        setupLabels()
        bgView.addSubview(favoritesImageView)
        favoritesImageView.snp.makeConstraints { make in
            make.leading.equalTo(leftTopLabel.snp.trailing).inset(-6)
            make.centerY.equalTo(leftTopLabel)
        }
        self.contentView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFavouriteTap))
        favoritesImageView.addGestureRecognizer(tapGesture)
    }
    
    private func setupLabels() {
        bgView.addSubview(leftTopLabel)
        bgView.addSubview(leftBottomLabel)
        bgView.addSubview(rightTopLabel)
        bgView.addSubview(rightBottomLabel)
        leftTopLabel.snp.makeConstraints { make in
            make.leading.equalTo(companyImageView.snp.trailing).inset(-12)
            make.top.equalTo(companyImageView.snp.top).inset(6)
        }
        leftBottomLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftTopLabel.snp.leading)
            make.top.equalTo(leftTopLabel.snp.bottom)
        }
        rightTopLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(17)
            make.top.equalToSuperview().inset(14)
        }
        rightBottomLabel.snp.makeConstraints { make in
            make.trailing.equalTo(rightTopLabel)
            make.top.equalTo(rightTopLabel.snp.bottom)
        }
    }
    
    func configureWith(model: StocksCellModel) {
        self.leftTopLabel.font = model.topLeftLabelModel.font
        self.leftTopLabel.textColor = model.topLeftLabelModel.textColor
        self.leftBottomLabel.font = model.bottomLeftLabelModel.font
        self.leftBottomLabel.textColor = model.bottomLeftLabelModel.textColor
        self.rightTopLabel.font = model.topRightLabelModel.font
        self.rightTopLabel.textColor = model.topRightLabelModel.textColor
        self.rightBottomLabel.font = model.bottomRightLabelModel.font
        self.rightBottomLabel.textColor = model.bottomRightLabelModel.textColor
        
        self.leftTopLabel.text = model.data.symbol
        self.leftBottomLabel.text = model.data.name
        self.rightTopLabel.text = model.data.presentationPrice
        self.rightBottomLabel.text = model.data.presentationPriceDynamic
        self.rightBottomLabel.textColor = model.data.presentationPriceDynamic?.first == "+" ? .stocksGreen : .stocksRed
        self.favoritesImageView.image = (model.data.isFavourite ?? false) ? UIImage(named: model.favoriteImageName) : UIImage(named: model.notFavoriteImageName)
        self.companyImageView.downloaded(from: model.data.logo)
        self.itemIndex = model.itemIndex
        
        if model.itemIndex % 2 == 0 {
            self.bgView.backgroundColor = .stocksBGGray
        } else {
            self.bgView.backgroundColor = .white
        }
    }
    
    @objc private func handleFavouriteTap() {
        self.favouriteTapAction?(itemIndex)
    }
    
}
