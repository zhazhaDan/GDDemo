//
//  LinkageContainerView.swift
//  GDDemo
//
//  Created by GDD on 2020/10/28.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit


public protocol TypeWrapperProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}


public protocol LinkageContainerViewDataSource: NSObjectProtocol {
    func linkage_pinTopOffsetY() -> CGFloat
    func linkage_numberOfPages() -> Int
    func linkage_view(container: UIView, at index: Int) -> LinkageContentProtocol?
}

public protocol LinkageContainerViewDelegate: NSObjectProtocol {

    func linkage_viewDidChanged(container: UIView, at index: Int)
    func linkage_scrollViewDidScroll(scrollView: UIScrollView)
}

public class LinkageContainerView: UIView {
    weak var delegate: LinkageContainerViewDelegate?
    weak var dataSource: LinkageContainerViewDataSource?

    private var current: Int = 0
    private var _contentCache: [Int: LinkageContentProtocol] = [:]
    private var _superScrollViewArriveBottom: Bool = false

    private let contentCellReuseId = "contentCellReuseId"

    private lazy var collectV: LinkageCollectionView = {
        let v = LinkageCollectionView.init(frame: self.bounds, collectionViewLayout: collectLayout)
        v.register(LinkageCollectionViewCell.self, forCellWithReuseIdentifier: contentCellReuseId)
        v.backgroundColor = .white
        v.isPagingEnabled = true
        v.delegate = self
        v.dataSource = self
        v.showsHorizontalScrollIndicator = false
        return v
    }()

    private lazy var collectLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()

    func bindView() {
        addSubview(collectV)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        bindView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        collectV.frame = self.bounds
        collectLayout.itemSize = self.size
    }

}
// public api
extension LinkageContainerView {
    func reloadData() {
        collectV.reloadData()
    }

    func linkage_superScrollViewDidScroll(scrollView: UIScrollView) {
        self.inner_linkage_superScrollViewDidScroll(scrollView: scrollView)
    }


    var currentIndex: Int {
        set {
            current = newValue
            self.collectV.scrollToItem(at: IndexPath.init(row: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
        get {
            return current
        }
    }


}

// private api
extension LinkageContainerView {
    private func contentPage(at index: Int) -> LinkageContentProtocol {
        var result: LinkageContentProtocol!
        if let content = _contentCache[index] {
            result = content
        } else {
            result = self.dataSource?.linkage_view(container: self, at: index)
            _contentCache[index] = result
            result.linkage_scrollViewDidScroll = {
                [weak self] scrollView in
                guard let self = self else { return }
                self.contentScrollViewDidScroll(scrollView: scrollView, at: index)
            }

        }
        return result
    }

    private func contentScrollViewDidScroll(scrollView: UIScrollView, at index: Int) {
        scrollView.arriveTop = scrollView.contentOffset.y <= 0
        if !_superScrollViewArriveBottom {
            scrollView.contentOffset.y = 0
        }
    }

    private func inner_linkage_superScrollViewDidScroll(scrollView: UIScrollView) {
        let pinToOffsetY: CGFloat = self.dataSource?.linkage_pinTopOffsetY() ?? 0
        if let contentScrollView = self.contentPage(at: self.current).linkage_contentScrollView as? UIScrollView,
           !contentScrollView.arriveTop
        || scrollView.contentOffset.y > pinToOffsetY {
            scrollView.contentOffset.y = pinToOffsetY
        }
        let oldBottom = _superScrollViewArriveBottom
        _superScrollViewArriveBottom = scrollView.contentOffset.y > pinToOffsetY - 0.5
        if oldBottom != _superScrollViewArriveBottom && !_superScrollViewArriveBottom {
            _contentCache.forEach { (key, value) in
                if let scroll = value.linkage_contentScrollView as? UIScrollView, !scroll.arriveTop {
                    scroll.contentOffset.y = 0
                }
            }
        }
    }

}

extension LinkageContainerView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.linkage_numberOfPages() ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellReuseId, for: indexPath)
        if let cell = cell as? LinkageCollectionViewCell,
           let linkView = self.dataSource?.linkage_view(container: self, at: indexPath.row) {
           let view = linkView.linkage_contentView
            cell.conainerView = view
            view.frame = cell.bounds
            cell.contentView.addSubview(view)
        }
        return cell
    }

    private func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? LinkageCollectionViewCell,
           let linkView = self.dataSource?.linkage_view(container: self, at: indexPath.row){
           let view = linkView.linkage_contentView
            if cell.conainerView == view {
                linkView.linkage_contentWillAppear()
            }
        }
    }

    private func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? LinkageCollectionViewCell,
           let linkView = self.dataSource?.linkage_view(container: self, at: indexPath.row) {
           let view = linkView.linkage_contentView
            if cell.conainerView == view {
                linkView.linkage_contentDidDisappear()
            }
        }
    }
}

extension LinkageContainerView: UIScrollViewDelegate {
    private func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let view = scrollView as? LinkageScrollView {
            view.arriveTop = scrollView.contentOffset.y <= 0
        }
        if !scrollView.isDecelerating && !scrollView.isDragging {
            return
        }
        let pageOff: CGFloat = scrollView.contentOffset.x / scrollView.frame.width
        let index = Int(pageOff + 0.5)
        if index != current {
            current = index
            self.delegate?.linkage_viewDidChanged(container: self, at: current)
        }

    }
}

class LinkageCollectionView: UICollectionView {
}


class LinkageCollectionViewCell: UICollectionViewCell {
    var conainerView: UIView?
}
