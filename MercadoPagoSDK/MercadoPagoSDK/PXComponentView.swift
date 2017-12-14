//
//  PXComponentView.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 12/13/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

public class PXComponentView: UIView {
    var topGuideView = UIView()
    var bottomGuideView = UIView()
    private var contentView = UIView()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.translatesAutoresizingMaskIntoConstraints = false
        topGuideView.translatesAutoresizingMaskIntoConstraints = false
        bottomGuideView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        super.addSubview(topGuideView)
        super.addSubview(bottomGuideView)
        super.addSubview(contentView)
        PXLayout.pinTop(view: topGuideView, to: self).isActive = true
        PXLayout.pinBottom(view: bottomGuideView, to: self).isActive = true
        PXLayout.equalizeHeight(view: topGuideView, to: bottomGuideView).isActive = true
        PXLayout.centerHorizontally(view: contentView, to: self).isActive = true
        PXLayout.put(view: contentView, onBottomOf: topGuideView).isActive = true
        PXLayout.put(view: contentView, aboveOf: bottomGuideView).isActive = true
        PXLayout.equalizeWidth(view: contentView, to: self).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func addSubview(_ view: UIView) {
        self.contentView.addSubview(view)
    }
    
    public func pinFirstSubviewToTop(view: UIView, withMargin margin: CGFloat = 0 ) -> NSLayoutConstraint? {
        guard let firstView = self.contentView.subviews.first else {
            return nil
        }
        return PXLayout.pinTop(view: firstView, to: self.contentView, withMargin: margin)
    }
    
    public func pinLastSubviewToBottom(withMargin margin: CGFloat = 0 ) -> NSLayoutConstraint? {
        guard let lastView = self.contentView.subviews.last else {
            return nil
        }
        
        return PXLayout.pinBottom(view: lastView, to: self.contentView, withMargin: margin)
    }
}
