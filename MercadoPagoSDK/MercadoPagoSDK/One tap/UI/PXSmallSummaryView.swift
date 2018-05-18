//
//  PXSmallSummaryView.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 17/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final class PXSmallSummaryView: PXComponentView {
    private var props: [PXSummaryRowProps] = [PXSummaryRowProps]()
    private var backColor: UIColor?
    private lazy var heightForAnimation: CGFloat = 0
    private var constraintForAnimation: NSLayoutConstraint?

    init(withProps: [PXSummaryRowProps], backgroundColor: UIColor?=nil) {
        super.init()
        props = withProps
        backColor = backgroundColor
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PXSmallSummaryView: PXComponentizable {
    func render() -> UIView {
        return UIView()
    }

    func oneTapRender() -> UIView {
        return oneTapLayout()
    }
}

extension PXSmallSummaryView {
    private func oneTapLayout() -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        var dynamicHeight: CGFloat = 0
        for prop in props {
            let newRowView = getRowComponentView(prop: prop)
            addSubviewToBottom(newRowView)
            PXLayout.pinLeft(view: newRowView).isActive = true
            PXLayout.pinRight(view: newRowView).isActive = true
            layoutIfNeeded()
            dynamicHeight = newRowView.frame.height > 0 ? newRowView.frame.height : dynamicHeight
        }
        backgroundColor = backColor
        layer.cornerRadius = 4
        layer.masksToBounds = true
        dynamicHeight *= CGFloat(props.count)
        heightForAnimation = dynamicHeight
        constraintForAnimation = PXLayout.setHeight(owner: self, height: dynamicHeight)
        constraintForAnimation?.isActive = true
        return self
    }

    private func getRowComponentView(prop: PXSummaryRowProps) -> UIView {
        return PXOneTapSummaryRowRenderer(withProps: prop).render()
    }
}

// MARK: Toggle expand/colapse support.
extension PXSmallSummaryView {
    func toggle() {
        if frame.height == 0 {
            expand()
        } else {
            colapse()
        }
    }

    private func expand() {
        let newFrame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: heightForAnimation)
        UIView.animate(withDuration: 0.5) { [weak self] in
            if let height = self?.heightForAnimation {
                self?.frame = newFrame
                self?.constraintForAnimation?.constant = height
            }
        }
    }

    private func colapse() {
        let newFrame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: 0)
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame = newFrame
        }) { _ in
            self.constraintForAnimation?.constant = 0
        }
    }
}
