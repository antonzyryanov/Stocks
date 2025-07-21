//
//  StocksViewController.swift
//  Stocks
//
//  Created by Anton Zyryanov on 20.07.2025.
//  
//

import UIKit

class StocksViewController: UIViewController {
    
    var presenter: ViewToPresenterStocksProtocol?
    
    private var isOnlyFavouritesShown: Bool = false {
        didSet {
            updateStocksCollectionView()
        }
    }
    private var presentationStocksModels: [StocksModel] = []
    private var currentlyPresentingStocksModels: [StocksModel] = []
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        view.showsVerticalScrollIndicator = false
        return view
    }()
        
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let searchTextField = SearchTextField()
    let categoriesView = CategoriesView()
    var collectionsViewsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.isUserInteractionEnabled = true
        stackView.axis = .vertical
        return stackView
    }()
    
    var stocksCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hideKeyboardWhenTappedAround()
        requestUpdate()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func requestUpdate() {
        presenter?.handleViewsRequestUpdate()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
        }
        contentView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(self.view)
        }
        contentView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
        }
        contentView.addSubview(categoriesView)
        categoriesView.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(searchTextField.snp.bottom).inset(-20)
        }
        contentView.addSubview(collectionsViewsStackView)
        collectionsViewsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(categoriesView.snp.bottom).inset(-20)
            make.bottom.equalToSuperview().inset(20)
        }
        let customButtons: [CustomButtonModel] = [
            CustomButtonModel(title: "Stocks", font: .montserratBold28, action: {
                self.isOnlyFavouritesShown = false
            }),
            CustomButtonModel(title: "Favourite", font: .montserratBold28, action: {
                self.isOnlyFavouritesShown = true
            })
        ]
        let categoriesModel = CategoriesModel(buttons: customButtons, activeButtonColor: .stocksBlack, inactiveButtonsColor: .stocksGray)
        categoriesView.configure(with: categoriesModel)
        let searchTextFieldModel = SearchTextFieldModel(font: .montserratMedium16, textColor: .stocksBlack, image: UIImage(named: "search_icon"), placeHolder: "Find company or ticker")
        searchTextField.configureWith(model: searchTextFieldModel)
        setupStocksCollectionView()
    }
    
    private func setupStocksCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.main.bounds.width - 32, 68)
        layout.scrollDirection = .vertical
        stocksCollectionView = CollectionViewInsideScrollView(frame: CGRectZero, collectionViewLayout: layout)
        
        stocksCollectionView.register(StocksCell.self, forCellWithReuseIdentifier: StocksCell.cellID)
        stocksCollectionView.delegate   = self
        stocksCollectionView.dataSource = self
        self.contentView.addSubview(stocksCollectionView)
        stocksCollectionView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(self.contentView).inset(16)
            make.top.equalTo(categoriesView.snp.bottom).inset(-20)
            make.height.equalTo(self.view.snp.height)
        }
        stocksCollectionView.showsVerticalScrollIndicator = false
        stocksCollectionView.isScrollEnabled = false
        stocksCollectionView.isUserInteractionEnabled = true
    }
    
    private func updateStocksCollectionView() {
        if isOnlyFavouritesShown {
            currentlyPresentingStocksModels = presentationStocksModels.filter({$0.isFavourite ?? false
            })
        } else {
            currentlyPresentingStocksModels = presentationStocksModels
        }
        stocksCollectionView.snp.makeConstraints { make in
            make.height.equalTo(64*currentlyPresentingStocksModels.count)
        }
        DispatchQueue.main.async {
            self.stocksCollectionView.reloadData()
            self.view.layoutIfNeeded()
        }
    }
    
}

extension StocksViewController: PresenterToViewStocksProtocol{
    
    func handleUpdateOf(stocks: [StocksModel]) {
        presentationStocksModels = stocks
        currentlyPresentingStocksModels = stocks
        stocksCollectionView.snp.makeConstraints { make in
            make.height.equalTo(64*currentlyPresentingStocksModels.count)
        }
        DispatchQueue.main.async {
            self.stocksCollectionView.reloadData()
            self.view.layoutIfNeeded()
        }
    }
    
}

extension StocksViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentlyPresentingStocksModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StocksCell.cellID, for: indexPath)
                as! StocksCell
        cell.configureWith(model: .init(data: currentlyPresentingStocksModels[indexPath.row], topLeftLabelModel: .init(font: .montserratBold18, textColor: .stocksBlack), bottomLeftLabelModel: .init(font: .montserratBold11, textColor: .stocksBlack), topRightLabelModel: .init(font: .montserratBold18, textColor: .stocksBlack), bottomRightLabelModel: .init(font: .montserratBold12, textColor: .stocksGreen), favoriteImageName: "favourite_icon", notFavoriteImageName: "not_favourite_icon", itemIndex: indexPath.row))
        cell.favouriteTapAction = { index in
            if let i = index {
                for (index,stock) in self.presentationStocksModels.enumerated() {
                    if stock.name == self.currentlyPresentingStocksModels[i].name {
                        self.presentationStocksModels[index].isFavourite?.toggle()
                        self.presenter?.handleUpdateOfStock(presentationModel: stock)
                    }
                }
                self.updateStocksCollectionView()
            }
        }
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt")
    }
    
}
