//
//  SafeTestViewController.swift
//  GDDemo
//
//  Created by GDD on 2021/8/20.
//  Copyright © 2021 GDD. All rights reserved.
//

import UIKit

class SafeTestViewController: BaseViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
//        var array: GCDBarrierSafeArray = GCDBarrierSafeArray()
        var array: [Int] = []
        let queue = DispatchQueue.init(label: "teset")
        for i in 0..<100 {
            queue.async {
                array.append(i)
            }
        }
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
