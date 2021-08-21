//
//  THVipAssetChartView.swift
//  GDDemo
//
//  Created by GDD on 2019/5/27.
//  Copyright © 2019 GDD. All rights reserved.
//

import UIKit
import Charts

class THVipAssetChartView: UIView {
    private var lineChartView: LineChartView = LineChartView()
    private var lineDatas: [[ChartDataEntry]] = []
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setupUI()
        setupLayout()
    }
    
   /// 这里目前是测试数据 这里将 NSObject 换成数据对象，然后在方法里map映射成 ChartDataEntry里即可
    public func update(datas:[NSObject]) {
        var entry1: [ChartDataEntry] = []
        var entry2: [ChartDataEntry] = []
        for i in stride(from: 0, to: 46, by: 1) {
            var flag: Double = -1
            if i%3 == 0 {
                flag = -1
            }else {
                flag = 1
            }
            let item1 = ChartDataEntry.init(x: Double(i), y: Double(34545) + Double(arc4random()%10000) * flag, data: UIColor.hex(0xff684E))
            entry1.append(item1)
            let item2 = ChartDataEntry.init(x: Double(i), y: Double(253) + Double(123*i), data: UIColor.hex(0x696Fd8))
            entry2.append(item2)
        }
        lineDatas = [entry1, entry2]
        drawChartView()
    }
    
    public func update(realData: [NSObject]) {
        
    }
}

// setUp Extension
extension THVipAssetChartView {
    func setupUI() {
        self.addSubview(lineChartView)
        customChartView()
    }
    
    /// 更新曲线图
    func updateChartView() {
        if let marker = lineChartView.marker as? THVipAssetChartMarkerView {
            marker.value2CircleColor = UIColor.hex(0xff684E)
        }
    }
    
    
    func customChartView() {

        let rightAxis = lineChartView.rightAxis
        rightAxis.drawLabelsEnabled = true
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawZeroLineEnabled = false
        rightAxis.labelPosition = .outsideChart
        rightAxis.zeroLineColor = UIColor.hex(0x777777)
        rightAxis.setLabelCount(5, force: true)
        rightAxis.labelFont = UIFont.pingFangRegularFont(size: 9)!
        rightAxis.labelTextColor = UIColor.hex(0x999999)
        rightAxis.yOffset = -5
        rightAxis.drawAxisLineEnabled = true
        rightAxis.axisLineColor = UIColor.hex(0x777777)
        rightAxis.axisLineWidth = 0.5

        
        let leftAxis = lineChartView.leftAxis
        leftAxis.drawLabelsEnabled = true
        leftAxis.setLabelCount(5, force: true)
        leftAxis.drawZeroLineEnabled = true
        leftAxis.drawAxisLineEnabled = true
        leftAxis.axisLineColor = UIColor.hex(0x777777)
        leftAxis.drawGridLinesEnabled = false
        leftAxis.gridColor = UIColor.hex(0xeeeeee)
        leftAxis.zeroLineColor = UIColor.hex(0xeeeeee)
        leftAxis.gridLineWidth = 1/UIScreen.main.scale
        leftAxis.labelPosition = .outsideChart
        leftAxis.valueFormatter = self
        leftAxis.labelFont = UIFont.pingFangRegularFont(size: 9)!
        leftAxis.labelTextColor = UIColor.hex(0x999999)
        leftAxis.yOffset = -5
        leftAxis.axisLineWidth = 0.5
        leftAxis.axisLineDashPhase = 2
        leftAxis.axisLineDashLengths = [4,4]

        let xAxis = lineChartView.xAxis
        xAxis.valueFormatter = self
        xAxis.labelFont = UIFont.pingFangRegularFont(size: 9)!
        xAxis.labelTextColor = UIColor.hex(0x999999)
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLimitLinesBehindDataEnabled = false
        xAxis.drawAxisLineEnabled = true
        xAxis.axisLineColor = UIColor.hex(0x777777)
        xAxis.labelPosition = .bottom
        xAxis.axisLineWidth = 0.5

        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.highlightPerTapEnabled = true
        lineChartView.highlightPerDragEnabled = true
        lineChartView.scaleXEnabled = false
        lineChartView.scaleYEnabled = false
        lineChartView.legend.form = .none
        lineChartView.minOffset = 0
        
        
        let marker = THVipAssetChartMarkerView.init(frame: self.lineChartView.bounds, xAxisValueFormatter: lineChartView.xAxis.valueFormatter!)
        marker.chartView = lineChartView
        lineChartView.marker = marker
    }
    
    func drawChartView() {
        lineChartView.xAxis.setLabelCount(4, force: false)
        var set1: LineChartDataSet! = nil
        var set2: LineChartDataSet! = nil
        if  let sett1 = lineChartView.data?.dataSets.first as? LineChartDataSet,
            let sett2 = lineChartView.data?.dataSets.last as? LineChartDataSet{
            set1 = sett1
            set2 = sett2
            
            set1.replaceEntries(self.lineDatas.first ?? [])
            set2.replaceEntries(self.lineDatas.last ?? [])
            lineChartView.data?.notifyDataChanged()
            lineChartView.notifyDataSetChanged()
        } else {
            set1 = LineChartDataSet(entries: self.lineDatas.first, label: "")
            set1.setColor(UIColor.hex(0x00c4ff))
            set1.lineWidth = 1
            set1.drawValuesEnabled = false
            set1.drawCirclesEnabled = false
            set1.drawCircleHoleEnabled = true
            set1.axisDependency = lineChartView.leftAxis.axisDependency
            set1.highlightColor = UIColor.hex(0x3D47Fa, alpha: 0.7)
            set2 = LineChartDataSet(entries: self.lineDatas.last, label: "")
            set2.setColor(UIColor.hex(0x696Fd8))
            set2.lineWidth  = 2
            set2.drawCirclesEnabled = false
            set2.drawValuesEnabled = false
            set2.drawCircleHoleEnabled = true
            set2.highlightColor = UIColor.hex(0x3D47Fa, alpha: 0.7)
            set2.axisDependency = lineChartView.rightAxis.axisDependency
            let data = LineChartData.init(dataSets: [set1, set2])
            lineChartView.data = data
            lineChartView.setViewPortOffsets(left: 50, top: 0, right: 50, bottom: 30)
        }
    }
    
    func setupLayout() {
        lineChartView.snp.makeConstraints({
            $0.left.equalTo(8.5)
            $0.right.equalTo(-8.5)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
    }
}

extension THVipAssetChartView: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(value)"
    }
}
