//
//  ZSKImageEditorButton.swift
//  ZSKImageEditor
//
//  Created by 张少康 on 2022/11/16.
//

import UIKit

extension ZSKImageEditorButton {
    convenience init(buttonName: String, image: UIImage?) {
        self.init()
        self.buttonName = buttonName
        self.image = image
        updateSubviews()
    }
}

class ZSKImageEditorButton: UIControl {
    
    var buttonName: String = ""
    
    var image: UIImage?
    
    private func updateSubviews() {
        buttonNameLabel.text = buttonName
        imageView.image = image
    }

   private  lazy var imageView: UIImageView = {
        let iv = UIImageView()
       iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var buttonNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(imageView)
        self.addSubview(buttonNameLabel)
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(28)
            make.top.equalTo(10)
        }
        buttonNameLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalTo(imageView.snp.bottom).offset(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
