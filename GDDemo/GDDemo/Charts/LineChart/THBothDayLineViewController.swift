//
//  THBothDayLineViewController.swift
//  GDDemo
//
//  Created by GDD on 2019/3/18.
//  Copyright © 2019 GDD. All rights reserved.
//

import UIKit
import Charts

class THBothDayLineViewController: BaseViewController {
    public var datas:[DataModel] = []
    private var highLightView:THChartHighLightView = THChartHighLightView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func bindData() {
//        let nowTimeInterval = Date().timeIntervalSince1970
//        for i in 0 ..< 60 {
//            let point = DataModel.init(time: Int64(nowTimeInterval) - Int64(i*60) , price: Double(arc4random()%1000 + 1000), turnOver: Int64(arc4random()%100 + 200), isStep: true)
//            datas.insert(point, at: 0)
//        }
        let datas = candleDatas()
        initCandleChartView(datas: datas.first!)
        initBarChartView(datas: [datas[1],datas.last!])
        customCandleChartView()
        customBarChartView()
    }
    
    private func candleDatas() -> [[ChartDataEntry]]{
//        var i : Int = 0
//        return datas.map { (item) -> CandleChartDataEntry in
//            i += 1
//            return CandleChartDataEntry.init(x: Double(item.time), shadowH: item.price + Double(arc4random_uniform(100)), shadowL: item.price - Double(arc4random_uniform(100)), open: (i % 2 == 0 ? (item.price + Double(arc4random_uniform(6))) : item.price - Double(arc4random_uniform(6))), close: (i % 2 == 0 ? (item.price - Double(arc4random_uniform(6))) : item.price + Double(arc4random_uniform(6))))
//        }
        var yVals1:[CandleChartDataEntry] = []
        var yVals2:[BarChartDataEntry] = []
        var yVals3:[BarChartDataEntry] = []
        let nowTimeInterval = Date().timeIntervalSince1970

        (1..<60).forEach { (i) in
            let mult:Double = 100 + 1
            let val = Double(arc4random_uniform(40)) + mult
            let high = Double(arc4random_uniform(9) + 8)
            let low = Double(arc4random_uniform(9) + 8)
            let open = Double(arc4random_uniform(6) + 1)
            let close = Double(arc4random_uniform(6) + 1)
            let even = i % Int(arc4random_uniform(5) + 1) == 0
            if even == true {
                datas.insert(DataModel.init(time: (Int64(nowTimeInterval) - Int64(i*60*60*24)), high: val + high, low: val - low, close: val - close, open: val + open, turnOver: Int64(val + high + open)), at: 0)
                yVals1.insert(CandleChartDataEntry(x: Double(59 - i), shadowH: val + high, shadowL: val - low, open:val + open, close: val - close), at: 0)
                yVals2.insert(BarChartDataEntry.init(x: Double(59 - i), y: val + high + open), at: 0)

            }else {
                datas.insert(DataModel.init(time: (Int64(nowTimeInterval) - Int64(i*60*60*24)), high: val + high, low: val - low, close: val + close, open: val - open, turnOver: Int64(val - high - open)), at: 0)
                yVals1.insert(CandleChartDataEntry(x: Double(59 - i), shadowH: val + high, shadowL: val - low, open: val - open, close: val + close), at: 0)
                yVals3.insert(BarChartDataEntry.init(x: Double(59 - i), y: val - high - open), at: 0)
            }
        }
        return [yVals1,yVals2,yVals3]
    }
    
    override func bindView() {
        self.view.backgroundColor = UIColor.hex(0x191A2F)
        self.view.addSubview(candleChartView)
        self.view.addSubview(barChartView)

        self.view.addSubview(highLightView)

        candleChartView.delegate = self
        barChartView.delegate = self
        candleChartView.snp.makeConstraints({
            $0.size.equalTo(CGSize.init(width: self.view.width, height: 253))
            $0.top.equalTo(218)
        })
        
        barChartView.snp.makeConstraints({
            $0.size.equalTo(CGSize.init(width: self.view.width, height: 105))
            $0.top.equalTo(candleChartView.snp.bottom)
        })
        
        highLightView.snp.makeConstraints({
            $0.left.right.equalToSuperview()
            $0.top.equalTo(candleChartView)
            $0.bottom.equalTo(barChartView)
        })
        highLightView.isUserInteractionEnabled = false
    }
    
    
    fileprivate var candleChartView:CandleStickChartView! = {
        var chartView:CandleStickChartView = CandleStickChartView()
        chartView.dragEnabled = true
        chartView.doubleTapToZoomEnabled = false
        chartView.highlightPerTapEnabled = true
        chartView.legend.form = .none
        chartView.minOffset = 0
        chartView.fitScreen()
        return chartView
    }()

    private lazy var barChartView:BarChartView = {
        let chartView = BarChartView()
        chartView.fitBars = true
        chartView.dragEnabled = true
        chartView.doubleTapToZoomEnabled = false
        chartView.highlightPerTapEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.legend.form = .none
        chartView.minOffset = 0
        return chartView
    }()
}

extension THBothDayLineViewController {
    fileprivate func initCandleChartView(datas:[ChartDataEntry]) {
        let candleBarDataSet1 = CandleChartDataSet.init(entries: datas, label: "")
//        candleBarDataSet1.setColor(UIColor.hex(0x11C194))
        candleBarDataSet1.drawIconsEnabled = false
        candleBarDataSet1.shadowWidth = 0.5
        candleBarDataSet1.barSpace = 0.2
        candleBarDataSet1.increasingColor = UIColor.hex(0x11C194)
        candleBarDataSet1.decreasingColor = UIColor.hex(0xF77F63)
        candleBarDataSet1.decreasingFilled = true
        candleBarDataSet1.increasingFilled = true
        candleBarDataSet1.shadowColorSameAsCandle = true
        candleBarDataSet1.shadowColor = UIColor.hex(0x11C194)
        candleBarDataSet1.setDrawHighlightIndicators(false)
        let candleBarData = CandleChartData.init(dataSets: [candleBarDataSet1])
        candleBarData.setDrawValues(false)
        candleChartView.data = candleBarData
    }
    
    fileprivate func initBarChartView(datas:[[ChartDataEntry]]) {
        let dataset1 = BarChartDataSet.init(entries: datas.last, label: "跌")
        dataset1.setColor(UIColor.hex(0x11C194))
        let dataset2 = BarChartDataSet.init(entries: datas.first, label: "涨")
        dataset2.setColor(UIColor.hex(0xF77F63))
        let data:BarChartData = BarChartData.init(dataSets: [dataset1,dataset2])
        data.setDrawValues(false)
        //        data.groupBars(fromX: (datasOne.first?.x)!, groupSpace: 0, barSpace: 1)
//                data.barWidth = 2
        barChartView.data = data
    }
    
    
    
    fileprivate func customCandleChartView() {
        self.candleChartView.xAxis.drawLabelsEnabled = false
        self.candleChartView.leftAxis.drawLabelsEnabled = false
        self.candleChartView.leftAxis.drawAxisLineEnabled = false
        self.candleChartView.leftAxis.drawGridLinesEnabled = false
        self.candleChartView.rightAxis.valueFormatter = self
        self.candleChartView.rightAxis.setLabelCount(5, force: true)
        self.candleChartView.rightAxis.maxWidth = self.view.width / 5
        self.candleChartView.rightAxis.minWidth = self.view.width / 5
        self.candleChartView.rightAxis.yOffset = 6
        self.candleChartView.rightAxis.labelTextColor = UIColor.white
        self.candleChartView.rightAxis.drawAxisLineEnabled = false
        self.candleChartView.rightAxis.drawGridLinesEnabled = false
        self.candleChartView.rightAxis.drawLabelsEnabled = true
        self.candleChartView.xAxis.drawGridLinesEnabled = false
        self.candleChartView.xAxis.drawAxisLineEnabled = false
        self.candleChartView.leftAxis.xOffset = 0
        self.candleChartView.xAxis.avoidFirstLastClippingEnabled = true
    }
    
    
    fileprivate func customBarChartView() {
        self.barChartView.leftAxis.drawLabelsEnabled = false
        self.barChartView.leftAxis.drawAxisLineEnabled = false
        self.barChartView.leftAxis.drawGridLinesEnabled = false
        self.barChartView.rightAxis.drawLabelsEnabled = true
        self.barChartView.rightAxis.setLabelCount(1, force: true)
        self.barChartView.rightAxis.valueFormatter = self
        self.barChartView.rightAxis.drawAxisLineEnabled = false
        self.barChartView.rightAxis.drawGridLinesEnabled = false
        self.barChartView.rightAxis.drawBottomYLabelEntryEnabled = false
        self.barChartView.rightAxis.yOffset = 6
        self.barChartView.rightAxis.labelTextColor = UIColor.white
        self.barChartView.xAxis.labelPosition = .bottom
        self.barChartView.xAxis.valueFormatter = self
        self.barChartView.xAxis.setLabelCount(4, force: false)
        self.barChartView.xAxis.labelTextColor = UIColor.white
        self.barChartView.rightAxis.maxWidth = self.view.width / 5
        self.barChartView.rightAxis.minWidth = self.view.width / 5
        
        self.barChartView.xAxis.avoidFirstLastClippingEnabled = true
        self.barChartView.xAxis.centerAxisLabelsEnabled = true
        self.barChartView.xAxis.drawGridLinesEnabled = false
        self.barChartView.xAxis.drawAxisLineEnabled = false
        self.barChartView.clipDataToContentEnabled = false
    }
    
}


extension THBothDayLineViewController:ChartViewDelegate,IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        switch axis {
        case axis as? XAxis:
            if value >= 0 && value < 60 {
                return Date.getFormatDate(withTs: Double(datas[Int(value)].time)*1000, format: "yy-MM-dd")
            }
            return ""
        case axis as? YAxis:
            return "\(value)"
        default:
            return Date.getFormatDate(withTs: Double(datas[Int(value)].time)*1000, format: "yy-MM-dd")
        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        highLightView.isHidden = false
        chartView.highlightValue(highlight)
//        if  let elements = chartView.renderer as? CandleStickChartRenderer {
//            let index = chartView.data?.dataSets.first?.entryIndex(entry: entry)
////            let frame = elements.accessibleChartElements[index]
//        }
        highLightView.update(centerPosition: CGPoint.init(x: highlight.xPx, y: highlight.yPx), horText: "\(entry.y)", verText: Date.getFormatDate(withTs: double_t(datas[Int(entry.x)].time), format: "mm:ss"))
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        highLightView.isHidden = true
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        if chartView == candleChartView {
            barChartView.delegate?.chartScaled!(barChartView, scaleX: scaleX, scaleY: scaleY)
        }
    }
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        if chartView == candleChartView {
            barChartView.delegate?.chartTranslated!(barChartView, dX: dX, dY: dY)
        }
    }
}
