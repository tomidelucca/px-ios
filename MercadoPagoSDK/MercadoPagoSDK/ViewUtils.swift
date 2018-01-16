//
//  ViewUtil.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 21/4/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import Foundation
import UIKit

class ViewUtils {

    class func getTableCellSeparatorLineView(_ x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIView {
        let separatorLineView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        separatorLineView.layer.zPosition = 1
        separatorLineView.backgroundColor = UIColor.grayTableSeparator()
        return separatorLineView
    }

    class func addStatusBar(_ view: UIView, color: UIColor) {
        
        var defaultHeight: CGFloat = 20
        
        // iPhoneX or any device with safe area inset > 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topSafeAreaPadding = window?.safeAreaInsets.top
            if let topSafeAreaDeltaValue = topSafeAreaPadding, topSafeAreaDeltaValue > 0 {
                defaultHeight = topSafeAreaDeltaValue
            }
        }
        let addStatusBar = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: defaultHeight))
        addStatusBar.backgroundColor = color
        view.addSubview(addStatusBar)
    }

    class func addScaledImage(_ image: UIImage, inView view: UIView) {
        let imageView = UIImageView()
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        view.addSubview(imageView)
    }

    class func loadImageFromUrl(_ url: String, inView: UIView, loadingBackgroundColor: UIColor = UIColor.primaryColor(), loadingIndicatorColor: UIColor = UIColor.white) {
  //      LoadingOverlay.shared.showOverlay(inView, backgroundColor: loadingBackgroundColor, indicatorColor: loadingIndicatorColor)
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
            let url = URL(string: url)
            if url != nil {
                let data = try? Data(contentsOf: url!)
                if data != nil {
                    DispatchQueue.main.async(execute: {
                        let image = UIImage(data: data!)
                        if image != nil {
                            ViewUtils.addScaledImage(image!, inView: inView)
                        }
                        })

                }
            }
            LoadingOverlay.shared.hideOverlayView()
        })
    }

    class func loadImageFromUrl(_ url: String) -> UIImage? {

            let url = URL(string: url)
            if url != nil {
                let data = try? Data(contentsOf: url!)
                if data != nil {
                        let image = UIImage(data: data!)
                        return image
                    } else {
                    return nil
                }
            } else {
                return nil
        }
    }

    func getSeparatorLineForTop(width: Double, y: Float) -> UIView {
        let lineFrame = CGRect(origin: CGPoint(x: 0, y :Int(y)), size: CGSize(width: width, height: 0.5))
        let line = UIView(frame: lineFrame)
        line.alpha = 0.6
        line.backgroundColor = UIColor.px_grayLight()
        return line
    }

    class func drawBottomLine(_ x: CGFloat = 0, y: CGFloat, width: CGFloat, inView view: UIView) {
        let overLinewView = UIView(frame: CGRect(x: x, y: y, width: width, height: 1))
        overLinewView.backgroundColor = UIColor.UIColorFromRGB(0xDEDEDE)
        view.addSubview(overLinewView)
    }

}
