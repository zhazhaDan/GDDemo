//
//  ViewController.swift
//  GDDemo
//
//  Created by GDD on 2019/3/14.
//  Copyright © 2019 GDD. All rights reserved.
//

import UIKit
enum VCListKey: String {
    case 曲线图,
         动画,
         ModalPresentationStyle,
         IM语音功能,
         AVPlayer,
         下载器,
         联动UI,
         PropertyWrapper,
         JS交互,
         nativeJS,
         JavaScriptCore,
         WebViewJavascriptBridge,
         CustomJS,
         PanController,
         Socket,
         其他
}


class ViewController: BaseViewController {

    var tableview: UITableView!
    var datas:[VCListKey] = [.曲线图, .动画, .ModalPresentationStyle, .IM语音功能, .下载器, .联动UI, .PropertyWrapper, .JS交互, .AVPlayer, .PanController, .Socket, .其他]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview = UITableView.init(frame: self.view.bounds, style: UITableView.Style.plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = UIColor.white
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableview)
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = datas[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc: UIViewController?
        switch datas[indexPath.row] {
        case .曲线图:
             vc = ChartsListViewController()
        case .动画:
             vc = AnimationListViewController()
        case .ModalPresentationStyle:
             vc = ParentViewController()
        case .IM语音功能:
            vc = AudioViewController()
        case .下载器:
            vc = DownloaderViewController()
        case .联动UI:
            vc = LinkageViewController()
        case .PropertyWrapper:
            vc = PropertyWrapperVC()
        case .JS交互:
            vc = WebListVC()
        case .AVPlayer:
            vc = VideoVC()
        case .PanController:
            vc = CustomPanViewController()
        case .Socket:
            vc = SocketViewController()
        case .其他:
        vc = OtherViewController()
        default:
            break
        }
        if let vc = vc {
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
}

