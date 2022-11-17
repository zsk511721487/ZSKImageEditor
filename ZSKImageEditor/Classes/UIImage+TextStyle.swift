//
//  UIImage+TextStyle.swift
//  TextEditDemo
//
//  Created by 张少康 on 2022/11/4.
//

import Foundation
import UIKit

extension UIImage {
    
    /// 加载当前Appearance模式下的图片
    /// - Parameter imageName: 图片名称
    /// - Returns: 返回图片
    public static func loadCurrentAppearanceImage(imageName: String) -> UIImage? {
        if UITraitCollection.current.userInterfaceStyle == .dark {
            if let darImage = UIImage.getZSKImage(from: "dark_" + imageName) {
                return darImage
            }
            return UIImage.getZSKImage(from: imageName)
        }else {
            return UIImage.getZSKImage(from: imageName)
        }
    }
    
    /// 获取图片
    /// - Parameter key: 传入图片名称
    /// - Returns: 返回图片
    public static func getZSKImage(from key: String) -> UIImage?{
        var imageName: String = ""
        if key.contains(".png") || key.contains(".jpg"){
            imageName = key
        }else {
            imageName = key + ".png"
        }
        
        let current = Bundle(for: ZSKImageEditorViewController.self)
        let imagePath = "ZSKImageEditor.bundle/\(imageName)"
        let fullPath = current.resourcePath
        if let currentBundle = fullPath {
            let imagePath = "\(currentBundle)/\(imagePath)"
            return UIImage.init(contentsOfFile: imagePath)
        }else {
            return nil
        }
    }
    
    
    /// 设置sf符号图片
    /// - Parameters:
    ///   - imageName: 图片名称
    ///   - pointSize: pointsize
    ///   - weight: UIFont.Weight
    ///   - scale: UIFont.TextStyle
    /// - Returns: 返回图片
    public static func getSFImage(imageName: String,pointSize: CGFloat = 30, weight: UIImage.SymbolWeight = .light, scale: UIImage.SymbolScale = .small) -> UIImage?{
        let largeConfig = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight, scale: scale)
        let largeBoldDoc = UIImage(systemName: imageName, withConfiguration: largeConfig)
        return largeBoldDoc
    }
    
    /// 裁剪图片
    func cropToSize(rect: CGRect) -> UIImage {
        var newRect = rect
        newRect.origin.x *= self.scale
        newRect.origin.y *= self.scale
        newRect.size.width *= self.scale
        newRect.size.height *= self.scale
        let cgimage = self.cgImage?.cropping(to: newRect)
        let resultImage = UIImage(cgImage: cgimage!, scale: self.scale, orientation: self.imageOrientation)
        return resultImage
    }
    
    /// UIColor-->UIImage
    func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color.cgColor)
        
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsGetCurrentContext()
        
        return image!
    }
    
    //图片旋转
    func rotate(radians: CGFloat) -> UIImage {
            let rotatedSize = CGRect(origin: .zero, size: size)
                .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
                .integral.size
            UIGraphicsBeginImageContext(rotatedSize)
            if let context = UIGraphicsGetCurrentContext() {
                let origin = CGPoint(x: rotatedSize.width / 2.0,
                                     y: rotatedSize.height / 2.0)
                context.translateBy(x: origin.x, y: origin.y)
                context.rotate(by: radians)
                draw(in: CGRect(x: -origin.y, y: -origin.x,
                                width: size.width, height: size.height))
                let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return rotatedImage ?? self
            }

            return self
        }
        
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize) -> UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale)
        self.draw(in: CGRect(x:0,y:0,width:reSize.width,height:reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return reSizeImage
    }
    
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize:CGFloat) -> UIImage {
        let reSize = CGSize(width:self.size.width * scaleSize,height:self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
    
}
