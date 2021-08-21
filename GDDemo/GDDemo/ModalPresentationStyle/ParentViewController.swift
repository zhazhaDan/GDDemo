//
//  ParentViewController.swift
//  GDDemo
//
//  Created by GDD on 2020/1/7.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit

class ParentViewController: BaseViewController {

    var datas:[String] = ["fullScreen", "overFullScreen", "formSheet", "其他", "关闭"]
        override func viewDidLoad() {
            super.viewDidLoad()
            let tableview = UITableView.init(frame: self.view.bounds, style: UITableView.Style.plain)
            tableview.delegate = self
            tableview.dataSource = self
            tableview.backgroundColor = UIColor.white
            tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            self.view.addSubview(tableview)
    }
}

extension ParentViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = datas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc: BaseViewController?
        switch datas[indexPath.row] {
        case "fullScreen":
             vc = ParentViewController()
             vc!.modalPresentationStyle = .fullScreen
        case "overFullScreen":
             vc = ParentViewController()
             vc!.modalPresentationStyle = .overFullScreen
        case "formSheet":
             vc = ParentViewController()
             vc!.modalPresentationStyle = .formSheet
        case "关闭":
            self.dismiss(animated: true, completion: nil)
        default:
            ""
        }
        if let vc = vc {
            self.present(vc, animated: true, completion: nil)
        }

    }
}
