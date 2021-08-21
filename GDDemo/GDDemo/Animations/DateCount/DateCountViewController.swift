//
//  DateCountViewController.swift
//  GDDemo
//
//  Created by 龚丹丹 on 2019/5/20.
//  Copyright © 2019 GDD. All rights reserved.
//

import UIKit

class DateCountViewController: BaseViewController {

    private var countDownLabel: DateCountLabel = DateCountLabel()
    private var count: Int = 100
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.update()
    }
    
    @objc func update() {
        self.count -= 1
        self.countDownLabel.text = "\(count)"
        self.perform(#selector(update), with: nil, afterDelay: 1)
    }
    
    func setupUI() {
        countDownLabel.textColor = UIColor.black
        countDownLabel.backgroundColor = UIColor.red
        countDownLabel.textAlignment = .center
        countDownLabel.frame = CGRect.init(origin: self.view.center, size: CGSize.init(width: 200, height: 50))
        countDownLabel.center = self.view.center
        self.view.addSubview(countDownLabel)
    }
}
