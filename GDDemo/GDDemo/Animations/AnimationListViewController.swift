//
//  AnimationListViewController.swift
//  GDDemo
//
//  Created by 龚丹丹 on 2019/5/20.
//  Copyright © 2019 GDD. All rights reserved.
//

import UIKit

class AnimationListViewController: BaseViewController {

    var datas:[String] = ["日历倒计时","UITableViewCell侧滑","collectionLayoutStyle1","collectionLayoutStyle2","collectionLayoutStyle3", "圆弧动画","其他"]
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

extension AnimationListViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = datas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc: BaseViewController = BaseViewController()
        switch indexPath.row {
        case 0:
            vc = DateCountViewController()
        case 1:
            vc = TableViewController()
        case 2:
            vc = CollectionLayoutStyle1VC(.linerStyle)
        case 3:
            vc = CollectionLayoutStyle1VC(.circle)
        case 4:
            vc = CollectionLayoutStyle1VC(.pinch)
        case 5:
            vc = CircleVC()
        default:
            ""
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

