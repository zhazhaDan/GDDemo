//
//  LinkageViewController.swift
//  GDDemo
//
//  Created by GONGDANDAN on 2020/7/22.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit
import SnapKit

class LinkageViewController: BaseViewController {
    private var linkV: LinkageView!
//    private var scrollV = LinkageScrollView()
    private var headerV = HeaderView()
    private var segV = SegmentView.init(frame: CGRect.zero)
    private var bottomLinkageV = LinkageContainerView()
    private var table1 = DemoTableView()
    private var table2 = DemoTableView()
    private var table3 = DemoTableView()
    private var pinOffsetY: CGFloat = 300
    override func bindView() {
        super.bindView()
        linkV = LinkageView.init(dataSource: self)
        self.view.addSubview(linkV)
        headerV.backgroundColor = .white
        segV.backgroundColor = .orange
        table1.index = 1
        table2.index = 2
        table3.index = 3
        linkV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.headerV.viewHeightChanged = {
            [weak self] height in
            guard let self = self else { return }
            self.linkageHeaderHeightChanged?(height)
            self.pinOffsetY = height - 100
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    var linkageHeaderHeightChanged: LinkageViewHeightChangedCallback?

}

extension LinkageViewController: LinkageScrollViewProtocol {
    func linkageBottomHeight() -> CGFloat? {
        return self.view.frame.height - 168
    }

    func linkageHeader() -> LinkageHeaderProtocol? {
        return self.headerV
    }

    func linkageSeg() -> LinkageSegmentProtocol? {
        return self.segV
    }

    func linkagePinOffset() -> CGFloat {
        return pinOffsetY
    }

    func linkageBottomViews() -> [LinkageContentProtocol]? {
        return [table1, table2, table3]
    }
}


class HeaderView: UIView, LinkageHeaderProtocol {

    override init(frame: CGRect) {
        super.init(frame: frame)
        bindView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func bindView() {
        let seg = UISegmentedControl.init(items: ["展开", "收起"])
        self.addSubview(seg)

        seg.addTarget(self, action: #selector(segValueChange(_:)), for: .valueChanged)
        seg.selectedSegmentIndex = 0
        seg.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(40)
        }

    }

    @objc private func segValueChange(_ sender: UISegmentedControl) {

        self.viewHeightChanged?(sender.selectedSegmentIndex == 0 ? 400 : 300)
    }


    func linkageViewHeight() -> CGFloat? {
        return 400
    }

    var viewHeightChanged: LinkageViewHeightChangedCallback?
}

class SegmentView: UIView, LinkageSegmentProtocol {

    var seg = UISegmentedControl.init(items: ["tab1", "tab2", "tab3"])

    override init(frame: CGRect) {
        super.init(frame: frame)
        bindView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func bindView() {
        self.addSubview(seg)
        seg.addTarget(self, action: #selector(segValueChange), for: .valueChanged)
        seg.selectedSegmentIndex = 0
        seg.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(40)
        }
    }

    @objc private func segValueChange() {
        self.linkageSegSelectCallback?(seg.selectedSegmentIndex)
    }

    func linkageViewHeight() -> CGFloat? {
        return 80
    }

    func linkageSegSelect(index: Int) {
        seg.selectedSegmentIndex = index
    }

    var linkageSegSelectCallback: ((Int) -> Void)?
}

