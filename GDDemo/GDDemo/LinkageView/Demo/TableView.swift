//
//  TableView.swift
//  GDDemo
//
//  Created by GDD on 2020/10/28.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit

class DemoTableView: UIView, LinkageContentProtocol {


    var index: Int = 0


    var linkage_scrollViewDidScroll: ((UIScrollView) -> Void)?

    var linkage_contentView: UIView  {
        return self
    }

    var linkage_contentScrollView: UIView {
        return self.table
    }

    func linkage_contentWillAppear() {
        print("linkage_contentWillAppear == \(index)")
    }

    func linkage_contentDidDisappear() {
        print("linkage_contentDidDisappear == \(index)")
    }


    private var table = UITableView.init(frame: CGRect.zero, style: .plain)

    override var backgroundColor: UIColor? {
        didSet {
            table.backgroundColor = backgroundColor
        }
    }

    func bindView() {
        table.delegate = self
        table.dataSource = self
        table.contentInsetAdjustmentBehavior = .never
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(table)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        bindView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        table.frame = self.frame
    }
}

extension DemoTableView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "第\(indexPath.row)行"
        return cell!
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.linkage_scrollViewDidScroll?(scrollView)
    }
}
