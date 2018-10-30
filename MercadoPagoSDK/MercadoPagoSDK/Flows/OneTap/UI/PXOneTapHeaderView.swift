//
//  PXOneTapHeaderView.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/10/18.
//

import UIKit

typealias OneTapHeaderSummaryData = (title: String, value: String, highlightedColor: UIColor, isTotal: Bool)

protocol PXOneTapHeaderProtocol: NSObjectProtocol {
    func didTapSummary()
}

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
    let model: PXOneTapHeaderViewModel
    private weak var delegate: PXOneTapHeaderProtocol?

    init(viewModel: PXOneTapHeaderViewModel, delegate: PXOneTapHeaderProtocol?) {
        self.model = viewModel
        self.delegate = delegate
        super.init()
        self.render()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func render() {
        removeAllSubviews()
        backgroundColor = ThemeManager.shared.highlightBackgroundColor()
        let summaryView = PXComponentView()
        summaryView.pinContentViewToBottom()

        for row in model.data {
            let margin: CGFloat = row.isTotal ? PXLayout.S_MARGIN : PXLayout.XXS_MARGIN
            let rowView = getSummaryRowView(with: row)

            if row.isTotal {
                let separatorView = UIView()
                separatorView.backgroundColor = ThemeManager.shared.boldLabelTintColor()
                separatorView.alpha = 0.1
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

        addSubview(summaryView)
        summaryView.pinLastSubviewToBottom(withMargin: PXLayout.S_MARGIN)?.isActive = true
        PXLayout.matchWidth(ofView: summaryView).isActive = true
        PXLayout.pinBottom(view: summaryView).isActive = true

        let showHorizontally = UIDevice.isSmallDevice() && model.data.count != 1 && !model.data[0].isTotal
        let merchantView = PXOneTapHeaderMerchantView(image: model.icon, title: model.title, showHorizontally: showHorizontally)
        self.addSubview(merchantView)

        if showHorizontally {
            PXLayout.pinTop(view: merchantView, withMargin: -PXLayout.XXL_MARGIN).isActive = true
            PXLayout.put(view: merchantView, aboveOf: summaryView, withMargin: -PXLayout.M_MARGIN).isActive = true
            PXLayout.centerHorizontally(view: merchantView).isActive = true
            PXLayout.matchWidth(ofView: merchantView).isActive = true
        } else {
            PXLayout.pinTop(view: merchantView).isActive = true
            PXLayout.put(view: merchantView, aboveOf: summaryView).isActive = true
            PXLayout.centerHorizontally(view: merchantView).isActive = true
            PXLayout.matchWidth(ofView: merchantView).isActive = true
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSummaryTap))
        summaryView.addGestureRecognizer(tapGesture)
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

    @objc func handleSummaryTap() {
        delegate?.didTapSummary()
    }
}
