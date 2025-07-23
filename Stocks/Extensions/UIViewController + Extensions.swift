//
//  UIViewController + Extensions.swift
//  Stocks
//
//  Created by Anton Zyryanov on 21.07.2025.
//

import UIKit

extension UIViewController {
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
