//
//  CustomPanViewController.swift
//  GDDemo
//
//  Created by GDD on 2021/5/26.
//  Copyright © 2021 GDD. All rights reserved.
//

import UIKit

class CustomPanViewController: UIPageViewController {

    private var vcs: [UIViewController] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = LinkageViewController()
        vc1.view.backgroundColor = .red
        let vc2 = LinkageViewController()
        vc2.view.backgroundColor = .yellow
        let vc3 = LinkageViewController()
        vc3.view.backgroundColor = .orange
        let vc4 = LinkageViewController()
        vc4.view.backgroundColor = .gray

        vcs = [vc1, vc2, vc3, vc4]
        self.setViewControllers([vc1], direction: .forward, animated: false, completion: nil)
        self.setViewControllers([vc2], direction: .forward, animated: false, completion: nil)
        self.setViewControllers([vc3], direction: .forward, animated: false, completion: nil)
        self.setViewControllers([vc4], direction: .forward, animated: false, completion: nil)
        self.delegate = self
        self.dataSource = self

        for v in self.view.subviews {
            if v.isKind(of: NSClassFromString("_UIQueuingScrollView")!) {
                (v as! UIScrollView).delegate = self
                for ges in v.gestureRecognizers! {
                    ges.require(toFail: self.navigationController?.interactivePopGestureRecognizer ?? UIGestureRecognizer())
                }
            }
        }

        // Do any additional setup after loading the view.
    }
    
    func indexOf(vc: UIViewController?) -> Int {
        for i in 0..<vcs.count {
            if vcs[i] == vc {
                return i
            }
        }
        return -1
    }

}

extension CustomPanViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let num = indexOf(vc: viewController)
        if num > 0 {


            let vc = vcs[num - 1]
            return vc
        }

        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let num = indexOf(vc: viewController)
        if num < vcs.count - 1 {

            let vc = vcs[num + 1]
            return vc
        }
        return nil

    }


}

extension CustomPanViewController: UIScrollViewDelegate {

}
