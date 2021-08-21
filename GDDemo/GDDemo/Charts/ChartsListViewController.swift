//
//  ChartsListViewController.swift
//  GDDemo
//
//  Created by GDD on 2019/3/14.
//  Copyright © 2019 GDD. All rights reserved.
//

import UIKit

class ChartsListViewController: BaseViewController {

    var datas:[String] = ["CombinedChartData","BarChartData","分时图","日线图","双曲线","其他"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tableview = UITableView.init(frame: self.view.bounds, style: UITableView.Style.plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableview)
    }
}

extension ChartsListViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = datas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = THLine1ChartViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = BarChartViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = THBothTimeDivisionChartViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = THBothDayLineViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = DoubleLineChartViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            ""
        }
    }
}
