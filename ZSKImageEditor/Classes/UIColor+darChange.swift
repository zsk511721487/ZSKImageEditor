//
//  UIColor+darChange.swift
//  KTRichEditorView
//
//  Created by 张少康 on 2022/11/8.
//

import Foundation
import UIKit

extension UIColor {
    static func zsk_currentColor(_ light: UIColor, _ dark: UIColor) ->UIColor {
        return UIColor.init { interfaceStyle in
            if interfaceStyle.userInterfaceStyle == .dark {
                return dark
            }else {
                return light
            }
        }
    }
    
    static var zsk_groupedBackgroundColor: UIColor {
        return .secondarySystemBackground
    }
    
    static var zsk_backgroundColor: UIColor {
        return .systemBackground
    }
    
    static var zsk_titleColr: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        }else {
            return .black
        }
    }
    
    static var zsk_secondaryTitleColr: UIColor {
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        }else {
            return UIColor(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1.0)
        }
    }
    
    static var zsk_tertiaryTitleColr: UIColor {
        if #available(iOS 13.0, *) {
            return .tertiaryLabel
        }else {
            return UIColor(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1.0)
        }
    }
    
    
    public convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public convenience init(hex: String) {
        
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String = hex
        
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
