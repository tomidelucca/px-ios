//
//  PXOneTapHeaderView.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/10/18.
//

import UIKit

class PxOneTapSummaryRowView: UIView {

    let data: OneTapHeaderSummaryData

    init(data: OneTapHeaderSummaryData) {
        self.data = data
        super.init(frame: CGRect.zero)
        render()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func render() {
        let rowHeight: CGFloat = data.isTotal ? 20 : 16
        let titleFont = data.isTotal ? Utils.getFont(size: PXLayout.S_FONT) : Utils.getFont(size: PXLayout.XXS_FONT)
        let valueFont = data.isTotal ? Utils.getSemiBoldFont(size: PXLayout.S_FONT) : Utils.getFont(size: PXLayout.XXS_FONT)
        let shouldAnimate = data.isTotal ? false : true

        self.translatesAutoresizingMaskIntoConstraints = false
        self.pxShouldAnimatedOneTapRow = shouldAnimate

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = data.title
        titleLabel.textAlignment = .left
        titleLabel.font = titleFont
        titleLabel.textColor = data.highlightedColor
        titleLabel.alpha = data.alpha
        self.addSubview(titleLabel)
        PXLayout.pinLeft(view: titleLabel, withMargin: PXLayout.L_MARGIN).isActive = true
        PXLayout.centerVertically(view: titleLabel).isActive = true

        if let rightImage = data.image {
            let imageView: UIImageView = UIImageView()
            let imageSize: CGFloat = 16
            imageView.image = rightImage
            imageView.contentMode = .scaleAspectFit
            self.addSubview(imageView)
            PXLayout.setWidth(owner: imageView, width: imageSize).isActive = true
            PXLayout.setHeight(owner: imageView, height: imageSize).isActive = true
            PXLayout.centerVertically(view: imageView, to: titleLabel).isActive = true
            PXLayout.put(view: imageView, rightOf: titleLabel, withMargin: PXLayout.XXXS_MARGIN).isActive = true
        }

        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.text = data.value
        valueLabel.textAlignment = .right
        valueLabel.font = valueFont
        valueLabel.textColor = data.highlightedColor
        valueLabel.alpha = data.alpha
        self.addSubview(valueLabel)
        PXLayout.pinRight(view: valueLabel, withMargin: PXLayout.L_MARGIN).isActive = true
        PXLayout.centerVertically(view: valueLabel).isActive = true

        PXLayout.setHeight(owner: self, height: rowHeight).isActive = true
    }
}

class PxOneTapSummaryView: PXComponentView {
    private var data: [OneTapHeaderSummaryData] = []

    init(data: [OneTapHeaderSummaryData] = []) {
        self.data = data
        super.init()
        render()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render() {
        self.removeAllSubviews()
        self.pinContentViewToBottom()
        self.backgroundColor = ThemeManager.shared.navigationBar().backgroundColor

        for row in self.data {
            let margin: CGFloat = row.isTotal ? PXLayout.S_MARGIN : PXLayout.XXS_MARGIN
            let rowView = self.getSummaryRowView(with: row)

            if row.isTotal {
                let separatorView = UIView()
                separatorView.backgroundColor = ThemeManager.shared.boldLabelTintColor()
                separatorView.alpha = 0.1
                separatorView.translatesAutoresizingMaskIntoConstraints = false
                self.addSubviewToBottom(separatorView, withMargin: margin)
                PXLayout.setHeight(owner: separatorView, height: 1).isActive = true
                PXLayout.pinLeft(view: separatorView, withMargin: PXLayout.M_MARGIN).isActive = true
                PXLayout.pinRight(view: separatorView, withMargin: PXLayout.M_MARGIN).isActive = true
            }

            self.addSubviewToBottom(rowView, withMargin: margin)

            PXLayout.centerHorizontally(view: rowView).isActive = true
            PXLayout.pinLeft(view: rowView, withMargin: 0).isActive = true
            PXLayout.pinRight(view: rowView, withMargin: 0).isActive = true
        }

        self.pinLastSubviewToBottom(withMargin: PXLayout.S_MARGIN)?.isActive = true
    }

    func update(_ newData: [OneTapHeaderSummaryData], hideAnimatedView: Bool = false) {
        self.data = newData
        self.render()
        if hideAnimatedView {
            self.hideAnimatedViews()
        }
    }

    func hideAnimatedViews() {
        for view in self.getSubviews() {
            if view.pxShouldAnimatedOneTapRow {
                view.isHidden = true
            }
        }
    }

    func showAnimatedViews() {
        for view in self.getSubviews() {
            if view.pxShouldAnimatedOneTapRow {
                view.isHidden = false
            }
        }
    }

    func getSummaryRowView(with data: OneTapHeaderSummaryData) -> UIView {
        let rowView = PxOneTapSummaryRowView(data: data)
        return rowView
    }
}

class PXOneTapHeaderView: PXComponentView {
    private var model: PXOneTapHeaderViewModel {
        willSet(newModel) {
            updateLayout(newModel: newModel, oldModel: model)
        }
    }

    private weak var delegate: PXOneTapHeaderProtocol?
    private var merchantView: PXOneTapHeaderMerchantView?
    private var isShowingHorizontally: Bool = false
    private var verticalLayoutConstraints: [NSLayoutConstraint] = []
    private var horizontalLayoutConstraints: [NSLayoutConstraint] = []
    private var niceSummary: PxOneTapSummaryView?

    init(viewModel: PXOneTapHeaderViewModel, delegate: PXOneTapHeaderProtocol?) {
        self.model = viewModel
        self.delegate = delegate
        super.init()
        self.render()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateModel(_ model: PXOneTapHeaderViewModel) {
        self.model = model
    }
}

// MARK: Privates.
extension PXOneTapHeaderView {

    private func shouldShowHorizontally(data: [OneTapHeaderSummaryData]) -> Bool {
        return UIDevice.isSmallDevice() && data.count != 1 && !data[0].isTotal
    }

    private func updateLayout(newModel: PXOneTapHeaderViewModel, oldModel: PXOneTapHeaderViewModel) {
        let animationDuration = 0.5
        let shouldShowHorizontally = self.shouldShowHorizontally(data: newModel.data)
        let shouldAnimateSummary = newModel.data.count != oldModel.data.count
        let shouldHideSummary = newModel.data.count < oldModel.data.count

        if shouldShowHorizontally, isShowingHorizontally {
            print("")
            //update hard
        } else if shouldShowHorizontally, !isShowingHorizontally {
            print("")
            self.animateToHorizontal(duration: animationDuration)
            //animate to horizontal
        } else if !shouldShowHorizontally, isShowingHorizontally {
            print("")
            self.animateToVertical(duration: animationDuration)
            //animate to vertical
        } else {
            print("")
            //update hard
        }


        if shouldAnimateSummary {

            let animationDistance: CGFloat = 50
            var animationRows: [UIView] = []
            var pinTops: [NSLayoutConstraint] = []

            if !shouldHideSummary {
                niceSummary?.update(newModel.data, hideAnimatedView: !shouldHideSummary)
                self.layoutIfNeeded()
            }


            if let subviews = niceSummary?.getSubviews() {
                for view in subviews {
                    if view.pxShouldAnimatedOneTapRow, let summaryRowView = view as? PxOneTapSummaryRowView, let newRow = niceSummary?.getSummaryRowView(with: summaryRowView.data) {

                        newRow.alpha = shouldHideSummary ? 1 : 0

                        animationRows.append(newRow)
                        self.addSubview(newRow)

                        PXLayout.setHeight(owner: newRow, height: summaryRowView.frame.height).isActive = true
                        PXLayout.setWidth(owner: newRow, width: summaryRowView.frame.width).isActive = true

                        let summaryRowViewFrame = summaryRowView.convert(summaryRowView.bounds, to: self)
                        let pinTopConstraint = PXLayout.pinTop(view: newRow, withMargin: summaryRowViewFrame.minY)
                        pinTopConstraint.constant = shouldHideSummary ? pinTopConstraint.constant : pinTopConstraint.constant + animationDistance
                        pinTopConstraint.isActive = true
                        pinTops.append(pinTopConstraint)
                    }
                }
            }

            niceSummary?.update(newModel.data, hideAnimatedView: !shouldHideSummary)

            self.layoutIfNeeded()
            var pxAnimator = PXAnimator(duration: 0.5, dampingRatio: 1)

            pxAnimator.addAnimation(animation: {
                for (index, view) in animationRows.enumerated() {
                    let pinTopConstraint = pinTops[index]
                    pinTopConstraint.constant = shouldHideSummary ? pinTopConstraint.constant + animationDistance : pinTopConstraint.constant - animationDistance
                    self.layoutIfNeeded()
                    view.alpha = shouldHideSummary ? 0 : 1
                }
            })

            pxAnimator.addCompletion {
                self.niceSummary?.showAnimatedViews()
                for view in animationRows {
                    view.removeFromSuperview()
                }
            }

            pxAnimator.animate()
        } else {
            niceSummary?.update(newModel.data)
        }
    }

    private func animateToVertical(duration: Double = 0) {
        self.isShowingHorizontally = false
        self.merchantView?.animateToVertical(duration: duration)
        var pxAnimator = PXAnimator(duration: duration, dampingRatio: 1)
        pxAnimator.addAnimation(animation: {
            for constraint in self.horizontalLayoutConstraints.reversed() {
                constraint.isActive = false
            }

            for constraint in self.verticalLayoutConstraints.reversed() {
                constraint.isActive = true
            }
            self.layoutIfNeeded()
        })

        pxAnimator.animate()
    }

    private func animateToHorizontal(duration: Double = 0) {
        self.isShowingHorizontally = true
        self.merchantView?.animateToHorizontal(duration: duration)
        var pxAnimator = PXAnimator(duration: duration, dampingRatio: 1)
        pxAnimator.addAnimation(animation: {
            for constraint in self.horizontalLayoutConstraints.reversed() {
                constraint.isActive = true
            }

            for constraint in self.verticalLayoutConstraints.reversed() {
                constraint.isActive = false
            }
            self.layoutIfNeeded()
        })

        pxAnimator.animate()
    }


    private func render() {
        removeAllSubviews()
        self.pinContentViewToBottom()
        backgroundColor = ThemeManager.shared.navigationBar().backgroundColor

        let summaryView = PxOneTapSummaryView(data: model.data)
        self.niceSummary = summaryView

        addSubview(summaryView)
        PXLayout.matchWidth(ofView: summaryView).isActive = true
        PXLayout.pinBottom(view: summaryView).isActive = true

        let showHorizontally = shouldShowHorizontally(data: model.data)
        let merchantView = PXOneTapHeaderMerchantView(image: model.icon, title: model.title, showHorizontally: showHorizontally)
        self.merchantView = merchantView
        self.addSubview(merchantView)

        let horizontalConstraints = [PXLayout.pinTop(view: merchantView, withMargin: -PXLayout.XXL_MARGIN),
                                     PXLayout.put(view: merchantView, aboveOf: summaryView, withMargin: -PXLayout.M_MARGIN),
                                     PXLayout.centerHorizontally(view: merchantView),
                                     PXLayout.matchWidth(ofView: merchantView)]

        self.horizontalLayoutConstraints.append(contentsOf: horizontalConstraints)

        let verticalLayoutConstraints = [PXLayout.pinTop(view: merchantView),
                                         PXLayout.put(view: merchantView, aboveOf: summaryView),
                                         PXLayout.centerHorizontally(view: merchantView),
                                         PXLayout.matchWidth(ofView: merchantView)]

        self.verticalLayoutConstraints.append(contentsOf: verticalLayoutConstraints)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSummaryTap))
        summaryView.addGestureRecognizer(tapGesture)

        if showHorizontally {
            animateToHorizontal()
        } else {
            animateToVertical()
        }
    }
}

// MARK: Publics.
extension PXOneTapHeaderView {

    @objc func handleSummaryTap() {
        delegate?.didTapSummary()
    }
}
