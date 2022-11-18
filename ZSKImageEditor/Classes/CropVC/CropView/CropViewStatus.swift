//
//  CropViewStatus.swift
//  Mantis
//
//  Created by Echo on 10/26/18.
//  Copyright © 2018 Echo. All rights reserved.
//

import Foundation

enum CropViewStatus {
    case initial
    case rotating(angle: CGAngle)
    case degree90Rotating
    case touchImage
    case touchRotationBoard
    case touchCropboxHandle(tappedEdge: CropViewOverlayEdge = .none)
    case betweenOperation
}
