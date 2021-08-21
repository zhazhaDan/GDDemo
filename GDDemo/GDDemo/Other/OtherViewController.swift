//
//  OtherViewController.swift
//  GDDemo
//
//  Created by GDD on 2021/8/8.
//  Copyright © 2021 GDD. All rights reserved.
//

import UIKit

class OtherViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(label)
        self.view.addSubview(textLabel)
        label.width = 300
        label.sizeToFit()
        label.center = self.view.center
        textLabel.width = 300
        textLabel.sizeToFit()
        textLabel.center = self.view.center
        textLabel.top = label.bottom + 50
    }
    @objc func test() {

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        label.shine()

//        let proxy = GDProxy.init(target: self, sel: #selector(test))
//        let time = Timer.scheduledTimer(timeInterval: 1, target: proxy, selector: #selector(test), userInfo: nil, repeats: true)
//        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(test), userInfo: nil, repeats: true)
//        timer
//
//        let timer = Timer.init(timeInterval: 1, target: self, selector: #selector(test), userInfo: nil, repeats: true)
//        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
//        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in

//        }
        let vc = OCTestViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private lazy var label: ShineLabel = {
        let v = ShineLabel()
        v.textColor = .black
        let text = "you are so beatiful today, and i want to play boll with you, will you join us?"
        v.attributedText = NSAttributedString.init(string: text)
        v.numberOfLines = 0
        return v
    }()

    private lazy var textLabel: UILabel = {
        let v = UILabel()
        v.textColor = .yellow
        let text = "you are so beatiful today, and i want to play boll with you, will you join us?"
        v.attributedText = NSAttributedString.init(string: text)
        v.numberOfLines = 0
        return v
    }()
}
