//
//  GDSliderContainerView.swift
//  GDDemo
//
//  Created by GDD on 2020-07-07.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit

class GDSliderContainerView: UIView {
    private var total_width: CGFloat = 0
    private var current_height: CGFloat = 0
    private var action_widths: [CGFloat] = []
    private var action_btns: [UIButton] = []
    private var action_views: [UIView] = []
    private var actions: [GDTableViewRowAction] = []
    private var btn_margin: CGFloat = 5
    private var indexPath: IndexPath?

    private var complete: ((Bool) -> Void)!
    public init(actions: [GDTableViewRowAction], index: IndexPath? = nil, closeCallback: @escaping (Bool) -> Void) {
        super.init(frame: CGRect.zero)
        self.indexPath = index
        self.preLayoutUI(actions: actions)
        self.complete = closeCallback
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func preLayoutUI(actions: [GDTableViewRowAction]) {
        self.actions = actions
        for (idx, act) in actions.enumerated() {
            let bgV = UIView()
            bgV.backgroundColor = act.backgroundColor
            let btn = UIButton.init(type: .custom)
            btn.adjustsImageWhenHighlighted  = false
            btn.setTitle(act.title, for: .normal)
            btn.setTitleColor(UIColor.white, for: .normal)
            
            btn.setImage(act.icon, for: .normal)
            
            guard let text = act.title as NSString? else {
                return
            }
            let size: CGSize = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
            var width = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: btn.titleLabel?.font], context: nil).size.width
            if let image = act.icon {
                width = max(width, image.size.width)
                btn.layoutButton(.imageTop, space: act.margin)
            }
            width += act.margin * 2
            
            
            
            bgV.frame = CGRect.init(x: total_width, y: 0, width: width, height: 0)
            action_views.append(bgV)
            btn.frame = CGRect.init(x: 0, y: 0, width: width, height: bgV.height)
            action_btns.append(btn)
            action_widths.append(width)
            total_width += width
            btn.tag = idx
            btn.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            bgV.addSubview(btn)
            self.addSubview(bgV)
        }
        self.frame = CGRect.init(x: self.width, y: 0, width: total_width, height: 0)
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        if let callback = self.actions[sender.tag].actionHander {
            callback(self.actions[sender.tag], self.indexPath, self.complete)
        }
    }
    
    
    func stretch(width: CGFloat) {
        let needExpandWidth = width - total_width
        var left:CGFloat = 0
        for (idx,v) in action_views.enumerated() {
            let tmpW = (needExpandWidth * action_widths[idx])/total_width
            v.width = tmpW + action_widths[idx]
            v.left = left
            left += v.width
        }
    }
    
    func resetUI() {
        var left:CGFloat = 0
        for (idx,v) in action_views.enumerated() {
            v.width = action_widths[idx]
            v.left = left
            left += v.width
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.height == self.current_height {
            return
        }
        self.current_height = self.height
        for (idx,v) in action_views.enumerated() {
            v.height = self.height
            v.width = action_widths[idx]
            v.top = 0
        }
        
        for (idx, btn) in action_btns.enumerated() {
            btn.height = self.height
            btn.top = 0
            btn.layoutButton(.imageTop, space: btn_margin)
        }
    
        
    }
}
enum LayoutStyle: Int {
   case imageTop
   case imageLeft
   case imageBottom
   case imageRight
}

extension UIButton {
   
   func layoutButton(_ style: LayoutStyle, space: CGFloat) {
       
       guard let titleL = self.titleLabel, let imageV = self.imageView else {
           return
       }
       
       let imageWidth = imageV.frame.size.width
       let imageHeight = imageV.frame.size.height
       
       let labelWidth = titleL.frame.size.width
       let labelHeight = titleL.frame.size.height
       
       let imageX = imageV.frame.origin.x
       let labelX = titleL.frame.origin.x
       
       let margin = labelX - imageX - imageWidth
       
       var imageInsets = UIEdgeInsets.zero
       var labelInsets = UIEdgeInsets.zero
       
       /**
        *  titleEdgeInsets是title相对于其上下左右的inset
        *  如果只有title，那它上下左右都是相对于button的，image也是一样；
        *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
        */
       switch style {
       case .imageTop:
           imageInsets = UIEdgeInsets(top: -0.5 * labelHeight, left: 0.5 * labelWidth + 0.5 * margin + imageX, bottom: 0.5 * (labelHeight + space), right: 0.5 * (labelWidth - margin))
           labelInsets = UIEdgeInsets(top: 0.5 * (imageHeight + space), left: -(imageWidth - 5), bottom: -0.5 * imageHeight, right: 5)
           
       case .imageBottom:
           imageInsets = UIEdgeInsets(top: 0.5 * (labelHeight + space), left: 0.5 * labelWidth + imageX, bottom: -0.5 * labelHeight, right: 0.5 * labelWidth)
           labelInsets = UIEdgeInsets(top: -0.5 * imageHeight, left: -(imageWidth - 5), bottom:0.5 * (imageHeight + space), right: 5)
           
       case .imageRight:
           imageInsets = UIEdgeInsets(top: 0, left: 0.5 * (labelWidth + space), bottom: 0, right: -(labelWidth + 0.5 * space))
           labelInsets = UIEdgeInsets(top: 0, left: -(imageWidth + 0.5 * space), bottom: 0, right: imageWidth + space * 0.5)
           
       default:
           imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0.5 * space)
           labelInsets = UIEdgeInsets(top: 0, left: 0.5 * space, bottom: 0, right: 0)
       }
       
       self.titleEdgeInsets = labelInsets;
       self.imageEdgeInsets = imageInsets;
   }
   
}


