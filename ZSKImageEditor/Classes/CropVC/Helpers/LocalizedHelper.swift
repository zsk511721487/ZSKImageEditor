//
//  LocalizedHelper.swift
//  Mantis
//
//  Created by Echo on 11/13/18.
//  Copyright © 2018 Echo. All rights reserved.
//

import Foundation

struct LocalizedHelper {
    private static var bundle: Bundle?
        
    static func setBundle(_ bundle: Bundle) {
        guard let resourceBundleURL = bundle.url(
            forResource: "MantisResources", withExtension: "bundle")
            else { return }
        LocalizedHelper.bundle = Bundle(url: resourceBundleURL)
    }
}
