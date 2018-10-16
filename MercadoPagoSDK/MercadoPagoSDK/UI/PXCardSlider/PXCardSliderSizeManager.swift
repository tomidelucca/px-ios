//
//  PXCardSliderSizeManager.swift
//
//  Created by Juan sebastian Sanzone on 12/10/18.
//

import UIKit

struct PXCardSliderSizeManager {
    static func getItemSize() -> CGSize {
        if UIDevice.isSmallDevice() {
            return CGSize(width: 290, height: 190)
        } else if UIDevice.isBigDevice() {
            return CGSize(width: 340, height: 220)
        } else {
            return CGSize(width: 340, height: 220)
        }
    }

    static func getItemContainerSize() -> CGSize {
        return CGSize(width: getItemSize().width - 20, height: getItemSize().height - 20)
    }

    static func getSliderSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: getItemSize().height)
    }
}
