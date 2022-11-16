//
//  ZSKImageEditorMosaicEditView.swift
//  ZSKImageEditor
//
//  Created by 张少康 on 2022/11/16.
//

import UIKit

class ZSKImageEditorMosaicEditView: UIView {
    
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
        label.text = "图片编辑"
        return label
    }()
    
    lazy var smalllargeLabel: UILabel = {
        let label = UILabel()
        label.text = "大小"
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var slide: UISlider = {
        let sd = UISlider(frame: CGRect(x: 55, y: 0, width: UIScreen.main.bounds.width - 80, height: 50))
        sd.minimumValue = 5
        sd.maximumValue = 50
        sd.value = 20
        sd.minimumTrackTintColor = .white
        sd.maximumTrackTintColor = .init(hex: "#999999")
        sd.setThumbImage(UIImage.loadCurrentAppearanceImage(imageName: "thumb_image_icon"), for: .normal)
        sd.addTarget(self, action: #selector(slideValueChange(sender:)), for: .valueChanged)
        return sd
    }()
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    @objc func slideValueChange(sender: UISlider) {
        print(sender.value)
    }
    
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
        self.addSubview(topView)
        topView.backgroundColor = .black
        topView.snp.makeConstraints { make in
            make.left.right.top.equalTo(0)
            make.height.equalTo(50)
        }
        topView.addSubview(smalllargeLabel)
        topView.addSubview(slide)
        smalllargeLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

///马赛克操作图层

class ZSKImageEditorMosaicMaskView: UIView {

    private var imageLayer: CALayer?
    
    private var shapeLayer: CAShapeLayer?
    
    private var path: CGMutablePath?
    
    private var originalImage: UIImage!
    
    private var mosaicImage: UIImage!
    
    private var mosaicImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private var originalImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var context: CIContext = {
        return CIContext(options: nil)
    }()
    
    init(frame: CGRect, originalImage: UIImage) {
        super.init(frame: frame)
        backgroundColor = .clear
        self.originalImage = originalImage.copy() as! UIImage?
        self.addSubview(mosaicImageView)
        mosaicImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.addSubview(originalImageView)
        originalImageView.image = originalImage
        originalImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        getMosaicImage()
        
        imageLayer = CALayer()
        imageLayer?.frame = self.bounds
        
        shapeLayer = CAShapeLayer()
        shapeLayer?.frame = self.bounds
        shapeLayer?.lineCap = kCALineCapRound
        shapeLayer?.lineJoin = kCALineJoinRound
        shapeLayer?.lineWidth = 20
        shapeLayer?.strokeColor = UIColor.blue.cgColor
        shapeLayer?.fillColor = nil
        
        self.layer.addSublayer(self.shapeLayer!)
        self.imageLayer?.mask = self.shapeLayer
        
        let pathRef = CGMutablePath()
        path = pathRef.mutableCopy()
    }
    
    func getMosaicImage() {
        let filter = CIFilter(name: "CIPixellate")!
        let inputImage = CIImage(image: originalImage)
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(22, forKey: kCIInputScaleKey) //值越大马赛克就越大(使用默认)
        let fullPixellatedImage = filter.outputImage
         
        let cgImage = context.createCGImage(fullPixellatedImage!,
                                            from: fullPixellatedImage!.extent)
        mosaicImage = UIImage(cgImage: cgImage!)
        self.mosaicImageView.image = mosaicImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    

    func outputImage() -> UIImage? {
        var graffitiImage: UIImage? = nil
        var clippedImage: UIImage?
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            graffitiImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        // 合成原始图片与涂鸦图片
        UIGraphicsBeginImageContextWithOptions(originalImage.size, false, 1)
        originalImage.draw(at: .zero)
        graffitiImage?.draw(in: CGRect(origin: .zero, size: originalImage.size))
        clippedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return clippedImage
    }
}
