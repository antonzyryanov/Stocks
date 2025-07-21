//
//  UIFont + Extensions.swift
//  Stocks
//
//  Created by Anton Zyryanov on 21.07.2025.
//

import UIKit

extension UIFont {
    
    // MARK: - Montserrat Bold Fonts
    
    static var montserratBold28: UIFont {
        return UIFont(name: "Montserrat-Bold", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .bold)
    }
    
    static var montserratBold24: UIFont {
        return UIFont(name: "Montserrat-Bold", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    
    static var montserratBold18: UIFont {
        return UIFont(name: "Montserrat-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    static var montserratBold11: UIFont {
        return UIFont(name: "Montserrat-Bold", size: 11) ?? UIFont.systemFont(ofSize: 11, weight: .semibold)
    }
    
    static var montserratBold12: UIFont {
        return UIFont(name: "Montserrat-Bold", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .semibold)
    }
    
    static var montserratMedium16: UIFont {
        return UIFont(name: "Montserrat-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
}
