//
//  ZSKImageEditorViewController.swift
//  ZSKImageEditor
//
//  Created by 张少康 on 2022/11/16.
//

import UIKit
import PhotosUI

@objc public protocol ZSKImageEditorViewDelegate: AnyObject {
    @objc func zskImageEdit(editor vc: ZSKImageEditorViewController, finish editImage: UIImage?)
}

extension ZSKImageEditorViewController {
    public convenience init(originalImage: UIImage,hasChangeBtn: Bool = false) {
        self.init()
        self.hasChangeBtn = hasChangeBtn
        self.originalImage = originalImage.zsk_fixOrientation()
    }
}

open class ZSKImageEditorViewController: UIViewController {
    //是否有更换图片的按钮
    var hasChangeBtn: Bool = false
    //原始图片
    var originalImage: UIImage!
    //导航view
    let navView = ZSKImageEditorNavView()
    private var scrollview: UIScrollView = UIScrollView()
    private var imageView: UIImageView?
    private var menuView: ZSKImageEditorMenuView?
    
    //旋转按钮
    lazy var rotateButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.loadCurrentAppearanceImage(imageName: "zskimgedit_menu_rotate_icon"), for: .normal)
        btn.addTarget(self, action: #selector(rotateImageAction), for: .touchUpInside)
        return btn
    }()
    
    private var editEnable: Bool = false {
        didSet {
            navView.finishButton.isHidden = editEnable
        }
    }
    private var historyArray: [UIImage] = []
    open weak var delegate: ZSKImageEditorViewDelegate?
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.view.addSubview(navView)
        navView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(44 + safeAreaTop())
        }
        navView.backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        navView.finishButton.addTarget(self, action: #selector(finishButtonAction), for: .touchUpInside)
        scrollview.frame = CGRect(x: 0, y: safeAreaTop() + 44, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - safeAreaBottom() - safeAreaTop() - 72 - 44)
        self.view.addSubview(scrollview)
        if imageView == nil {
            imageView = UIImageView()
            imageView!.contentMode = .scaleAspectFit
            scrollview.addSubview(imageView!)
            refreshImageView()
            historyArray.append(originalImage)
        }
        createMenuView()
        createRotateButton()
    }
    
    private func createRotateButton() {
        view.addSubview(rotateButton)
        rotateButton.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.bottom.equalTo(-safeAreaBottom() - 70)
            make.width.height.equalTo(40)
        }
        rotateButton.isHidden = true
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        print("没有获取到图片 viewWillAppear")
        if let window = UIApplication.shared.keyWindow {
            if menuView!.blackwhiteButton.isSelected {
                if !UIView.hasGreyFilterToView(view: window) {
                    UIView.addGreyFilterToView(view: window,rect: CGRect(x: 0, y: safeAreaTop() + 44, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - safeAreaTop() - 44 ))
                }else {
                    UIView.changeGreyFilterViewRect(view: window, rect:CGRect(x: 0, y: safeAreaTop() + 44, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - safeAreaTop() - 44 ))
                }
            }
        }
    }
    
    
    @objc func backButtonAction() {
        if let window = UIApplication.shared.keyWindow {
            UIView.removeGreyFilterToView(view: window)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func finishButtonAction() {
        if let window = UIApplication.shared.keyWindow {
            UIView.removeGreyFilterToView(view: window)
        }
        
        let currentImage = imageView?.screenshotImage()
        var originalImage = currentImage
        if menuView!.blackwhiteButton.isSelected {
            let ciImage = CIImage(image: currentImage!)
            let fiter = CIFilter(name: "CIPhotoEffectNoir")
            fiter?.setValue(ciImage, forKey: kCIInputImageKey)
            let context = CIContext(options: nil)
            let outPutImage = fiter?.outputImage
            let outPutCgImage = context.createCGImage(outPutImage!, from: outPutImage!.extent)
            originalImage = UIImage(cgImage: outPutCgImage!)
        }
        
        if delegate != nil {
            delegate?.zskImageEdit(editor: self, finish: originalImage)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func createMenuView() {
        menuView = ZSKImageEditorMenuView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - safeAreaBottom() - 60, width: UIScreen.main.bounds.width, height: 60 + safeAreaBottom()), hasChangeBtn: hasChangeBtn)
        menuView?.rotateButton.addTarget(self, action: #selector(rotateButtonAction), for: .touchUpInside)
        menuView?.mosaicButton.addTarget(self, action: #selector(mosaicButtonAction), for: .touchUpInside)
        menuView?.cropButton.addTarget(self, action: #selector(cropButtonAction), for: .touchUpInside)
        menuView?.blackwhiteButton.addTarget(self, action: #selector(blackwhiteButtonAction), for: .touchUpInside)
        menuView?.changeImageButton.addTarget(self, action: #selector(changeImageButtonAction), for: .touchUpInside)
        self.view.addSubview(menuView!)
    }
    
    private func refreshImageView() {
        imageView!.image = originalImage
        resetImageViewFrame()
    }
    
    //重置imageview的位置
    private func resetImageViewFrame() {
        let size = (imageView!.image != nil) ? imageView!.image!.size : imageView!.frame.size
        if size.width > 0 && size.height > 0 {
            let ratio = min(scrollview.frame.size.width/size.width, scrollview.frame.size.height/size.height)
            let w = ratio * size.width * scrollview.zoomScale
            let h = ratio * size.height * scrollview.zoomScale
            imageView!.frame = CGRect(x: max(0,(scrollview.frame.size.width-w)/2), y: max(0,(scrollview.frame.size.height-h)/2), width: w, height: h)
        }
    }
    
    deinit {
        print("ZSKImageEditorViewController deinit" )
        if let window = UIApplication.shared.keyWindow {
            UIView.removeGreyFilterToView(view: window)
        }
    }
}

extension ZSKImageEditorViewController {
    
    @objc func rotateImageAction() {
        let currentImage = self.imageView?.image
        let newImage = currentImage?.rotate(radians: -CGFloat.pi/2)
        self.historyArray.append(newImage!)
        self.imageView?.image = newImage
        self.resetImageViewFrame()
    }
    
    @objc public func rotateButtonAction() {
        rotateButton.isHidden = false
        menuView?.isUserInteractionEnabled = false
        view.bringSubviewToFront(rotateButton)
        let oldImage = historyArray.last?.copy()
        let rotateView = ZSKImageEditorRotateEditView()
        rotateView.finishBlock = { [weak self] in
            guard let `self` = self else {return}
            self.rotateButton.isHidden = true
            self.menuView?.isUserInteractionEnabled = true
        }
        
        rotateView.closeBlock = { [weak self] in
            guard let `self` = self else {return}
            self.rotateButton.isHidden = true
            self.imageView?.image = oldImage as? UIImage
            self.resetImageViewFrame()
            self.menuView?.isUserInteractionEnabled = true
        }
        
        view.addSubview(rotateView)
        rotateView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.height.equalTo(safeAreaBottom() + 60)
            make.top.equalTo(UIScreen.main.bounds.height)
        }
        
        UIView.animate(withDuration: 0.25) { [weak rotateView] in
            rotateView?.transform3D = CATransform3DMakeTranslation(0, -(safeAreaBottom() + 60), 0)
        }
        
    }   
    
    @objc public func mosaicButtonAction() {
        self.editEnable = true
        //获取马赛开图片
        func getMosaicImage(currentImage: UIImage) -> UIImage {
            let rotateImage = currentImage
            let filter = CIFilter(name: "CIPixellate")!
            let inputImage = CIImage(image: rotateImage)
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            filter.setValue(22, forKey: kCIInputScaleKey) //值越大马赛克就越大(使用默认)
            let fullPixellatedImage: CIImage = filter.value(forKey: kCIOutputImageKey) as! CIImage
            let context = CIContext(options: nil)
            let cgImage = context.createCGImage(fullPixellatedImage, from: fullPixellatedImage.extent)
            let image = UIImage(cgImage: cgImage!)
            return image
        }
        //之所以使用截屏的方式获取图片，是因为某些图片生成马赛克图片后旋转尺寸不对。
        let currentImage = imageView?.image
        let rect = self.imageView!.layer.convert(self.imageView!.bounds, to: self.view.layer)
        let mosaicMaskView = ZSKImageEditorMosaicMaskView(frame: rect, originalImage: currentImage!,image: getMosaicImage(currentImage: currentImage! ))
        view.addSubview(mosaicMaskView)
        
        let mosaicView = ZSKImageEditorMosaicEditView()
        mosaicView.lineWidthBlock = { [weak mosaicMaskView] lineWidth in
            mosaicMaskView?.updateCircleViewFrame(radius: lineWidth)
        }
        mosaicView.didselectWidthBlock  = { [weak mosaicMaskView] in
            mosaicMaskView?.updateCircleViewFrame(radius: 0.0, endSet: true)
        }
        mosaicView.closeBlock = { [weak self] in
            self?.editEnable = false
            mosaicMaskView.removeFromSuperview()
        }
        mosaicView.finishBlock = { [weak self] in
            self?.editEnable = false
            if let image = mosaicMaskView.buildImage() {
                self?.historyArray.append(image)
                self?.imageView?.image = image
                self?.resetImageViewFrame()
            }
            mosaicMaskView.removeFromSuperview()
        }
        view.addSubview(mosaicView)
        mosaicView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.height.equalTo(safeAreaBottom() + 60 + 50)
            make.top.equalTo(UIScreen.main.bounds.height)
        }
        UIView.animate(withDuration: 0.25) { [weak mosaicView] in
            mosaicView?.transform3D = CATransform3DMakeTranslation(0, -(safeAreaBottom() + 60 + 50), 0)
        }
      
    }
    
    @objc func cropButtonAction() {
        if let window = UIApplication.shared.keyWindow {
            UIView.changeGreyFilterViewRect(view: window, rect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - safeAreaTop()))
        }
        let image = imageView?.image
        var config = Config()
        config.cropMode = .async
        config.cropToolbarConfig.toolbarButtonOptions = [.clockwiseRotate]
        let cropVC = CropViewController(image: image!,
                                        config: config)
        cropVC.modalPresentationStyle = .fullScreen
        cropVC.delegate = self
//        cropVC.config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 16.0 / 9.0)
        self.present(cropVC, animated: false)
    }
    
    @objc func blackwhiteButtonAction() {
        menuView?.blackwhiteButton.isSelected.toggle()
        if let window = UIApplication.shared.keyWindow {
            if menuView!.blackwhiteButton.isSelected {
                UIView.addGreyFilterToView(view: window,rect: CGRect(x: 0, y: safeAreaTop() + 44, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - safeAreaTop() - 44))
            }else {
                UIView.removeGreyFilterToView(view: window)
            }
        }
    }
    
    @objc func changeImageButtonAction() {
        requestAuthorization()
    }
}

extension ZSKImageEditorViewController: CropViewControllerDelegate {
    public func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        self.dismiss(animated: false)
    }
    
    
    public func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation, cropInfo: CropInfo) {
        historyArray.append(cropped)
        imageView?.image = cropped
        resetImageViewFrame()
        self.dismiss(animated: false)
    }
}

extension ZSKImageEditorViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
//        self.menuView?.blackwhiteButton.isSelected = false
        if let window = UIApplication.shared.keyWindow {
            UIView.removeGreyFilterToView(view: window)
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.modalPresentationStyle = .overFullScreen
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
        }
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        picker.dismiss(animated: true, completion: nil)
        print("获取的图片info:\(info)")
        self.menuView?.blackwhiteButton.isSelected = false
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("获取到新的图片")
            let image = originalImage.zsk_fixOrientation()
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else {return}
                self.historyArray.append(image)
                self.imageView?.image = image
                self.resetImageViewFrame()
            }
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("没有获取到图片 重新添加蒙层")
        self.dismiss(animated: true)
        if let window = UIApplication.shared.keyWindow {
            if menuView!.blackwhiteButton.isSelected {
                if !UIView.hasGreyFilterToView(view: window) {
                    UIView.addGreyFilterToView(view: window,rect: CGRect(x: 0, y: safeAreaTop() + 44, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - safeAreaTop() - 44 ))
                }else {
                    UIView.changeGreyFilterViewRect(view: window, rect:CGRect(x: 0, y: safeAreaTop() + 44, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - safeAreaTop() - 44 ))
                }
            }
        }
    }
    
}

class ZSKImageEditorNavView: UIView {
    //返回按钮
    lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.loadCurrentAppearanceImage(imageName: "zskeditor_back_icon"), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    //完成按钮
    lazy var finishButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("完成", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        return btn
    }()
    //标题
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = "图片编辑"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(backButton)
        self.addSubview(finishButton)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        backButton.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(44)
        }
        finishButton.snp.makeConstraints { make in
            make.right.equalTo(0)
            make.width.equalTo(50)
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
