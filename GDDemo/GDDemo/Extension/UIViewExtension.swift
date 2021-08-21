//
//  UIViewExtension.swift
//  GDDemo
//
//  Created by 龚丹丹 on 2019/5/20.
//  Copyright © 2019 GDD. All rights reserved.
//

import UIKit

extension UIView {

    //将当前视图转为UIImage
    @available(iOS 10.0, *)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    //获取当前显示图片大小的图
    func imageSnpShot() -> UIImage {
                UIGraphicsBeginImageContext(self.bounds.size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imgae = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imgae!
    }
}
