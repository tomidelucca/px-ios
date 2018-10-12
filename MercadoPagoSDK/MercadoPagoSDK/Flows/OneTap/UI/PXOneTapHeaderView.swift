//
//  PXOneTapHeaderView.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/10/18.
//

import UIKit

typealias OneTapHeaderSummaryData = (title: String, value: String, highlightedColor: UIColor, isTotal: Bool)

class PXOneTapHeaderViewModel {
    let icon: UIImage
    let title: String
    let data: [OneTapHeaderSummaryData]

    init(icon: UIImage, title: String, data: [OneTapHeaderSummaryData]) {
        self.icon = icon
        self.title = title
        self.data = data
    }
}

class PXOneTapHeaderView: PXComponentView {
    var model: PXOneTapHeaderViewModel? {
        didSet {
            render()
        }
    }

    func render() {
        guard let model = model else {return}
        self.removeAllSubviews()

        self.backgroundColor = ThemeManager.shared.highlightBackgroundColor()
        self.layer.borderWidth = 1

        PXLayout.setHeight(owner: self, height: PXLayout.getScreenHeight(applyingMarginFactor: 40)).isActive = true
        PXLayout.setHeight(owner: self.getContentView(), height: PXLayout.getScreenHeight(applyingMarginFactor: 40)).isActive = true

        let summaryView = PXComponentView()
        summaryView.pinContentViewToBottom()

        for row in model.data {
            let margin: CGFloat = row.isTotal ? PXLayout.S_MARGIN : PXLayout.XXS_MARGIN
            let rowView = getSummaryRowView(with: row)

            if row.isTotal {
                let separatorView = UIView()
                separatorView.backgroundColor = ThemeManager.shared.greyColor()
                separatorView.translatesAutoresizingMaskIntoConstraints = false
                summaryView.addSubviewToBottom(separatorView, withMargin: margin)
                PXLayout.setHeight(owner: separatorView, height: 1).isActive = true
                PXLayout.pinLeft(view: separatorView, withMargin: PXLayout.M_MARGIN).isActive = true
                PXLayout.pinRight(view: separatorView, withMargin: PXLayout.M_MARGIN).isActive = true
            }

            summaryView.addSubviewToBottom(rowView, withMargin: margin)
            PXLayout.centerHorizontally(view: rowView).isActive = true
            PXLayout.pinLeft(view: rowView, withMargin: 0).isActive = true
            PXLayout.pinRight(view: rowView, withMargin: 0).isActive = true
        }

        self.addSubview(summaryView)
        summaryView.pinLastSubviewToBottom(withMargin: PXLayout.S_MARGIN)?.isActive = true
        PXLayout.matchWidth(ofView: summaryView).isActive = true
        PXLayout.pinBottom(view: summaryView).isActive = true

        let merchantView = PXOneTapHeaderMerchantView(image: model.icon, title: model.title)
        self.addSubview(merchantView)
        PXLayout.pinTop(view: merchantView).isActive = true
        PXLayout.put(view: merchantView, aboveOf: summaryView).isActive = true
        PXLayout.centerHorizontally(view: merchantView).isActive = true
        PXLayout.matchWidth(ofView: merchantView).isActive = true
    }

    func getSummaryRowView(with data: OneTapHeaderSummaryData) -> UIView {
        let rowHeight: CGFloat = data.isTotal ? 20 : 16
        let titleFont = data.isTotal ? Utils.getFont(size: PXLayout.S_FONT) : Utils.getFont(size: PXLayout.XXS_FONT)
        let valueFont = data.isTotal ? Utils.getSemiBoldFont(size: PXLayout.S_FONT) : Utils.getFont(size: PXLayout.XXS_FONT)

        let rowView = UIView()
        rowView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = data.title
        titleLabel.textAlignment = .left
        titleLabel.font = titleFont
        titleLabel.textColor = data.highlightedColor
        rowView.addSubview(titleLabel)
        PXLayout.pinLeft(view: titleLabel, withMargin: PXLayout.M_MARGIN).isActive = true
        PXLayout.centerVertically(view: titleLabel).isActive = true

        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.text = data.value
        valueLabel.textAlignment = .right
        valueLabel.font = valueFont
        valueLabel.textColor = data.highlightedColor
        rowView.addSubview(valueLabel)
        PXLayout.pinRight(view: valueLabel, withMargin: PXLayout.M_MARGIN).isActive = true
        PXLayout.centerVertically(view: valueLabel).isActive = true

        PXLayout.setHeight(owner: rowView, height: rowHeight).isActive = true

        return rowView
    }
}
