//
//  GDSlderCellProxy.swift
//  GDDemo
//
//  Created by GDD on 2020-07-07.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit

class GDSliderCellProxy: NSProxy {
    open weak var target: UITableView? {
        didSet {
            target?.sliderCellProxy = self
            self.tableDelegate = target?.delegate
//            self.tableDataSource = target?.dataSource
            target?.delegate = self
        }
    }
    private var isSlip: Bool = false
    private weak var tableDelegate: UITableViewDelegate?
//    private weak var tableDataSource: UITableViewDataSource?
    
    
}

extension GDSliderCellProxy: UITableViewDelegate {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if self.tableDataSource?.responds(to: #selector(numberOfSections(in:))) ?? false {
//            return self.tableDataSource?.numberOfSections?(in: tableView) ?? 0
//        }
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.tableDataSource?.responds(to: #selector(tableView(_:numberOfRowsInSection:))) ?? false {
//            return self.tableDataSource?.tableView(tableView, numberOfRowsInSection: section) ?? 0
//        }
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if self.tableDataSource?.responds(to: #selector(tableView(_:cellForRowAt:))) ?? false {
//            return self.tableDataSource?.tableView(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
//        }
//        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if self.tableDelegate?.responds(to: #selector(tableView(_:heightForRowAt:))) ?? false {
//            return self.tableDelegate?.tableView?(tableView, heightForRowAt: indexPath) ?? 0
//        }
//        return 0
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.target?.isSlip ?? false {
            guard let ret = self.target?.hideAllSliderCells(), ret else { return }
            
        }
        if self.tableDelegate?.responds(to: #selector(tableView(_:didSelectRowAt:))) ?? false {
            self.tableDelegate?.tableView?(tableView, didSelectRowAt: indexPath)
        }
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        return self.target?.responds(to: aSelector) ?? false  ||
            self.tableDelegate?.responds(to: aSelector) ?? false
    }
    
    override func isKind(of aClass: AnyClass) -> Bool {
        return NSStringFromClass(aClass) == "GDSliderCellProxy"
    }
    
   
    
}
