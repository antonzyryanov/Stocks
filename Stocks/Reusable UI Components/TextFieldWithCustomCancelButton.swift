//
//  TextFieldWithCustomCancelButton.swift
//  Stocks
//
//  Created by Anton Zyryanov on 21.07.2025.
//

import UIKit

class TextFieldWithCustomCancelButton : UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        let image = UIImage(named: "cancel_icon")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        rightView.addSubview(imageView)

        self.rightView = rightView
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.clearClicked))
        rightView.addGestureRecognizer(tap)
        self.clearButtonMode = .never
        self.rightViewMode = .always
        self.rightView?.isHidden = true
    }

    @objc private func clearClicked() {
        self.text = ""
        self.rightView?.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
