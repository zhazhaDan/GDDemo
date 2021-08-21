//
//  CollectionViewLayoutStyle2.swift
//  GDDemo
//
//  Created by GDD on 2021/7/7.
//  Copyright © 2021 GDD. All rights reserved.
//

import UIKit


let itemCircleSizeWidth: CGFloat = 80
class CollectionViewLayoutStyle2: UICollectionViewFlowLayout {
    var cellCount = 20
    var center: CGPoint = .zero
    var radius: CGFloat = 0


    var pinchCellPath: IndexPath?
    var pinchCellScale: CGFloat = 0
    var pinchCellCenter: CGPoint = .zero

    override func prepare() {
        super.prepare()
        self.itemSize = CGSize.init(width: itemCircleSizeWidth, height: itemCircleSizeWidth)
        cellCount = self.collectionView?.numberOfItems(inSection: 0) ?? 0
        if let size = self.collectionView?.size {
            center = CGPoint.init(x: size.width / 2, y: size.height / 2)
            radius = min(size.width, size.height) / 2.5
        }
    }


    override var collectionViewContentSize: CGSize {
        return self.collectionView?.size ?? .zero
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        attribute.size = CGSize.init(width: itemCircleSizeWidth, height: itemCircleSizeWidth)
        attribute.center = CGPoint.init(x: center.x + radius * CGFloat(cosf(Float(2.0 * Double(indexPath.item) * Double.pi / Double(cellCount)))),
                                        y: center.y + radius * CGFloat(sinf(Float(2.0 * Double(indexPath.item) * Double.pi / Double(cellCount)))))
        if let _ = self.pinchCellPath {
            return applyPinchToLayoutAttributes(layoutAttribute: attribute)
        } else {
            return attribute
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var aray: [UICollectionViewLayoutAttributes] = []
        for i in 0..<cellCount {
            let indexPath = IndexPath.init(item: i, section: 0)
            if let att = layoutAttributesForItem(at: indexPath) {
                if let _ = self.pinchCellPath {
                    aray.append(self.applyPinchToLayoutAttributes(layoutAttribute: att))
                } else {
                    aray.append(att)
                }
            }
        }
        return aray
    }

    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = layoutAttributesForItem(at: itemIndexPath)
        attribute?.alpha = 0
        attribute?.center = center
        return attribute
    }

    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = layoutAttributesForItem(at: itemIndexPath)
        attribute?.alpha = 0
        attribute?.center = center
        attribute?.transform3D = CATransform3DMakeScale(0.1, 0.1, 1)
        return attribute
    }


    func applyPinchToLayoutAttributes(layoutAttribute: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if layoutAttribute.indexPath == self.pinchCellPath {
            layoutAttribute.transform3D = CATransform3DMakeScale(self.pinchCellScale, self.pinchCellScale, 1)
            layoutAttribute.center = self.pinchCellCenter
            layoutAttribute.zIndex = 1
        }
        return layoutAttribute
    }
}
