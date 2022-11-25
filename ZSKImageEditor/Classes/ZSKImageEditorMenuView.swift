//
//  ZSKImageEditorMenuView.swift
//  ZSKImageEditor
//
//  Created by 张少康 on 2022/11/16.
//

import UIKit

extension ZSKImageEditorMenuView {
    convenience init(frame: CGRect, hasChangeBtn: Bool) {
        self.init(frame: frame)
        self.hasChangeBtn = hasChangeBtn
        createSubview()
    }
}

class ZSKImageEditorMenuView: UIView {
    
    private(set) var hasChangeBtn: Bool = false
    
    lazy var changeImageButton: ZSKImageEditorButton = {
        let btn = ZSKImageEditorButton(buttonName: "更换", image: UIImage.loadCurrentAppearanceImage(imageName: "zskimgedit_menu_change_icon"))
        return btn
    }()
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
    
    private func createSubview() {
        self.addSubview(rotateButton)
        self.addSubview(blackwhiteButton)
        self.addSubview(cropButton)
        self.addSubview(mosaicButton)
        if hasChangeBtn {
            self.addSubview(changeImageButton)
            changeImageButton.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalTo(12)
                make.height.equalTo(60)
            }
            rotateButton.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalTo(changeImageButton.snp.right).offset(0)
                make.width.equalTo(changeImageButton.snp.width)
                make.height.equalTo(60)
            }
        }else {
            rotateButton.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalTo(12)
                make.height.equalTo(60)
            }
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(hex: "#141414")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
