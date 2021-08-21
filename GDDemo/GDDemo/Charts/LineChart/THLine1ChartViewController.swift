//
//  THLine1ChartViewController.swift
//  GDDemo
//
//  Created by GDD on 2019/3/14.
//  Copyright © 2019 GDD. All rights reserved.
//

import UIKit
import Charts

class THLine1ChartViewController: BaseChartViewController {

    private var datasOne:[ChartDataEntry] = []
    private var datasTwo:[ChartDataEntry] = []
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
            datasOne.insert(ChartDataEntry.init(x: nowTimeInterval-Double(i), y: (Double(arc4random()%100 + 200))), at: 0)
            datasTwo.insert(ChartDataEntry.init(x: nowTimeInterval-Double(i), y: (Double(arc4random()%100 + 100))), at: 0)
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
    
    
    private lazy var chartView:CombinedChartView = {
        let chartView = CombinedChartView()
        chartView.drawOrder = [DrawOrder.line.rawValue,
                               DrawOrder.bubble.rawValue,
                               DrawOrder.candle.rawValue]
        return chartView
    }()
    
}


extension THLine1ChartViewController {
    @objc func updatePoint(){
        datasOne.append(ChartDataEntry.init(x: Date().timeIntervalSince1970, y: (Double(arc4random()%100 + 200))))
        datasTwo.append(ChartDataEntry.init(x: Date().timeIntervalSince1970, y: (Double(arc4random()%100 + 100))))
        drawLineChartView()
        drawBubbleChartView()
        drawCandleChartView()
        self.perform(#selector(updatePoint), with: nil, afterDelay: 1)
    }
    
    private func drawLineChartView() {
        var dataSet1:LineChartDataSet = LineChartDataSet()
        if let data = self.chartView.combinedData?.lineData, data.dataSetCount > 0 {
            dataSet1 = data.dataSets.first as! LineChartDataSet
            dataSet1.replaceEntries(datasOne)

            data.notifyDataChanged()
            chartView.notifyDataSetChanged()
        }
    }
    private func drawCandleChartView() {
        var dataSet2:CandleChartDataSet = CandleChartDataSet()
        if let data = self.chartView.combinedData?.candleData, data.dataSetCount > 0 {
            dataSet2 = data.dataSets.first as! CandleChartDataSet
            dataSet2.append(CandleChartDataEntry.init(x: Date().timeIntervalSince1970, shadowH: 20, shadowL: (Double(arc4random()%100 + 100)), open: 15, close: 10))
            data.notifyDataChanged()
            chartView.notifyDataSetChanged()
        }
    }
    private func drawBubbleChartView() {
        var dataSet2:BubbleChartDataSet = BubbleChartDataSet()
        if let data = self.chartView.combinedData?.bubbleData, data.dataSetCount > 0 {
            dataSet2 = data.dataSets.first as! BubbleChartDataSet
            dataSet2.append(BubbleChartDataEntry.init(x: Date().timeIntervalSince1970, y: (Double(arc4random()%112 + 100)), size: CGFloat(arc4random_uniform(50) + 105)))
            data.notifyDataChanged()
            chartView.notifyDataSetChanged()
        }
    }
    fileprivate func initChartView() {
        let data:CombinedChartData = CombinedChartData()
        data.setDrawValues(false)
        data.lineData = lineData(datas: datasOne)
        data.bubbleData = bubbleChartData(datas: datasTwo)
        data.candleData = candleChartData(datas: datasTwo)
        chartView.data = data

    }
    
    fileprivate func lineData(datas:[ChartDataEntry]) -> LineChartData {
        let lineDataSet = LineChartDataSet.init(entries: datas, label: "")
        lineDataSet.mode = .cubicBezier
        lineDataSet.drawCirclesEnabled = false
        return LineChartData.init(dataSets: [lineDataSet])
    }
    
    fileprivate func bubbleChartData(datas:[ChartDataEntry]) -> BubbleChartData {
        let entries = datas.map { (item) -> BubbleChartDataEntry in
            return BubbleChartDataEntry.init(x: item.x, y: item.y, size: CGFloat(arc4random_uniform(50) + 105))
        }
        let bubbleDataSet = BubbleChartDataSet.init(entries: entries, label: "")
        bubbleDataSet.setColors(ChartColorTemplates.vordiplom(), alpha: 1)
        bubbleDataSet.valueTextColor = .white
        bubbleDataSet.valueFont = .systemFont(ofSize: 10)
        bubbleDataSet.drawValuesEnabled = true
        return BubbleChartData.init(dataSets: [bubbleDataSet])
    }
    
    fileprivate func candleChartData(datas:[ChartDataEntry]) -> CandleChartData {
        let entries = datas.map { (item) -> CandleChartDataEntry in
            return CandleChartDataEntry.init(x: item.x, shadowH: 20, shadowL: item.y, open: 15, close: 10)
        }
        let candleDataSet = CandleChartDataSet.init(entries: entries, label: "")
        candleDataSet.setColors(ChartColorTemplates.vordiplom(), alpha: 1)
        candleDataSet.valueTextColor = .white
        candleDataSet.valueFont = .systemFont(ofSize: 10)
        candleDataSet.drawValuesEnabled = true
        return CandleChartData.init(dataSets: [candleDataSet])
    }
}
