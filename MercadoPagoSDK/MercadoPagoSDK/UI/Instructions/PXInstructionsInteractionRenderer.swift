//
//  PXInstructionsInteractionRenderer.swift
//  MercadoPagoSDK
//
//  Created by Marcelo Oscar José on 25/10/2018.
//

import Foundation

class PXInstructionsInteractionRenderer: NSObject {
    let CONTENT_WIDTH_PERCENT: CGFloat = 100.0
    let TITLE_LABEL_FONT_SIZE: CGFloat = PXLayout.XXXS_FONT
    let TITLE_LABEL_FONT_COLOR: UIColor = .pxBrownishGray
    let INTERACTION_LABEL_FONT_SIZE: CGFloat = PXLayout.M_FONT
    let INTERACTION_LABEL_FONT_COLOR: UIColor = .pxBlack

    func render(_ instructionInteraction: PXInstructionsInteractionComponent) -> PXInstructionsInteractionView {
        let instructionInteractionView = PXInstructionsInteractionView()
        instructionInteractionView.translatesAutoresizingMaskIntoConstraints = false
        instructionInteractionView.backgroundColor = .pxLightGray
        var lastView: UIView?

        if let title = instructionInteraction.props.interaction?.title {
            let attributes = [NSAttributedStringKey.font: Utils.getFont(size: TITLE_LABEL_FONT_SIZE)]
            let attributedString = NSAttributedString(string: title, attributes: attributes)
            instructionInteractionView.titleLabel = buildLabel(with: attributedString, in: instructionInteractionView, onBottomOf: nil, isTitle: true)
            lastView = instructionInteractionView.titleLabel
        }

        if let referenceText = instructionInteraction.props.interaction?.getFullInteractionValue(), referenceText.isNotEmpty {
            let attributes = [NSAttributedStringKey.font: Utils.getFont(size: INTERACTION_LABEL_FONT_SIZE)]
            let attributedString = NSAttributedString(string: referenceText, attributes: attributes)
            instructionInteractionView.InteractionLabel = buildLabel(with: attributedString, in: instructionInteractionView, onBottomOf: lastView)
            lastView = instructionInteractionView.InteractionLabel
        }

        if lastView != nil {
            _ = instructionInteractionView.pinLastSubviewToBottom()
        }

        return instructionInteractionView
    }

    func buildLabel(with text: NSAttributedString, in superView: UIView, onBottomOf upperView: UIView?, isTitle: Bool = false) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.attributedText = text
        label.lineBreakMode = .byWordWrapping
        superView.addSubview(label)
        var textColor: UIColor = INTERACTION_LABEL_FONT_COLOR
        var textSize: CGFloat = INTERACTION_LABEL_FONT_SIZE
        if isTitle {
            textColor = TITLE_LABEL_FONT_COLOR
            textSize = TITLE_LABEL_FONT_SIZE
        }
        label.textColor = textColor

        let screenWidth = PXLayout.getScreenWidth(applyingMarginFactor: CONTENT_WIDTH_PERCENT)

        let height = UILabel.requiredHeight(forAttributedText: text, withFont: Utils.getFont(size: textSize), inWidth: screenWidth)
        PXLayout.setHeight(owner: label, height: height).isActive = true
        PXLayout.matchWidth(ofView: label, withPercentage: CONTENT_WIDTH_PERCENT).isActive = true
        PXLayout.centerHorizontally(view: label).isActive = true

        if let upperView = upperView {
            PXLayout.put(view: label, onBottomOf: upperView, withMargin: PXLayout.XXXS_MARGIN).isActive = true
        } else {
            PXLayout.pinTop(view: label, withMargin: PXLayout.ZERO_MARGIN).isActive = true
        }

        return label
    }
}

class PXInstructionsInteractionView: PXComponentView {
    public var titleLabel: UILabel?
    public var InteractionLabel: UILabel?
}
