//
//  UIView+screenshot.swift
//  ZSKImageEditor
//
//  Created by 张少康 on 2022/11/17.
//

import Foundation

extension UIView{
    func screenshotImage() ->UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
