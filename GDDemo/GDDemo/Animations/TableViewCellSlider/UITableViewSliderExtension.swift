//
//  GDSliderTableView.swift
//  GDDemo
//
//  Created by GDD on 2020-07-07.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit


private var  GDSliderCellProxyKey = "GDSliderCellProxyKey"
private var  GDTableViewIsSlipKey = "GDTableViewIsSlipKey"

extension UITableView {
    var isSlip: Bool {
        set {
            objc_setAssociatedObject(self, &GDTableViewIsSlipKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        
        get {
            return objc_getAssociatedObject(self, &GDTableViewIsSlipKey) as? Bool ?? false
        }
    }
    var sliderCellProxy: GDSliderCellProxy? {
        set {
            objc_setAssociatedObject(self, &GDSliderCellProxyKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        
        get {
            return objc_getAssociatedObject(self, &GDSliderCellProxyKey) as? GDSliderCellProxy
        }
    }
    
    func hideAllSliderCells() -> Bool {
        isSlip = false
        for cell in self.visibleCells {
            if let cell = cell as? GDTableViewSliderCell {
                if cell.isSlip {
                    cell.hideCell()
                    self.deselectRow(at: self.indexPath(for: cell)!, animated: true)
                    return false
                }
            }
        }
        return true
    }

    func hideOthersSliderCells(currentCell: GDTableViewSliderCell) {
        isSlip = false
        for cell in self.visibleCells {
            if let cell = cell as? GDTableViewSliderCell {
                if currentCell == cell {
                    isSlip = true
                } else if cell.isSlip {
                    cell.hideCell()
                    self.deselectRow(at: self.indexPath(for: cell)!, animated: true)
                }
            }
        }
    }
    
}
