//
//  GDTableViewSliderCell.swift
//  GDDemo
//
//  Created by GDD on 2020-07-07.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit

class GDTableViewSliderCell: UITableViewCell {

    var isSlip: Bool = false
    var delegate: GDTableViewProtocol?
    private var sliderView: GDSliderContainerView?
    private var proxy: GDSliderCellProxy = GDSliderCellProxy.alloc()
    private var observer: NSKeyValueObservation!
    
    private var tableView: UITableView? {
        get {
            var view = self.superview
            while (view != nil) && !(view?.isKind(of: UITableView.self) ?? false) {
                view = view?.superview
            }
            if let view = view as? UITableView {
                return view
            }
            return nil
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configSliderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        var x: CGFloat = 0
        if self.isSlip { x = self.contentView.left }
        super.layoutSubviews()
        self.contentView.width = self.width
        if self.isSlip {  self.contentView.left = x }
    }
    
    func hideCell() {

        if self.contentView.left == 0 { return }
        self.isSlip = false

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.contentView.left = 0
        }) { (finish) in
//            self.sliderView?.removeFromSuperview()
//            self.sliderView = nil
        }
    }
    
    func mutableShowSlider() {
        self.showCell()
    }
    
    func showCell() {
        bindProxy()
        self.tableView?.hideOthersSliderCells(currentCell: self)
        self.tableView?.isSlip = true
        self.isSlip = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.contentView.left = -(self.sliderView?.width ?? 0)
            self.sliderView?.resetUI()
        }) { (finish) in
            
        }
    }
    
    private func hideBounceAnimate() {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.contentView.left = -10
        }) { (finish) in
            self.hideCell()
        }
    }

    
    func setActions(actions: [GDTableViewRowAction]) {

        self.sliderView = GDSliderContainerView.init(actions: actions) { finish in
            self.hideCell()
        }
        self.sliderView?.frame = CGRect.init(x: self.width, y: 0, width: sliderView?.width ?? 0, height: self.height)
        self.insertSubview(self.sliderView!, belowSubview: self.contentView)
    }
    
    private func checkActions() -> Bool {
        if let index = self.tableView?.indexPath(for: self) {
            let need = (self.delegate?.sliderCell(cell: self, canSlipAt: index) ?? false) || isSlip
            if need {
                if let actions = self.delegate?.sliderCell(cell: self, editActionsAt: index) {
                    self.setActions(actions: actions)
                    return true
                }
            }
        }
        return false
    }
    
    private func bindProxy() {
        guard let _ = self.proxy.target else {
            self.proxy.target = self.tableView
            return
        }
    }
}

extension GDTableViewSliderCell {
    private func configSliderView() {
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panAction(gesture:)))
        pan.delegate = self
        contentView.addGestureRecognizer(pan)
        observer = contentView.observe(\.frame, options: [.new, .initial], changeHandler: { [weak self](view, change) in
            guard let self = self else {return}
            self.sliderView?.left = self.contentView.width + self.contentView.left
            print("contentView.observe   %f", self.sliderView?.left)
        })
    }
    
    
    
    @objc private func panAction(gesture: UIPanGestureRecognizer) {
        let point = gesture.translation(in: gesture.view)
        gesture.setTranslation(CGPoint.zero, in: gesture.view)
        switch gesture.state {
        case .changed:
            var frame = contentView.frame
            var cFrame = sliderView?.frame
            if frame.origin.x + point.x <= -(sliderView?.width ?? 0) {
                let hindrance = point.x / 5
                if frame.origin.x + hindrance <= -(sliderView?.width ?? 0) {
                    frame.origin.x += hindrance
                    cFrame?.origin.x += hindrance
                    cFrame?.size.width -= hindrance
                } else {
                    frame.origin.x = -(sliderView?.width ?? 0)
                    cFrame?.origin.x = self.contentView.width - (sliderView?.width ?? 0)
                }
            } else {
                frame.origin.x += point.x
                cFrame?.origin.x += point.x
            }
            if frame.origin.x > 0 {
                frame.origin.x = 0
            }
            contentView.frame = frame
//            sliderView?.left = contentView.width + contentView.left
            sliderView?.stretch(width: abs(frame.origin.x))
            break
        case .ended:
            let v = gesture.velocity(in: gesture.view)
            let cx = contentView.left
            if cx == 0 {
                //重置状态
                hideCell()
            } else if cx > 5 {
                hideBounceAnimate()
            } else if abs(cx) >= 40 && v.x <= 0 {
                showCell()
            } else {
                hideCell()
            }
            break
        case .cancelled:
            hideCell()
            break
        default:
            break
        }
    }
    
}

extension GDTableViewSliderCell {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && (self.sliderView == nil) {
            return checkActions()
        }
        return true
    }
}
