//
//  UIView+screenshot.swift
//  ZSKImageEditor
//
//  Created by 张少康 on 2022/11/17.
//

import Foundation

extension UIView{
    func screenshotImage() ->UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
//        let renderer = UIGraphicsImageRenderer(bounds: bounds)
//        return renderer.image { rendererContext in
//            layer.render(in: rendererContext.cgContext)
//        }
    }
    
    func buildImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    static func addGreyFilterToView(view: UIView, rect: CGRect? = nil) {
        view.isUserInteractionEnabled = true
        let frame = rect == nil ? view.bounds : rect!
        let coverView = UIView(frame: frame)
        coverView.isUserInteractionEnabled = false
        coverView.backgroundColor = UIColor.lightGray
        coverView.tag = 1010101010
        coverView.layer.compositingFilter = "saturationBlendMode"
        coverView.layer.zPosition = CGFloat.greatestFiniteMagnitude
        view.addSubview(coverView)
    }
    
    static func removeGreyFilterToView(view: UIView) {
        if let coverView = view.viewWithTag(1010101010) {
            coverView.removeFromSuperview()
        }
    }
}