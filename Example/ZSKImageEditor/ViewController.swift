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

class ViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("选择图片进行编辑", for: .normal)
        btn.setTitleColor(.systemPink, for: .normal)
        btn.addTarget(self, action: #selector(selectButtonAction), for: .touchUpInside)
        return btn
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
            make.center.equalToSuperview()
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
        DispatchQueue.main.async {
            let vc = ZSKImageEditorViewController(originalImage: originalImage)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

