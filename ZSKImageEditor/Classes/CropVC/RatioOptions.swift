//
//  RatioOptions.swift
//  Mantis
//
//  Created by Echo on 8/8/19.
//

import Foundation

public struct RatioOptions: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    static public let original = RatioOptions(rawValue: 1 << 0)
    static public let square = RatioOptions(rawValue: 1 << 1)
    static public let extraDefaultRatios = RatioOptions(rawValue: 1 << 2)
    static public let custom = RatioOptions(rawValue: 1 << 3)
    
    static public let all: RatioOptions = [original, square, extraDefaultRatios, custom]
}

public struct Config {
    
    public enum CropMode {
        case sync
        case async // We may need this mode when cropping big images
    }
    
    public var cropMode: CropMode = .sync
    
    public var cropViewConfig = CropViewConfig()
    public var cropToolbarConfig: CropToolbarConfigProtocol = CropToolbarConfig()
    
    public var ratioOptions: RatioOptions = .all
    public var presetFixedRatioType: PresetFixedRatioType = .canUseMultiplePresetFixedRatio()
    public var showAttachedCropToolbar = true
        
    var customRatios: [(width: Int, height: Int)] = []

    static private var bundleIdentifier: String = {
        return "com.echo.framework.Mantis"
    }()

    static private(set) var bundle: Bundle? = {
        guard let bundle = Bundle(identifier: bundleIdentifier) else {
            return nil
        }

        if let url = bundle.url(forResource: "MantisResources", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return bundle
        }
        return nil
    }()

    public init() {}

    mutating public func addCustomRatio(byHorizontalWidth width: Int, andHorizontalHeight height: Int) {
        customRatios.append((width, height))
    }

    mutating public func addCustomRatio(byVerticalWidth width: Int, andVerticalHeight height: Int) {
        customRatios.append((height, width))
    }

    func hasCustomRatios() -> Bool {
        return !customRatios.isEmpty
    }

    func getCustomRatioItems() -> [RatioItemType] {
        return customRatios.map {
            (String("\($0.width):\($0.height)"), Double($0.width)/Double($0.height),
             String("\($0.height):\($0.width)"), Double($0.height)/Double($0.width))
        }
    }
}
