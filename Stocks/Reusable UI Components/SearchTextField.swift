//
//  SearchTextField.swift
//  Stocks
//
//  Created by Anton Zyryanov on 21.07.2025.
//

import UIKit
import SnapKit

class SearchTextField: UIView {
    
    var finishSearchAction: ((UITextField)->Void)?
    
    private var textField: TextFieldWithCustomCancelButton = {
        let tf = TextFieldWithCustomCancelButton()
        tf.heightAnchor.constraint(equalToConstant: 48).isActive = true
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 24
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.black.cgColor
        tf.leftViewMode = .always
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        textField.delegate = self
    }
    
    private func setupView() {
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.textField.delegate = self
    }
    
    func configureWith(model: SearchTextFieldModel) {
        self.textField.font = model.font
        let imageView = UIImageView(image: model.image ?? UIImage(systemName: "magnifyingglass")!)
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 52, height: 24)
        imageView.contentMode = .right
        imageView.tintColor = .black
        imageView.frame = CGRect(x: 16, y: 0, width: 24, height: 24)
        leftView.addSubview(imageView)
        textField.leftView = leftView
        self.textField.textColor = model.textColor
        self.textField.attributedPlaceholder = NSAttributedString(
            string: model.placeHolder,
            attributes: [NSAttributedString.Key.foregroundColor: model.textColor]
        )
        
    }
    
    func setup(delegate: UITextFieldDelegate) {
        self.textField.delegate = delegate
    }
    
    func count() -> Int {
        return textField.text?.count ?? 0
    }
    
    func currentText() -> String {
        return textField.text ?? ""
    }
    
    func endEditing() {
        textField.endEditing(true)
    }
    
    func finishSearch() {
        finishSearchAction?(self.textField)
    }
    
    func isEditing() -> Bool {
        return textField.isEditing
    }
    
    func set(text: String) {
        textField.text = text
        finishSearchAction?(self.textField)
    }
    
}

extension SearchTextField: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let currentText = textField.text ?? ""
        if currentText == "" {
            textField.rightView?.isHidden = true
        } else {
            textField.rightView?.isHidden = false
        }
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
}
