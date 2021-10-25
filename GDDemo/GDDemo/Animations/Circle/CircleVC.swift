//
//  CircleVC.swift
//  GDDemo
//
//  Created by GDD on 2021/10/22.
//  Copyright © 2021 GDD. All rights reserved.
//

import UIKit

class CircleVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .gray
        
        let view = BezierCircleView(frame: CGRect.init(x: (self.view.width - 250)/2, y: 100, width: 250, height: 250))
        self.view.addSubview(view)
        
        
        let view2 = BezierCircleStyle2View(frame: CGRect.init(x: (self.view.width - 250)/2, y: 400, width: 250, height: 250))
        self.view.addSubview(view2)
        
        let view3 = BezierCircleStyle3View(frame: CGRect.init(x: (self.view.width - 250)/2, y: 500, width: 250, height: 250))
        self.view.addSubview(view3)

//        view.startTimer()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
