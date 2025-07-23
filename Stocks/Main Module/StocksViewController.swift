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
    private var popularPrompts: PromptsModel = PromptsModel(items: [])
    private var historyPrompts: PromptsModel = PromptsModel(items: [])
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        view.showsVerticalScrollIndicator = false
        return view
    }()
        
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let searchTextField = SearchTextField()
    private let categoriesView = CategoriesView(frame: CGRect(x: 0, y: 0, width: 300, height: 32))
    private var searchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.isUserInteractionEnabled = true
        stackView.axis = .vertical
        return stackView
    }()
    
    private let popularRequestsPromptsCloud = CloudsView(frame: CGRect(x: 0, y: 0, width: 300, height: 123))
    private let searchHistoryPromptsCloud = CloudsView(frame: CGRect(x: 0, y: 0, width: 300, height: 123))
    private let tableHeader = CustomTableHeader(frame: CGRect(x: 0, y: 0, width: 300, height: 24))
    private let secondSpacer = UIView(frame: .init(x: 0, y: 0, width: 300, height: 28))
    
    private var stocksCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestUpdate()
        setupKeyboardTapGesture()
        setupTextField()
        hideSearchStackViewElements()
        self.categoriesView.isHidden = false
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
        
        let searchTextFieldModel = SearchTextFieldModel(font: .montserratMedium16, textColor: .stocksBlack, image: UIImage(named: "search_icon"), placeHolder: "Find company or ticker")
        searchTextField.configureWith(model: searchTextFieldModel)
        contentView.addSubview(searchStackView)
        searchStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(searchTextField.snp.bottom).inset(-20)
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
        
        searchStackView.addArrangedSubview(categoriesView)
        categoriesView.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalToSuperview()
        }
        
        let firstSpacer = UIView(frame: .init(x: 0, y: 0, width: self.searchStackView.frame.width, height: 20))
        firstSpacer.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        searchStackView.addArrangedSubview(firstSpacer)
        
       
        popularRequestsPromptsCloud.setTitle("Popular requests")
        popularRequestsPromptsCloud.tapAction = { text in
            print("[PopularRequestsPromptsCloud]: Tapped label \(text)")
        }
        popularRequestsPromptsCloud.configure(with:
                .init(prompts: popularPrompts, titleFont: .montserratBold18, itemsFont: .montserratBold12)
        )
        popularRequestsPromptsCloud.tapAction = { prompt in
            if self.searchTextField.isEditing() {
                self.searchTextField.set(text: prompt)
            }
        }
        searchStackView.addArrangedSubview(popularRequestsPromptsCloud)
        popularRequestsPromptsCloud.snp.makeConstraints { make in
            make.height.equalTo(123)
            make.width.equalToSuperview()
        }
        
        secondSpacer.snp.makeConstraints { make in
            make.height.equalTo(28)
        }
        searchStackView.addArrangedSubview(secondSpacer)
        
        searchHistoryPromptsCloud.setTitle("You’ve searched for this")
        searchHistoryPromptsCloud.tapAction = { text in
            print("[SearchHistoryPromptsCloud]: Tapped label \(text)")
        }
        searchHistoryPromptsCloud.configure(with:
                .init(prompts:
                        historyPrompts
                      , titleFont: .montserratBold18, itemsFont: .montserratBold12, promptsReversed: true)
        )
        searchStackView.addArrangedSubview(searchHistoryPromptsCloud)
        searchHistoryPromptsCloud.snp.makeConstraints { make in
            make.height.equalTo(123)
            make.width.equalToSuperview()
        }
        tableHeader.configureWith(model: .init(leftLabelText: "Stocks", rightLabelText: "Show more", leftLabelStyle: .init(font: .montserratBold18, textColor: .stocksBlack), rightLabelStyle: .init(font: .montserratBold12, textColor: .stocksBlack),rightLabelTapAction: {
            self.searchTextField.finishSearch()
        }))
        searchStackView.addArrangedSubview(tableHeader)
        tableHeader.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalToSuperview()
        }
        
        setupStocksCollectionView()
        tableHeader.isHidden = true
        secondSpacer.isHidden = true
    }
    
    private func requestUpdate() {
        presenter?.handleViewsRequestUpdate()
    }
    
    private func setupKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(finishSearch))
        view.addGestureRecognizer(tap)
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
            make.top.equalTo(searchStackView.snp.bottom).inset(-20)
            make.height.equalTo(self.view.snp.height)
        }
        stocksCollectionView.showsVerticalScrollIndicator = false
        stocksCollectionView.isScrollEnabled = false
        stocksCollectionView.isUserInteractionEnabled = true
    }
    
    private func updateStocksCollectionView(isFilterOn: Bool = false) {
        if isFilterOn {
            currentlyPresentingStocksModels = presentationStocksModels.filter({ stock in
                let firstSubString = stock.name.prefix(searchTextField.count())
                let secondSubString = stock.symbol.prefix(searchTextField.count())
                if searchTextField.currentText().contains(firstSubString) || searchTextField.currentText().contains(secondSubString)  {
                    return true
                } else {
                    return false
                }
            })
        } else {
            if isOnlyFavouritesShown {
                currentlyPresentingStocksModels = presentationStocksModels.filter({$0.isFavourite ?? false
                })
            } else {
                currentlyPresentingStocksModels = presentationStocksModels
            }
        }
        stocksCollectionView.snp.makeConstraints { make in
            make.height.equalTo(64*currentlyPresentingStocksModels.count)
        }
        DispatchQueue.main.async {
            self.stocksCollectionView.reloadData()
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupTextField() {
        self.searchTextField.setup(delegate: self)
        self.searchTextField.finishSearchAction = finishSearchOf(textField:)
    }
    
    
    private func hideSearchStackViewElements() {
        categoriesView.isHidden = true
        popularRequestsPromptsCloud.isHidden = true
        searchHistoryPromptsCloud.isHidden = true
        secondSpacer.isHidden = true
    }
    
    private func showSearchStackViewElements() {
        popularRequestsPromptsCloud.isHidden = false
        searchHistoryPromptsCloud.isHidden = false
        secondSpacer.isHidden = false
    }
    
    @objc private func finishSearch() {
        searchTextField.finishSearch()
    }
    
}

extension StocksViewController: PresenterToViewStocksProtocol{
    
    func handleUpdateOf(presentationModel: StocksModulePresentationModel) {
        presentationStocksModels = presentationModel.stocks
        currentlyPresentingStocksModels = presentationModel.stocks
        popularPrompts = presentationModel.popularPrompts
        historyPrompts = presentationModel.historyPrompts
        popularRequestsPromptsCloud.configure(with:  .init(prompts: popularPrompts, titleFont: .montserratBold18, itemsFont: .montserratBold12))
        searchHistoryPromptsCloud.configure(with:  .init(prompts: historyPrompts, titleFont: .montserratBold18, itemsFont: .montserratBold12, promptsReversed: true))
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
        cell.configureWith(model:
                .init(data: currentlyPresentingStocksModels[indexPath.row], topLeftLabelModel: .init(font: .montserratBold18, textColor: .stocksBlack), bottomLeftLabelModel: .init(font: .montserratBold11, textColor: .stocksBlack), topRightLabelModel: .init(font: .montserratBold18, textColor: .stocksBlack), bottomRightLabelModel: .init(font: .montserratBold12, textColor: .stocksGreen), favoriteImageName: "favourite_icon", notFavoriteImageName: "not_favourite_icon", itemIndex: indexPath.row)
        )
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
    }
    
}

extension StocksViewController: UITextFieldDelegate {
    
    private func finishSearchOf(textField: UITextField) {
        if textField.text?.replacingOccurrences(of: " ", with: "") != "" {
            self.historyPrompts = .init(items: self.historyPrompts.items + [textField.text ?? ""])
            searchHistoryPromptsCloud.configure(with:
                    .init(prompts:
                            historyPrompts
                          , titleFont: .montserratBold18, itemsFont: .montserratBold12, promptsReversed: true)
            )
            presenter?.handleUpdateOfHistory(prompts: self.historyPrompts)
            textField.endEditing(true)
        } else {
            textField.endEditing(true)
            updateStocksCollectionView()
        }
        self.tableHeader.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        finishSearchOf(textField: textField)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let currentText = textField.text ?? ""
        if currentText.count == 0 {
            self.tableHeader.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.showSearchStackViewElements()
            }
            self.stocksCollectionView.isHidden = true
        } else {
            self.tableHeader.isHidden = false
            updateStocksCollectionView(isFilterOn: true)
            self.stocksCollectionView.isHidden = false
        }
        self.categoriesView.isHidden = true
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.3) {
            self.hideSearchStackViewElements()
            self.stocksCollectionView.isHidden = false
            self.categoriesView.isHidden = false
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let currentText = textField.text ?? ""
        if currentText.count > 0 {
            self.tableHeader.isHidden = false
            self.hideSearchStackViewElements()
            self.stocksCollectionView.isHidden = false
            updateStocksCollectionView(isFilterOn: true)
        } else {
            self.tableHeader.isHidden = true
            self.showSearchStackViewElements()
            self.stocksCollectionView.isHidden = true
            updateStocksCollectionView(isFilterOn: false)
        }
    }
    
}

