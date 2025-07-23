//
//  CustomTableHeaderModel.swift
//  Stocks
//
//  Created by Anton Zyryanov on 22.07.2025.
//

import Foundation

struct CustomTableHeaderModel {
    var leftLabelText: String
    var rightLabelText: String
    var leftLabelStyle: CustomLabelModel
    var rightLabelStyle: CustomLabelModel
    var rightLabelTapAction: (()->Void)?
}
