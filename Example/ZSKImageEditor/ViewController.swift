//
//  ViewController.swift
//  ZSKImageEditor
//
//  Created by 张少康 on 11/16/2022.
//  Copyright (c) 2022 张少康. All rights reserved.
//

import UIKit
import SnapKit
import PhotosUI
import ZSKImageEditor

class ViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate, ZSKImageEditorViewDelegate {
    
    func zskImageEdit(editor vc: ZSKImageEditor.ZSKImageEditorViewController, finish editImage: UIImage?) {
        self.imageView.image = editImage
    }
    
    
    lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("选择图片进行编辑", for: .normal)
        btn.setTitleColor(.systemPink, for: .normal)
        btn.addTarget(self, action: #selector(selectButtonAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        return iv
    }()
    
    @objc func selectButtonAction() {
        requestAuthorization()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(150)
        }
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 60)
            make.height.equalTo(UIScreen.main.bounds.height - 200)
            make.top.equalTo(backButton.snp.bottom).offset(15)
        }
    }
    
    func requestAuthorization() {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { result in
                DispatchQueue.main.async {
                    self.showImagePickerView()
                }
            }
        } else {
            
        }
    }
    
    func showImagePickerView() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
        }
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        picker.dismiss(animated: true, completion: nil)
        print("获取的图片info:\(info)")
        let originalImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else {return}
            let vc = ZSKImageEditorViewController(originalImage: originalImage)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

