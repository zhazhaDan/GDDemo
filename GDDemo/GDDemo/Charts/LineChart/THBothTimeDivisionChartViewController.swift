//
//  THBothTimeDivisionChartViewController.swift
//  GDDemo
//
//  Created by 龚丹丹 on 2019/3/17.
//  Copyright © 2019 GDD. All rights reserved.
//

import UIKit
import Charts

class THBothTimeDivisionChartViewController: BaseViewController {

    public var datas:[DataModel] = []

    private var highLightView:THChartHighLightView = THChartHighLightView()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updatePoint()
    }
    
    @objc private func updatePoint() {
        let nowTimeInterval = Date().timeIntervalSince1970
        let point = DataModel.init(time: Int64(nowTimeInterval) , price: Double(arc4random()%1000 + 1000), turnOver: Int64(arc4random()%100 + 200), isStep: (Int64(nowTimeInterval) - (datas.first?.time)!)%60 == 0 ? true : false)
        if point.isStep {
            datas.append(point)
        }else {
            datas[datas.count - 1] = point
        }
        updateChartData()
        self.perform(#selector(updatePoint), with: nil, afterDelay: 1)
    }
    
    
    override func bindData() {
        let nowTimeInterval = Date().timeIntervalSince1970
        for i in 0 ..< 60 {
            let point = DataModel.init(time: Int64(nowTimeInterval) - Int64(i*60) , price: Double(arc4random()%1000 + 1000), turnOver: Int64(arc4random()%100 + 200), isStep: true)
            datas.insert(point, at: 0)
        }
        initChartView()
    }
    
    
    override func bindView() {
        self.view.backgroundColor = UIColor.hex(0x191A2F)
        self.view.addSubview(topChartView)
        self.view.addSubview(bottomChartView)
        self.view.addSubview(highLightView)
        topChartView.snp.makeConstraints({
            $0.size.equalTo(CGSize.init(width: self.view.width, height: 253))
            $0.top.equalTo(218)
        })
        bottomChartView.snp.makeConstraints({
            $0.size.equalTo(CGSize.init(width: self.view.width, height: 105))
            $0.top.equalTo(topChartView.snp.bottom)
        })
        
        highLightView.snp.makeConstraints({
            $0.left.right.equalToSuperview()
            $0.top.equalTo(topChartView)
            $0.bottom.equalTo(bottomChartView)
        })
        highLightView.isUserInteractionEnabled = false
        customLineChartView()
        customBarChartView()
    }
    

    public lazy var topChartView:LineChartView! = {
        var chartView:LineChartView = LineChartView()
        chartView.dragEnabled = true
        chartView.doubleTapToZoomEnabled = false
        chartView.highlightPerTapEnabled = true
        chartView.legend.form = .none
        chartView.minOffset = 0
        chartView.delegate = self
        return chartView
    }()
    public var bottomChartView:BarChartView! = {
        var chartView:BarChartView = BarChartView()
        chartView.dragXEnabled = false
        chartView.dragYEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.highlightPerTapEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.legend.form = .none
        chartView.minOffset = 0
        return chartView
    }()

}

extension THBothTimeDivisionChartViewController {
    fileprivate func initChartView() {
        let lineDataSet = LineChartDataSet.init(entries: lineDatas(), label: "")
        lineDataSet.setColor(UIColor.hex(0x696Fd8))
        lineDataSet.lineWidth = 1
        
        let gradientColors = [ChartColorTemplates.colorFromString("#00696Fd8").cgColor,
                              ChartColorTemplates.colorFromString("#89696Fd8").cgColor]
        let gradient = CGGradient.init(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)
        lineDataSet.fillAlpha = 1
        lineDataSet.fill = Fill.init(linearGradient: gradient!, angle: 90)
        lineDataSet.drawFilledEnabled = true
        lineDataSet.drawCirclesEnabled = false
        lineDataSet.drawIconsEnabled = true
        lineDataSet.highlightEnabled = true
        lineDataSet.highlightColor = UIColor.clear
        lineDataSet.mode = .cubicBezier
        let lineData:LineChartData = LineChartData.init(dataSets: [lineDataSet])
        lineData.setDrawValues(false)
        topChartView.data = lineData
        
        let barDataSet = BarChartDataSet.init(entries: barDatas(), label: "")
        barDataSet.setColor(UIColor.hex(0x696Fd8))
        barDataSet.highlightEnabled = false
        let barData:BarChartData = BarChartData.init(dataSets: [barDataSet])
        barData.setDrawValues(false)
        barData.barWidth = 48
        bottomChartView.data = barData
    }
    
    
    fileprivate func customLineChartView() {
        self.topChartView.xAxis.drawLabelsEnabled = false
        self.topChartView.leftAxis.drawLabelsEnabled = false
        self.topChartView.leftAxis.drawAxisLineEnabled = false
        self.topChartView.leftAxis.drawGridLinesEnabled = false
        self.topChartView.rightAxis.valueFormatter = self
        self.topChartView.rightAxis.setLabelCount(5, force: true)
        self.topChartView.rightAxis.maxWidth = self.view.width / 5
        self.topChartView.rightAxis.minWidth = self.view.width / 5
        self.topChartView.rightAxis.yOffset = 6
        self.topChartView.rightAxis.labelTextColor = UIColor.white
        self.topChartView.rightAxis.drawAxisLineEnabled = false
        self.topChartView.rightAxis.drawGridLinesEnabled = false
        self.topChartView.rightAxis.drawLabelsEnabled = true
        self.topChartView.xAxis.drawGridLinesEnabled = false
        self.topChartView.xAxis.drawAxisLineEnabled = false
        self.bottomChartView.xAxis.avoidFirstLastClippingEnabled = true
    }
    
    
    fileprivate func customBarChartView() {
        self.bottomChartView.leftAxis.drawLabelsEnabled = false
        self.bottomChartView.leftAxis.drawAxisLineEnabled = false
        self.bottomChartView.leftAxis.drawGridLinesEnabled = false
        self.bottomChartView.rightAxis.drawLabelsEnabled = true
        self.bottomChartView.rightAxis.setLabelCount(1, force: true)
        self.bottomChartView.rightAxis.valueFormatter = self
        self.bottomChartView.rightAxis.drawAxisLineEnabled = false
        self.bottomChartView.rightAxis.drawGridLinesEnabled = false
        self.bottomChartView.rightAxis.drawBottomYLabelEntryEnabled = false
        self.bottomChartView.rightAxis.yOffset = 6
        self.bottomChartView.rightAxis.labelTextColor = UIColor.white
        self.bottomChartView.xAxis.labelPosition = .bottom
        self.bottomChartView.xAxis.valueFormatter = self
        self.bottomChartView.xAxis.setLabelCount(4, force: true)
        self.bottomChartView.xAxis.labelTextColor = UIColor.white
        self.bottomChartView.rightAxis.maxWidth = self.view.width / 5
        self.bottomChartView.rightAxis.minWidth = self.view.width / 5

        self.bottomChartView.xAxis.avoidFirstLastClippingEnabled = true
        self.bottomChartView.xAxis.centerAxisLabelsEnabled = true
        self.bottomChartView.xAxis.drawGridLinesEnabled = false
        self.bottomChartView.xAxis.drawAxisLineEnabled = false
        self.bottomChartView.clipDataToContentEnabled = false
    }
    
    fileprivate func updateChartData() {
        if let lineData = self.topChartView.data, lineData.dataSetCount > 0,
            let barData = self.bottomChartView.data, barData.dataSetCount > 0,
            var lineDataSet = lineData.dataSets.first as? LineChartDataSet,
            var barDataSet = barData.dataSets.last as? BarChartDataSet {
            let point = datas.last
            let lineEntry = ChartDataEntry.init(x: Double((datas.last?.time)!), y: Double((datas.last?.price)!), icon: UIImage.init(named: "binary_chart_point"))
            let barEntry = BarChartDataEntry.init(x: Double((datas.last?.time)!), y: Double((datas.last?.turnOver)!))
            if point?.isStep == false {
                lineDataSet.popLast()
                barDataSet.popLast()
            }else {
                lineDataSet.remove(at: 0)
                barDataSet.remove(at: 0)
                lineDataSet.last?.icon = nil
            }
            lineDataSet.append(lineEntry)
            barDataSet.append(barEntry)
            
            lineData.notifyDataChanged()
            topChartView.notifyDataSetChanged()
            barData.notifyDataChanged()
            bottomChartView.notifyDataSetChanged()
        }
    }
    
    fileprivate func lineDatas() -> [ChartDataEntry] {
        return datas.map({ (point) -> ChartDataEntry in
            return ChartDataEntry.init(x: Double(point.time), y: point.price, icon: (point.isEqual(datas.last) ? UIImage.init(named: "binary_chart_point") : nil))
        })
    }
    
    fileprivate func barDatas() -> [BarChartDataEntry] {
        return datas.map({ (point) -> BarChartDataEntry in
            return BarChartDataEntry.init(x: Double(point.time), y: Double(point.turnOver))
        })
    }
}

extension THBothTimeDivisionChartViewController:IAxisValueFormatter,ChartViewDelegate {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        switch axis {
        case axis as? XAxis:
            return Date.getFormatDate(withTs: value, format: "mm:ss")
        case axis as? YAxis:
            return "\(value)"
        default:
            return Date.getFormatDate(withTs: value, format: "mm:ss")
        }
    }
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        highLightView.isHidden = false
        highLightView.update(centerPosition: CGPoint.init(x: highlight.xPx, y: highlight.yPx), horText: "\(entry.y)", verText: Date.getFormatDate(withTs: entry.x, format: "mm:ss"))
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        highLightView.isHidden = true
    }
    
}
