//
//  CustomCollectionView.swift
//  Stocks
//
//  Created by Anton Zyryanov on 21.07.2025.
//

import UIKit

class CollectionViewInsideScrollView: UICollectionView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        superview?.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        superview?.superview?.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        superview?.superview?.touchesEnded(touches, with: event)
    }
    
}
