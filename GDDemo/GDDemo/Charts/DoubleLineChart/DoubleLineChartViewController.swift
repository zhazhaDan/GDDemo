//
//  DoubleLineChartViewController.swift
//  GDDemo
//
//  Created by GDD on 2019/5/27.
//  Copyright © 2019 GDD. All rights reserved.
//

import UIKit

class DoubleLineChartViewController: BaseChartViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let chart = THVipAssetChartView()
        self.view.addSubview(chart)
        chart.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize.init(width: self.view.width - 17, height: 250))
        })
        chart.update(datas: [])
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
