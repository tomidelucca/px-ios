//
//  PXOneTapViewController.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 15/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

typealias OneTapSummaryData = (title: String, value: String, highlightedColor: UIColor, isTotal: Bool)

class PXOneTapHeaderViewModel {
    let icon: UIImage
    let title: String
    let data: [OneTapSummaryData]

    init(icon: UIImage, title: String, data: [OneTapSummaryData]) {
        self.icon = icon
        self.title = title
        self.data = data
    }
}

class PXOneTapHeaderMerchantView: PXComponentView {
    let image: UIImage
    let title: String
    let showHorizontally: Bool

    init(image: UIImage, title: String, showHorizontally: Bool = false) {
        self.image = image
        self.title = title
        self.showHorizontally = showHorizontally
        super.init()
        render()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let IMAGE_SIZE: CGFloat = 55

    private func render() {
        let containerView = UIView()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.blue.cgColor
        let imageView = PXUIImageView()
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = IMAGE_SIZE/2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.enableFadeIn()
        imageView.image = image
        containerView.addSubview(imageView)
        PXLayout.setHeight(owner: imageView, height: IMAGE_SIZE).isActive = true
        PXLayout.setWidth(owner: imageView, width: IMAGE_SIZE).isActive = true

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = Utils.getSemiBoldFont(size: PXLayout.M_FONT)
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        containerView.layer.borderWidth = 3
        containerView.layer.borderColor = UIColor.purple.cgColor

        self.addSubviewToBottom(containerView)
        PXLayout.pinBottom(view: containerView).isActive = true
        PXLayout.centerHorizontally(view: containerView).isActive = true

        if showHorizontally {
            PXLayout.pinTop(view: imageView, withMargin: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.pinBottom(view: imageView, withMargin: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.pinLeft(view: imageView, withMargin: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.pinRight(view: titleLabel, withMargin: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.put(view: imageView, leftOf: titleLabel, withMargin: PXLayout.XXS_MARGIN, relation: .equal).isActive = true
            PXLayout.centerVertically(view: imageView, to: titleLabel).isActive = true
        } else {
            PXLayout.centerHorizontally(view: imageView).isActive = true
            PXLayout.pinTop(view: imageView, withMargin: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.centerHorizontally(view: titleLabel).isActive = true
            PXLayout.put(view: titleLabel, onBottomOf: imageView, withMargin: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.pinBottom(view: titleLabel, withMargin: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.matchWidth(ofView: containerView).isActive = true
        }
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
        summaryView.layer.borderWidth = 1
        summaryView.layer.borderColor = UIColor.green.cgColor

        for dat in model.data {
            let margin: CGFloat = dat.isTotal ? PXLayout.S_MARGIN : PXLayout.XXS_MARGIN
            let rowView = getSummaryRow(with: dat)

            if dat.isTotal {
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
            PXLayout.pinLeft(view: rowView, withMargin: PXLayout.M_MARGIN).isActive = true
            PXLayout.pinRight(view: rowView, withMargin: PXLayout.M_MARGIN).isActive = true
        }

        self.addSubview(summaryView)
        summaryView.pinLastSubviewToBottom(withMargin: PXLayout.S_MARGIN)?.isActive = true
        PXLayout.matchWidth(ofView: summaryView).isActive = true
        PXLayout.pinBottom(view: summaryView).isActive = true

        let merchantView = PXOneTapHeaderMerchantView(image: model.icon, title: model.title, showHorizontally: false)
        self.addSubview(merchantView)
        PXLayout.pinTop(view: merchantView).isActive = true
        PXLayout.put(view: merchantView, aboveOf: summaryView).isActive = true
        PXLayout.centerHorizontally(view: merchantView).isActive = true
        PXLayout.matchWidth(ofView: merchantView).isActive = true
    }

    func getSummaryRow(with data: OneTapSummaryData) -> UIView {
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

final class PXOneTapViewController: PXComponentContainerViewController {
    // MARK: Tracking
    override var screenName: String { return TrackingUtil.ScreenId.REVIEW_AND_CONFIRM_ONE_TAP }
    override var screenId: String { return TrackingUtil.ScreenId.REVIEW_AND_CONFIRM_ONE_TAP }

    // MARK: Definitions
    lazy var itemViews = [UIView]()
    fileprivate var viewModel: PXOneTapViewModel
    private lazy var footerView: UIView = UIView()
    private var discountTermsConditionView: PXTermsAndConditionView?

    // MARK: Callbacks
    var callbackPaymentData: ((PXPaymentData) -> Void)
    var callbackConfirm: ((PXPaymentData) -> Void)
    var callbackExit: (() -> Void)
    var finishButtonAnimation: (() -> Void)

    var loadingButtonComponent: PXAnimatedButton?

    let timeOutPayButton: TimeInterval
    let shouldAnimatePayButton: Bool

    // MARK: Lifecycle/Publics
    init(viewModel: PXOneTapViewModel, timeOutPayButton: TimeInterval = 15, shouldAnimatePayButton: Bool, callbackPaymentData : @escaping ((PXPaymentData) -> Void), callbackConfirm: @escaping ((PXPaymentData) -> Void), callbackExit: @escaping (() -> Void), finishButtonAnimation: @escaping (() -> Void)) {
        self.viewModel = viewModel
        self.callbackPaymentData = callbackPaymentData
        self.callbackConfirm = callbackConfirm
        self.callbackExit = callbackExit
        self.finishButtonAnimation = finishButtonAnimation
        self.timeOutPayButton = timeOutPayButton
        self.shouldAnimatePayButton = shouldAnimatePayButton
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        setupUI()
        scrollView.isScrollEnabled = true
        view.isUserInteractionEnabled = true
        UIApplication.shared.statusBarStyle = .default
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingToParentViewController {
            viewModel.trackTapBackEvent()
        }

        if shouldAnimatePayButton {
            PXNotificationManager.UnsuscribeTo.animateButton(loadingButtonComponent)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loadingButtonComponent?.resetButton()
    }

    override func trackInfo() {
        self.viewModel.trackInfo()
    }

    func update(viewModel: PXOneTapViewModel) {
        self.viewModel = viewModel
    }

    override func adjustInsets() {

    }
}

// MARK: UI Methods.
extension PXOneTapViewController {
    private func setupNavigationBar() {
        navBarTextColor = ThemeManager.shared.labelTintColor()
        loadMPStyles()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = ThemeManager.shared.whiteColor()
        navigationItem.leftBarButtonItem?.tintColor = ThemeManager.shared.labelTintColor()
        navigationController?.navigationBar.backgroundColor =  UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }

    private func setupUI() {
        if contentView.getSubviews().isEmpty {
            renderViews()
            super.prepareForAnimation(customAnimations: PXSpruce.PXDefaultAnimation.rightToLeftAnimation)
            super.animateContentView(customAnimations: PXSpruce.PXDefaultAnimation.rightToLeftAnimation)
        }
    }

    private func renderViews() {
        contentView.prepareForRender()

        let view = PXOneTapHeaderView()
        view.model = PXOneTapHeaderViewModel(icon: PXUIImage(url: "https://ih0.redbubble.net/image.491854097.6059/flat,550x550,075,f.u2.jpg"), title: "Burger King", data: [
            OneTapSummaryData("Tu compra", "$ 1.000", ThemeManager.shared.greyColor(), false),
            OneTapSummaryData("20% Descuento por usar QR", "- $ 200", ThemeManager.shared.noTaxAndDiscountLabelTintColor(), false),
            OneTapSummaryData("Sub total", "$ 800", UIColor.black, true),
            OneTapSummaryData("Cargos", "$ 100", ThemeManager.shared.greyColor(), false),
            OneTapSummaryData("Cargos 2", "$ 100", ThemeManager.shared.greyColor(), false),
            OneTapSummaryData("Cargos 3", "$ 100", ThemeManager.shared.greyColor(), false),
            OneTapSummaryData("Total", "$ 1100", UIColor.black, true)
            ])
        contentView.addSubviewToBottom(view)
        PXLayout.centerHorizontally(view: view).isActive = true
        PXLayout.matchWidth(ofView: view).isActive = true


        // Add item-price view.
        if let itemView = getItemComponentView() {
            contentView.addSubviewToBottom(itemView)
            PXLayout.centerHorizontally(view: itemView).isActive = true
            PXLayout.matchWidth(ofView: itemView).isActive = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.shouldOpenSummary))
            itemView.addGestureRecognizer(tapGesture)
        }

        // Add payment method.
        if let paymentMethodView = getPaymentMethodComponentView() {
            contentView.addSubviewToBottom(paymentMethodView, withMargin: PXLayout.M_MARGIN)
            PXLayout.pinLeft(view: paymentMethodView, withMargin: PXLayout.M_MARGIN).isActive = true
            PXLayout.pinRight(view: paymentMethodView, withMargin: PXLayout.M_MARGIN).isActive = true
            let paymentMethodTapAction = UITapGestureRecognizer(target: self, action: #selector(self.shouldChangePaymentMethod))
            paymentMethodView.addGestureRecognizer(paymentMethodTapAction)
        }

        // Add discount terms and conditions.
        if viewModel.shouldShowDiscountTermsAndCondition() {
            let discountTCView = viewModel.getDiscountTermsAndConditionView(shouldAddMargins: false)
            discountTermsConditionView = discountTCView
            contentView.addSubviewToBottom(discountTCView, withMargin: PXLayout.S_MARGIN)
            PXLayout.matchWidth(ofView: discountTCView).isActive = true
            PXLayout.centerHorizontally(view: discountTCView).isActive = true
            discountTCView.delegate = self
        }

        // Add footer payment button.
        if let footerView = getFooterView() {
            contentView.addSubviewToBottom(footerView, withMargin: PXLayout.M_MARGIN)
            PXLayout.centerHorizontally(view: footerView).isActive = true
            PXLayout.pinLeft(view: footerView, withMargin: PXLayout.M_MARGIN).isActive = true
            PXLayout.pinRight(view: footerView, withMargin: PXLayout.M_MARGIN).isActive = true
            PXLayout.setHeight(owner: footerView, height: PXLayout.XXL_MARGIN).isActive = true
        }

        view.layoutIfNeeded()
        refreshContentViewSize()
//        _ = centerContentView(margin: -PXLayout.getStatusBarHeight())
    }
}

// MARK: Components Builders.
extension PXOneTapViewController {
    private func getItemComponentView() -> UIView? {
        if let oneTapItemComponent = viewModel.getItemComponent() {
            return oneTapItemComponent.render()
        }
        return nil
    }

    private func getPaymentMethodComponentView() -> UIView? {
        if let paymentMethodComponent = viewModel.getPaymentMethodComponent() {
            return paymentMethodComponent.oneTapRender()
        }
        return nil
    }

    private func getFooterView() -> UIView? {
        loadingButtonComponent = PXAnimatedButton(normalText: "Confirmar".localized, loadingText: "Procesando tu pago".localized, retryText: "Reintentar".localized)
        loadingButtonComponent?.animationDelegate = self
        loadingButtonComponent?.layer.cornerRadius = 4
        loadingButtonComponent?.add(for: .touchUpInside, {
            if self.shouldAnimatePayButton {
                self.subscribeLoadingButtonToNotifications()
                self.loadingButtonComponent?.startLoading(timeOut: self.timeOutPayButton)
            }
            self.confirmPayment()
        })
        loadingButtonComponent?.setTitle("Confirmar".localized, for: .normal)
        loadingButtonComponent?.backgroundColor = ThemeManager.shared.getAccentColor()

        return loadingButtonComponent
    }

    private func getDiscountDetailView() -> UIView? {
        if self.viewModel.amountHelper.discount != nil || self.viewModel.amountHelper.consumedDiscount {
            let discountDetailVC = PXDiscountDetailViewController(amountHelper: self.viewModel.amountHelper, shouldShowTitle: true)
            return discountDetailVC.getContentView()
        }
        return nil
    }
}

// MARK: User Actions.
extension PXOneTapViewController: PXTermsAndConditionViewDelegate {
    @objc func shouldOpenSummary() {
        viewModel.trackTapSummaryDetailEvent()
        if viewModel.shouldShowSummaryModal() {
            if let summaryProps = viewModel.getSummaryProps(), summaryProps.count > 0 {
                let summaryViewController = PXOneTapSummaryModalViewController()
                summaryViewController.setProps(summaryProps: summaryProps, bottomCustomView: getDiscountDetailView())
                PXComponentFactory.Modal.show(viewController: summaryViewController, title: "Detalle".localized)
            } else {
                if let discountView = getDiscountDetailView() {
                    let summaryViewController = PXOneTapSummaryModalViewController()
                    summaryViewController.setProps(summaryProps: nil, bottomCustomView: discountView)
                    PXComponentFactory.Modal.show(viewController: summaryViewController, title: nil)
                }
            }
        }
    }

    @objc func shouldChangePaymentMethod() {
        viewModel.trackChangePaymentMethodEvent()
        callbackPaymentData(viewModel.getClearPaymentData())
    }

    private func confirmPayment() {
        scrollView.isScrollEnabled = false
        view.isUserInteractionEnabled = false
        self.viewModel.trackConfirmActionEvent()
        self.hideBackButton()
        self.hideNavBar()
        self.callbackConfirm(self.viewModel.amountHelper.paymentData)
    }

    func resetButton() {
        loadingButtonComponent?.resetButton()
        loadingButtonComponent?.showErrorToast()
// MARK: Uncomment for Shake button
//        loadingButtonComponent?.shake()
    }

    private func cancelPayment() {
        self.callbackExit()
    }

    func shouldOpenTermsCondition(_ title: String, screenName: String, url: URL) {
        let webVC = WebViewController(url: url, screenName: screenName, navigationBarTitle: title)
        webVC.title = title
        self.navigationController?.pushViewController(webVC, animated: true)
    }
}

// MARK: Payment Button animation delegate
@available(iOS 9.0, *)
extension PXOneTapViewController: PXAnimatedButtonDelegate {
    func shakeDidFinish() {
        displayBackButton()
        scrollView.isScrollEnabled = true
        view.isUserInteractionEnabled = true
        unsubscribeFromNotifications()
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingButtonComponent?.backgroundColor = ThemeManager.shared.getAccentColor()
        })
    }

    func expandAnimationInProgress() {
    }

    func didFinishAnimation() {
        self.finishButtonAnimation()
    }

    func progressButtonAnimationTimeOut() {
        loadingButtonComponent?.resetButton()
        loadingButtonComponent?.showErrorToast()
// MARK: Uncomment for Shake button
//        loadingButtonComponent?.shake()
    }
}

// MARK: Notifications
extension PXOneTapViewController {
    func subscribeLoadingButtonToNotifications() {
        guard let loadingButton = loadingButtonComponent else {
            return
        }

        PXNotificationManager.SuscribeTo.animateButton(loadingButton, selector: #selector(loadingButton.animateFinish))
    }

    func unsubscribeFromNotifications() {
        PXNotificationManager.UnsuscribeTo.animateButton(loadingButtonComponent)
    }
}
