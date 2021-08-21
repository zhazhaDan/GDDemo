//
//  LinkageContentProtocol.swift
//  GDDemo
//
//  Created by GDD on 2020/10/28.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit

public protocol LinkageContentProtocol {
    var linkage_contentView: UIView { get }
    var linkage_contentScrollView: UIView { get }
    var linkage_scrollViewDidScroll: ((UIScrollView) -> Void)? { set get }
    func linkage_contentWillAppear()
    func linkage_contentDidDisappear()
}
extension LinkageContentProtocol {
    func linkage_contentWillAppear() {}
    func linkage_contentDidDisappear() {}
}




public protocol LinkageBaseProtocol {
    func linkageViewHeight() -> CGFloat?
    func linkageContentView()  -> UIView?
}
extension LinkageBaseProtocol {
    func linkageContentView()  -> UIView?  { return nil }
}



public protocol LinkageHeaderProtocol: LinkageBaseProtocol { }


public protocol LinkageSegmentProtocol: LinkageBaseProtocol {
    func linkageSegSelect(index: Int)
    var linkageSegSelectCallback: ((Int) -> Void)? { get set }
}





public typealias LinkageViewHeightChangedCallback = ((CGFloat) -> Void)

public protocol LinkageScrollViewProtocol: NSObjectProtocol {
    func linkageHeader() -> LinkageHeaderProtocol?
    func linkageSeg() -> LinkageSegmentProtocol?
    func linkagePinOffset() -> CGFloat
    func linkageBottomViews() -> [LinkageContentProtocol]?
    func linkageBottomHeight() -> CGFloat?
    var linkageBottomHeightChanged: LinkageViewHeightChangedCallback? { get set }
    var linkageSegmentHeightChanged: LinkageViewHeightChangedCallback? { get set }
    var linkageHeaderHeightChanged: LinkageViewHeightChangedCallback? { get set }
}

extension LinkageScrollViewProtocol {
    var linkageBottomHeightChanged: ((CGFloat) -> Void)? {
        set {}
        get { return nil }
    }
    var linkageHeaderHeightChanged: LinkageViewHeightChangedCallback? {
        set {}
        get { return nil }
    }
    var linkageSegmentHeightChanged: ((CGFloat) -> Void)? {
        set {}
        get { return nil }
    }
    func linkageSeg() -> LinkageSegmentProtocol? {
        return nil
    }
    func linkageBottomHeight() -> CGFloat? {
        return nil
    }
    func linkage_seg_contentView() -> UIView? {
        return nil
    }
}
