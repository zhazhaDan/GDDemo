//
//  WebListVC.swift
//  GDDemo
//
//  Created by GDD on 2020/12/2.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit

class WebListVC: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.datas = [
            .nativeJS,
            .WebViewJavascriptBridge,
            .JavaScriptCore,
            .CustomJS]
        self.tableview.reloadData()
        // Do any additional setup after loading the view.
    }
    

   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc: BaseViewController = BaseViewController()
        switch datas[indexPath.row] {
        case .JavaScriptCore:
             vc = JSCoreVC()
        case .nativeJS:
            vc = WebViewController()
        case .WebViewJavascriptBridge:
            vc = JSBridgeVC()
        case .CustomJS:
            vc = CustomJSbridgeVC()
        default:
            break
        }
        self.navigationController?.pushViewController(vc, animated: true)

    }

}
