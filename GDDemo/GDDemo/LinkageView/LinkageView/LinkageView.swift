//
//  LinkageView.swift
//  GDDemo
//
//  Created by GDD on 2020/10/30.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit

public class LinkageView: UIView {
    public weak var dataSource: LinkageScrollViewProtocol?
    private var scrollV = LinkageScrollView()
    private var headerProtocol: LinkageHeaderProtocol?
    private var segProtocol: LinkageSegmentProtocol?
    private var headerView: UIView?
    private var segView: UIView?
    private var bottomLinkageV = LinkageContainerView()
    private var scrollContainV = UIView()
    private var pinTopOffsetY: CGFloat = 200
    private func bindView() {
        scrollV.delegate = self
        scrollV.frame = self.frame
        scrollV.showsVerticalScrollIndicator = false
        scrollV.showsHorizontalScrollIndicator = false
        self.addSubview(scrollV)
        scrollV.addSubview(scrollContainV)

        self.headerProtocol = self.dataSource?.linkageHeader()
        if let v = self.headerProtocol?.linkageContentView() {
            headerView = v
        } else if let v = self.headerProtocol as? UIView {
            headerView = v
        }
        if let view = self.headerView {
            scrollContainV.addSubview(view)
        }


        self.segProtocol = self.dataSource?.linkageSeg()
        if let v = self.segProtocol?.linkageContentView() {
            segView = v
        } else if let v = self.segProtocol as? UIView {
            segView = v
        }
        if let view = self.segView {
            scrollContainV.addSubview(view)
        }

        bottomLinkageV.delegate = self
        bottomLinkageV.dataSource = self
        bottomLinkageV.backgroundColor = .red
        scrollContainV.addSubview(bottomLinkageV)
        bottomLinkageV.reloadData()
    }

    private func bindLayout() {
        scrollV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        scrollContainV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(self)
        }

        bottomLinkageV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(scrollContainV.snp.top)
            make.height.equalTo(self).offset(-(self.dataSource?.linkagePinOffset() ?? 0))
            make.bottom.equalToSuperview()
        }

        var topView: UIView?

        if let view = self.headerView, let height = self.headerProtocol?.linkageViewHeight() {
            view.snp.makeConstraints { (make) in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(height)
            }
            topView = view
            bottomLinkageV.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(view.snp.bottom)
                make.height.equalTo(self).offset(-(self.dataSource?.linkagePinOffset() ?? 0))
                make.bottom.equalToSuperview()
            }
        }

        if let view = self.segView, let height = self.segProtocol?.linkageViewHeight() {
            view.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                if let top = topView {
                    make.top.equalTo(top.snp.bottom)
                } else {
                    make.top.equalToSuperview()
                }
                make.height.equalTo(height)
            }
            topView = view
            bottomLinkageV.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(view.snp.bottom)
                make.height.equalTo(self).offset(-(self.dataSource?.linkagePinOffset() ?? 0))
                make.bottom.equalToSuperview()
            }
        }

        if let height = self.dataSource?.linkageBottomHeight(), height > 0 {
            bottomLinkageV.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                if let top = topView {
                    make.top.equalTo(top.snp.bottom)
                } else {
                    make.top.equalToSuperview()
                }
                make.height.equalTo(height)
                make.bottom.equalToSuperview()
            }
        }
    }

    private func bindAction() {
        self.segProtocol?.linkageSegSelectCallback = {
            [weak self] index in
            guard let self = self else { return }
            self.bottomLinkageV.currentIndex = index
        }

        self.dataSource?.linkageSegmentHeightChanged = {
            [weak self] height in
            guard let self = self else { return }
            guard let v = self.segView else { return }
            v.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
            UIView.animate(withDuration: 0.25) {
                [weak self] in
                guard let self = self else { return }
                self.layoutIfNeeded()
            }
        }

        self.dataSource?.linkageHeaderHeightChanged = {
            [weak self] height in
            guard let self = self else { return }
            guard let v = self.headerView else { return }
            v.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
            UIView.animate(withDuration: 0.25) {
                [weak self] in
                guard let self = self else { return }
                self.layoutIfNeeded()
            }
        }

        self.dataSource?.linkageBottomHeightChanged = {
            [weak self] height in
            guard let self = self else { return }
            let snp = self.bottomLinkageV.snp.top
            self.bottomLinkageV.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(snp)
                make.height.equalTo(height)
                make.bottom.equalToSuperview()
            }
            UIView.animate(withDuration: 0.25) {
                [weak self] in
                guard let self = self else { return }
                self.layoutIfNeeded()
            }
        }

    }


    public convenience init?(dataSource: LinkageScrollViewProtocol) {
        self.init(frame: CGRect.zero)
        self.dataSource = dataSource
        bindView()
        bindLayout()
        bindAction()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension LinkageView: LinkageContainerViewDelegate, LinkageContainerViewDataSource {

    public func linkage_pinTopOffsetY() -> CGFloat {
        return self.dataSource?.linkagePinOffset() ?? 0
    }
    public func linkage_numberOfPages() -> Int {
        return self.dataSource?.linkageBottomViews()?.count ?? 0
    }

    public func linkage_view(container: UIView, at index: Int) -> LinkageContentProtocol? {
        return self.dataSource?.linkageBottomViews()?[index]
    }

    public func linkage_viewDidChanged(container: UIView, at index: Int) {
        self.segProtocol?.linkageSegSelect(index: index)
    }

    public func linkage_scrollViewDidScroll(scrollView: UIScrollView) {

    }

}

extension LinkageView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        bottomLinkageV.linkage_superScrollViewDidScroll(scrollView: scrollView)
    }
}



