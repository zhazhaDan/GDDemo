//
//  TableViewController.swift
//  GDDemo
//
//  Created by GDD on 2020-07-07.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit

class TableViewController: BaseViewController {
    var datas:[String] = ["1","2","3"]

    override func viewDidLoad() {
        super.viewDidLoad()

        let tableview = UITableView.init(frame: self.view.bounds, style: UITableView.Style.plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = UIColor.white
        tableview.register(GDTableViewSliderCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableview)
    }
    
}

extension TableViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = datas[indexPath.row]
        if let cell = cell as? GDTableViewSliderCell {
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var vc: BaseViewController = BaseViewController()
        switch indexPath.row {
        case 0:
            vc = DateCountViewController()
        case 1:
            vc = TableViewController()
        default:
            ""
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


extension TableViewController: GDTableViewProtocol {
    func sliderCell(cell: GDTableViewSliderCell, canSlipAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func sliderCell(cell: GDTableViewSliderCell, editActionsAt indexPath: IndexPath) -> [GDTableViewRowAction]? {
            let delete = GDTableViewRowAction.init(title:  "删除", image: UIImage.init(named: "shanchu")) { (action, index, complete) in
                 print("点击了删除")
                complete(true)
            }
            delete.backgroundColor = UIColor.red
            let top = GDTableViewRowAction.init(title: "置顶", image: UIImage.init(named: "zhiding")) { (action, index, complete) in
                print("点击了置顶")
                complete(true)

            }
            top.backgroundColor = UIColor.brown
            return [top,delete]
    }
    
    
}
