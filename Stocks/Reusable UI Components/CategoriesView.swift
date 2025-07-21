import UIKit
import SnapKit

class CategoriesView: UIView {
    
    var buttons: [CustomButtonModel] = []
    let stackView = UIStackView()
    
    private var buttonViews: [UIView] = []
    private var labels: [UILabel] = []
    
    private var activeButtonColor: UIColor = .black
    private var inactiveButtonsColor: UIColor = .gray
    
    private var buttonsInsets: CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview()
        }
    }
    
    func configure(with model: CategoriesModel) {
        let buttons = model.buttons
        self.activeButtonColor = model.activeButtonColor
        self.inactiveButtonsColor = model.inactiveButtonsColor
        buttonViews.forEach { $0.removeFromSuperview() }
        buttonViews.removeAll()
        labels.removeAll()
        self.buttons = buttons
        
        for (index, buttonModel) in buttons.enumerated() {
            let buttonContainer = UIView()
            buttonContainer.backgroundColor = .clear
            buttonContainer.isUserInteractionEnabled = true
            
            let label = UILabel()
            label.text = buttonModel.title
            label.textAlignment = .center
            label.font = buttonModel.font
            label.textColor = .gray
            label.numberOfLines = 1
            label.tag = index
            
            buttonContainer.addSubview(label)
            label.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            
            buttonViews.append(buttonContainer)
            labels.append(label)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleButtonTap(_:)))
            buttonContainer.addGestureRecognizer(tapGesture)
            buttonContainer.snp.makeConstraints { make in
                make.width.equalTo(buttonModel.title.width(withConstrainedHeight: 32, font: model.buttons.first?.font ?? UIFont.systemFont(ofSize: 28)) + buttonsInsets*2)
            }
            stackView.addArrangedSubview(buttonContainer)
        }
        let spacer = UIView()
        spacer.isUserInteractionEnabled = false
        spacer.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        stackView.addArrangedSubview(spacer)
        selectButton(at: 0)
    }
    
    @objc private func handleButtonTap(_ gesture: UITapGestureRecognizer) {
        guard let tappedView = gesture.view,
              let index = buttonViews.firstIndex(of: tappedView),
              index < buttons.count else { return }
        buttons[index].action?()
        selectButton(at: index)
    }
    
    private func selectButton(at index: Int) {
        for (i, label) in labels.enumerated() {
                if i == index {
                    UIView.animate(withDuration: 0.3) {
                        label.textColor = self.activeButtonColor
                        label.transform = CGAffineTransform(scaleX: 1.33, y: 1.33)
                    }
                } else {
                    UIView.animate(withDuration: 0.3) {
                        label.textColor = self.inactiveButtonsColor
                        label.transform = .identity
                    }
                }
            }
    }
}
