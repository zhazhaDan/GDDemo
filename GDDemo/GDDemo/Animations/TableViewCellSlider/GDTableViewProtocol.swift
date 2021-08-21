//
//  GDTableViewProtocol.swift
//  GDDemo
//
//  Created by GDD on 2020-07-08.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit

protocol GDTableViewProtocol {
    func sliderCell(cell: GDTableViewSliderCell, canSlipAt indexPath: IndexPath) -> Bool
    
    func sliderCell(cell: GDTableViewSliderCell, editActionsAt indexPath: IndexPath) -> [GDTableViewRowAction]?
    
}
