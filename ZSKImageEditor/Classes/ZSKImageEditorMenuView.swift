//
//  ZSKImageEditorMenuView.swift
//  ZSKImageEditor
//
//  Created by 张少康 on 2022/11/16.
//

import UIKit

class ZSKImageEditorMenuView: UIView {
    
    lazy var rotateButton: ZSKImageEditorButton = {
        let btn = ZSKImageEditorButton(buttonName: "旋转", image: UIImage.loadCurrentAppearanceImage(imageName: "zskimgedit_menu_rotate_icon"))
        return btn
    }()
    lazy var blackwhiteButton: ZSKImageEditorButton = {
        let btn = ZSKImageEditorButton(buttonName: "黑白", image: UIImage.loadCurrentAppearanceImage(imageName: "zskimgedit_menu_blackwhite_icon"))
        return btn
    }()
    lazy var cropButton: ZSKImageEditorButton = {
        let btn = ZSKImageEditorButton(buttonName: "裁剪", image: UIImage.loadCurrentAppearanceImage(imageName: "zskimgedit_menu_crop_icon"))
        return btn
    }()
    lazy var mosaicButton: ZSKImageEditorButton = {
        let btn = ZSKImageEditorButton(buttonName: "马赛克", image: UIImage.loadCurrentAppearanceImage(imageName: "zskimgedit_menu_mosaic_icon"))
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(hex: "#141414")
        self.addSubview(rotateButton)
        self.addSubview(blackwhiteButton)
        self.addSubview(cropButton)
        self.addSubview(mosaicButton)
        rotateButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(12)
            make.height.equalTo(60)
        }
        blackwhiteButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(rotateButton.snp.right).offset(0)
            make.width.equalTo(rotateButton.snp.width)
            make.height.equalTo(60)
        }
        cropButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(blackwhiteButton.snp.right).offset(0)
            make.width.equalTo(rotateButton.snp.width)
            make.height.equalTo(60)
        }
        mosaicButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(cropButton.snp.right).offset(0)
            make.width.equalTo(rotateButton.snp.width)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(60)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
