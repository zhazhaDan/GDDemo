//
//  LinkageScrollView.swift
//  GDDemo
//
//  Created by GDD on 2020/10/28.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit



public class LinkageScrollView: UIScrollView, UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self), otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            if let _ = otherGestureRecognizer.view as? LinkageCollectionView {
                return false
            }
            return true
        }
        return false
    }

}
