//
//  DownloaderViewController.swift
//  GDDemo
//
//  Created by GDD on 2020-07-03.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit

class DownloaderViewController: BaseViewController {

    private var fileManager = FileDownloadManager()
    private var textField = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.placeholder = "请输入要下载的地址"
        textField.text = "https://image001.artproglobal.com/user_avatar/9b/11/9b1105a5baf40ce0dca19c626e552ff7.pdf"
//        textField.text = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1593884399638&di=f7134514c8c98418ebc0a7b9cd662b76&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F2017-12-01%2F5a2141c1bc62e.jpg"
        self.view.addSubview(textField)
        
        let button = UIButton()
        button.setTitle("下载", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
        self.view.addSubview(button)
        
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.height.equalTo(50)
            make.top.equalTo(self.view).offset(100)
        }
        
        button.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(textField)
            make.top.equalTo(textField.snp_bottom).offset(50)
        }
        
    }
    
    @objc func downloadAction() {
        if let text = textField.text, text.count > 0 {
            let file = self.fileManager.loadFile(url: text, fileID: 0)
            file.progress = {[weak self](write, total, url)in
                guard let self = self else {return}
                let progress = 1.0 * Double(write) / Double(total)

                print("progress is \(progress) url is \(url.absoluteString)")

            }
            
            file.complete = {[weak self](path, error, succ)in
                guard let self = self else {return}
                print("complete is success \(succ) error is \(error.debugDescription), file path \(path)")
            }
            
        } else {
            print("无效地址")
        }
    }
    
    

}
