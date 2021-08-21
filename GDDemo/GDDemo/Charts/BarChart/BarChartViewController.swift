//
//  BarChartViewController.swift
//  GDDemo
//
//  Created by GDD on 2019/3/14.
//  Copyright © 2019 GDD. All rights reserved.
//

import UIKit
import Charts

class BarChartViewController: BaseChartViewController {

    
    private var datasOne:[BarChartDataEntry] = []
    private var datasTwo:[BarChartDataEntry] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "曲线图"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.perform(#selector(updatePoint), with: nil, afterDelay: 1)
    }
    
    override func bindData() {
        let nowTimeInterval = Date().timeIntervalSince1970
        for i in 0 ..< 60 {
            let value = arc4random()%2000
            if value < 1000 {
                datasTwo.insert(BarChartDataEntry.init(x: nowTimeInterval-Double(i), y: Double(value)), at: 0)
            }else {
                datasOne.insert(BarChartDataEntry.init(x: nowTimeInterval-Double(i), y: Double(value)), at: 0)
            }
        }
        initChartView()
    }
    
    override func bindView() {
        self.view.addSubview(chartView)
        updateLayout()
    }
    
    private func updateLayout() {
        chartView.snp.makeConstraints({
            $0.left.right.equalTo(0)
            $0.top.equalTo(100)
            $0.height.equalTo(250)
        })
    }
    
    
    fileprivate func initChartView() {
        let dataset1 = BarChartDataSet.init(entries: datasOne, label: "涨")
        dataset1.setColor(UIColor.red)
        let dataset2 = BarChartDataSet.init(entries: datasTwo, label: "跌")
        dataset2.setColor(UIColor.green)
        let data:BarChartData = BarChartData.init(dataSets: [dataset1,dataset2])
        data.setDrawValues(false)
//        data.groupBars(fromX: (datasOne.first?.x)!, groupSpace: 0, barSpace: 1)
//        data.barWidth = 2
        chartView.data = data
    }
    
    
    @objc func updatePoint(){
        drawLineChartView()
        self.perform(#selector(updatePoint), with: nil, afterDelay: 1)
    }
    
    private func drawLineChartView() {
        let nowTimeInterval = Date().timeIntervalSince1970

        var dataSet1:BarChartDataSet = BarChartDataSet()
        var dataSet2:BarChartDataSet = BarChartDataSet()
        if let data = self.chartView.data, data.dataSetCount > 0 {
            dataSet1 = data.dataSets.first as! BarChartDataSet
            dataSet2 = data.dataSets.last as! BarChartDataSet
            let value = arc4random()%2000
            if value < 1000 {
                dataSet2.append(BarChartDataEntry.init(x: nowTimeInterval, y: Double(value)))
            }else {
                dataSet1.append(BarChartDataEntry.init(x: nowTimeInterval, y: Double(value)))
            }
            data.notifyDataChanged()
            chartView.notifyDataSetChanged()
        }
    }
    
    
    
    
    private lazy var chartView:BarChartView = {
        let chartView = BarChartView()
        chartView.fitBars = true
        return chartView
    }()
}
