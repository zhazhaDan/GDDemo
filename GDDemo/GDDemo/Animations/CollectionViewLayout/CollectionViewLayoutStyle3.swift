//
//  CollectionViewLayoutStyle3.swift
//  GDDemo
//
//  Created by GDD on 2021/7/7.
//  Copyright © 2021 GDD. All rights reserved.
//

import UIKit

class CollectionViewLayoutStyle3: UICollectionViewFlowLayout {

    var pinchCellPath: IndexPath?
    var pinchCellScale: CGFloat = 0
    var pinchCellCenter: CGPoint = .zero

    func applyPinchToLayoutAttributes(layoutAttribute: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if layoutAttribute.indexPath == self.pinchCellPath {
            layoutAttribute.transform3D = CATransform3DMakeScale(self.pinchCellScale, self.pinchCellScale, 1)
            layoutAttribute.center = self.pinchCellCenter
            layoutAttribute.zIndex = 1
        }
        return layoutAttribute
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)

        return applyPinchToLayoutAttributes(layoutAttribute: attribute)

    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let array = super.layoutAttributesForElements(in: rect) {
            for attribute in array {
                _ = applyPinchToLayoutAttributes(layoutAttribute: attribute)
            }
            return array
        }
        return nil
    }

}
