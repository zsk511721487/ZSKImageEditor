//
//  ZSKImageEditorRotateEditView.swift
//  ZSKImageEditor
//
//  Created by 张少康 on 2022/11/30.
//

import UIKit

class ZSKImageEditorRotateEditView: UIView {
    var closeBlock: (()->Void)?
    var finishBlock: (()->Void)?
    lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.loadCurrentAppearanceImage(imageName: "zskimgedit_menu_close_icon"), for: .normal)
        btn.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        return btn
    }()
    lazy var finishButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.loadCurrentAppearanceImage(imageName: "zskimgedit_menu_finish_icon"), for: .normal)
        btn.addTarget(self, action: #selector(finishButtonAction), for: .touchUpInside)
        return btn
    }()
    
    //标题
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = "图片旋转"
        return label
    }()
    
    @objc func closeButtonAction() {
        if closeBlock != nil {
            closeBlock!()
        }
        UIView.animate(withDuration: 0.25) {
            self.transform3D = CATransform3DIdentity
        } completion: { isComplete in
            if isComplete {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc func finishButtonAction() {
        if finishBlock != nil {
            finishBlock!()
        }
        UIView.animate(withDuration: 0.25) {
            self.transform3D = CATransform3DIdentity
        } completion: { isComplete in
            if isComplete {
                self.removeFromSuperview()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(hex: "#141414")
        self.addSubview(closeButton)
        self.addSubview(finishButton)
        self.addSubview(titleLabel)
        closeButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(-safeAreaBottom())
            make.height.equalTo(60)
            make.width.equalTo(50)
        }
        
        finishButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalTo(-safeAreaBottom())
            make.height.equalTo(60)
            make.width.equalTo(50)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeButton.snp.centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

