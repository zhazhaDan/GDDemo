//
//  BaseViewController.swift
//  GDDemo
//
//  Created by GDD on 2019/3/14.
//  Copyright © 2019 GDD. All rights reserved.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        bindData()
        bindView()
    }
    
    func bindData() {}
    func bindView() {}

}
