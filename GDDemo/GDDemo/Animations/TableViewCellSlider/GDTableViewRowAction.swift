//
//  GDTableViewRowAction.swift
//  GDDemo
//
//  Created by GDD on 2020-07-07.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit

typealias GDTableViewRowActionHander = ((GDTableViewRowAction, IndexPath?, @escaping (Bool) -> Void) -> Swift.Void)

class GDTableViewRowAction: NSObject {
    open var title: String?
    open var icon: UIImage?
    
    open var backgroundColor: UIColor?
    open var margin: CGFloat = 15

    var actionHander: GDTableViewRowActionHander?
    var completeHander: ((Bool) -> Swift.Void)?
    public convenience init(title: String?, image: UIImage?, handler: @escaping GDTableViewRowActionHander) {
        self.init()
        self.title = title
        self.icon = image
        self.actionHander = handler
    }
    
    
    
}
