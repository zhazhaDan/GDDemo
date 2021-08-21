//
//  CollectionViewLayoutStyle1.swift
//  GDDemo
//
//  Created by GDD on 2021/7/7.
//  Copyright © 2021 GDD. All rights reserved.
//

import UIKit

let itemSizeWidth: CGFloat = 200
let ActiveDistance: CGFloat = 200
let zoom: CGFloat = 0.5
class CollectionViewLayoutStyle1: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.itemSize = CGSize.init(width: itemSizeWidth, height: itemSizeWidth)
        self.scrollDirection = .horizontal
        self.sectionInset = .init(top: 400, left: 0, bottom: 400, right: 0)
        self.minimumLineSpacing = 20
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let array = super.layoutAttributesForElements(in: rect) {
            if let collectionV = self.collectionView {
                let visibleRect = CGRect.init(origin: collectionV.contentOffset, size: collectionV.size)
                for attribute in array {
                    if attribute.frame.intersects(rect) {
                        let distance = visibleRect.midX - attribute.center.x
                        let normalizedDistanc = distance / ActiveDistance
                        if abs(distance) < ActiveDistance {
                            let zoom = 1 + zoom * (1-abs(normalizedDistanc))
                            attribute.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                            attribute.zIndex = Int(round(zoom))
                        }
                    }
                }
            }
            return array
        }
        return nil
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment: CGFloat = CGFloat(MAXFLOAT)
        let horizontalCenter = proposedContentOffset.x + (self.collectionView?.bounds.width ?? 0 ) / 2.0
        let targetRect = CGRect.init(x: proposedContentOffset.x, y: 0, width: self.collectionView?.width ?? 0, height: self.collectionView?.height ?? 0)
        if let array = super.layoutAttributesForElements(in: targetRect) {
            for attribute in array {
                let itemHorCenter = attribute.center.x
                if abs(itemHorCenter - horizontalCenter) < abs(offsetAdjustment) {
                    offsetAdjustment = itemHorCenter - horizontalCenter
                }
            }
            return CGPoint.init(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
        }
        return proposedContentOffset
    }

}
