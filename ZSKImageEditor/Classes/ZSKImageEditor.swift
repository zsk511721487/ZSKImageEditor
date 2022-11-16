//
//  ZSKImageEditor.swift
//  ZSKImageEditor
//
//  Created by 张少康 on 2022/11/16.
//

import Foundation
import SnapKit
import UIKit

func safeAreaTop() -> CGFloat {
    if (UIApplication.shared.delegate)?.window??.safeAreaInsets.bottom == 0 {
        return 20.0
    }
    return (UIApplication.shared.delegate)?.window??.safeAreaInsets.top ?? 20.0
}

func safeAreaBottom() -> CGFloat {
    return (UIApplication.shared.delegate)?.window??.safeAreaInsets.bottom ?? 0
}

protocol ZSKImageEditorEditViewProtocol {
    var inputImage: UIImage {get}
    var closeBlock: (()->Void) {get}
    var finishBlock: (()->Void) {get}
}
