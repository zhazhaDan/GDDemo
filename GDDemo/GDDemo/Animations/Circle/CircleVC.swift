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

        let view = BezierCircleView(frame: CGRect.init(x: (self.view.width - 250)/2, y: 100, width: 250, height: 250))
        self.view.addSubview(view)
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
