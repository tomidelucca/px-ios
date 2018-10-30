//
//  PXOneTapViewController.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 15/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

final class PXOneTapViewController: PXComponentContainerViewController {
    // MARK: Tracking
    override var screenName: String { return TrackingUtil.ScreenId.REVIEW_AND_CONFIRM_ONE_TAP }
    override var screenId: String { return TrackingUtil.ScreenId.REVIEW_AND_CONFIRM_ONE_TAP }

    // MARK: Definitions
    lazy var itemViews = [UIView]()
    fileprivate var viewModel: PXOneTapViewModel
    private lazy var footerView: UIView = UIView()
    private var discountTermsConditionView: PXTermsAndConditionView?

    let slider = PXCardSlider()

    // MARK: Callbacks
    var callbackPaymentData: ((PXPaymentData) -> Void)
    var callbackConfirm: ((PXPaymentData) -> Void)
    var callbackChangePaymentData: ((PXPaymentData) -> Void)
    var callbackExit: (() -> Void)
    var finishButtonAnimation: (() -> Void)

    var loadingButtonComponent: PXAnimatedButton?
    var installmentInfoRow: PXOneTapInstallmentInfoView?
    var installmentsSelectorView: PXOneTapInstallmentsSelectorView?

    let timeOutPayButton: TimeInterval
    let shouldAnimatePayButton: Bool

    var cardSliderMarginConstraint: NSLayoutConstraint?

    // MARK: Lifecycle/Publics
    init(viewModel: PXOneTapViewModel, timeOutPayButton: TimeInterval = 15, shouldAnimatePayButton: Bool, callbackPaymentData : @escaping ((PXPaymentData) -> Void), callbackConfirm: @escaping ((PXPaymentData) -> Void), callbackChangePaymentData: @escaping ((PXPaymentData) -> Void), callbackExit: @escaping (() -> Void), finishButtonAnimation: @escaping (() -> Void)) {
        self.viewModel = viewModel
        self.callbackPaymentData = callbackPaymentData
        self.callbackConfirm = callbackConfirm
        self.callbackExit = callbackExit
        self.callbackChangePaymentData = callbackChangePaymentData
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

    override func adjustInsets() {}
}

// MARK: UI Methods.
extension PXOneTapViewController {
    private func setupNavigationBar() {
        setBackground(color: ThemeManager.shared.highlightBackgroundColor())
        navBarTextColor = ThemeManager.shared.labelTintColor()
        loadMPStyles()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = ThemeManager.shared.whiteColor()
        navigationItem.leftBarButtonItem?.tintColor = ThemeManager.shared.labelTintColor()
        navigationController?.navigationBar.backgroundColor = ThemeManager.shared.highlightBackgroundColor()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }

    private func setupUI() {
        self.navigationController?.navigationBar.backgroundColor = .clear
        if contentView.getSubviews().isEmpty {
            viewModel.createCardSliderViewModel()
            renderViews()
        }
    }

    private func renderViews() {
        contentView.prepareForRender()
        let safeAreaBottomHeight = PXLayout.getSafeAreaBottomInset()

        // Add header view.
        let headerView = getHeaderView()
        contentView.addSubviewToBottom(headerView)
        PXLayout.setHeight(owner: headerView, height: PXCardSliderSizeManager.getHeaderViewHeight(viewController: self)).isActive = true
        PXLayout.centerHorizontally(view: headerView).isActive = true
        PXLayout.matchWidth(ofView: headerView).isActive = true

        // Center white View
        let whiteView = getWhiteView()
        // TODO: Margin factor for white view is temporary. Only for test
        // Make solution like expandBody
        contentView.addSubviewToBottom(whiteView)
        PXLayout.setHeight(owner: whiteView, height: PXCardSliderSizeManager.getWhiteViewHeight(viewController: self)).isActive = true
        PXLayout.centerHorizontally(view: whiteView).isActive = true
        PXLayout.pinLeft(view: whiteView, withMargin: 0).isActive = true
        PXLayout.pinRight(view: whiteView, withMargin: 0).isActive = true

        // Add installment row
        let installmentRow = getInstallmentInfoView()
        whiteView.addSubview(installmentRow)
        PXLayout.centerHorizontally(view: installmentRow).isActive = true
        PXLayout.pinLeft(view: installmentRow).isActive = true
        PXLayout.pinRight(view: installmentRow).isActive = true
        PXLayout.matchWidth(ofView: installmentRow).isActive = true
        PXLayout.pinTop(view: installmentRow, withMargin: PXLayout.XXXS_MARGIN).isActive = true

        // Add card slider
        let cardSliderContentView = UIView()
        whiteView.addSubview(cardSliderContentView)
        PXLayout.centerHorizontally(view: cardSliderContentView).isActive = true
        PXLayout.pinLeft(view: cardSliderContentView).isActive = true
        PXLayout.pinRight(view: cardSliderContentView).isActive = true
        let topMarginConstraint = PXLayout.put(view: cardSliderContentView, onBottomOf: installmentRow, withMargin: 0)
        topMarginConstraint.isActive = true
        cardSliderMarginConstraint = topMarginConstraint
        PXLayout.setHeight(owner: cardSliderContentView, height: PXCardSliderSizeManager.getSliderSize().height).isActive = true

        // Add footer payment button.
        if let footerView = getFooterView() {
            //contentView.addSubviewToBottom(footerView, withMargin: PXLayout.M_MARGIN)
            whiteView.addSubview(footerView)
            PXLayout.centerHorizontally(view: footerView).isActive = true
            PXLayout.pinLeft(view: footerView, withMargin: PXLayout.M_MARGIN).isActive = true
            PXLayout.pinRight(view: footerView, withMargin: PXLayout.M_MARGIN).isActive = true
            PXLayout.setHeight(owner: footerView, height: PXLayout.XXL_MARGIN).isActive = true

            if safeAreaBottomHeight > 0 {
                PXLayout.pinBottom(view: footerView, withMargin: PXLayout.XXS_MARGIN + safeAreaBottomHeight).isActive = true
            } else {
                PXLayout.pinBottom(view: footerView, withMargin: PXLayout.M_MARGIN).isActive = true
            }
        }

        view.layoutIfNeeded()
        refreshContentViewSize()
        scrollView.isScrollEnabled = false
        scrollView.showsVerticalScrollIndicator = false

        addCardSlider(inContainerView: cardSliderContentView)
    }
}

// MARK: Components Builders.
extension PXOneTapViewController {
    private func getHeaderView() -> UIView {
        let headerView = PXOneTapHeaderView(viewModel: viewModel.getHeaderViewModel())
        return headerView
    }

    private func getFooterView() -> UIView? {
        loadingButtonComponent = PXAnimatedButton(normalText: "Pagar".localized, loadingText: "Procesando tu pago".localized, retryText: "Reintentar".localized)
        loadingButtonComponent?.animationDelegate = self
        loadingButtonComponent?.layer.cornerRadius = 8
        loadingButtonComponent?.add(for: .touchUpInside, {
            if self.shouldAnimatePayButton {
                self.subscribeLoadingButtonToNotifications()
                self.loadingButtonComponent?.startLoading(timeOut: self.timeOutPayButton)
            }
            self.confirmPayment()
        })
        loadingButtonComponent?.setTitle("Pagar".localized, for: .normal)
        loadingButtonComponent?.backgroundColor = ThemeManager.shared.getAccentColor()
        return loadingButtonComponent
    }

    private func getWhiteView() -> UIView {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }

    private func getInstallmentInfoView() -> UIView {
        installmentInfoRow = PXOneTapInstallmentInfoView()
        installmentInfoRow?.model = viewModel.getInstallmentInfoViewModel()
        installmentInfoRow?.render()
        installmentInfoRow?.delegate = self
        if let targetView = installmentInfoRow {
            return targetView
        } else {
            return UIView()
        }
    }

    private func addCardSlider(inContainerView: UIView) {
        slider.render(containerView: inContainerView, cardSliderProtocol: self)
        slider.update(viewModel.getCardSliderViewModel())
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

// MARK: CardSlider delegate.
extension PXOneTapViewController: PXCardSliderProtocol {
    func newCardDidSelected(targetModel: PXCardSliderViewModel) {
        // Add card. - CardData nil
        if targetModel.cardData == nil {
            loadingButtonComponent?.setDisabled()
        } else {
            // New payment method selected.
            let newPaymentMethodId: String = targetModel.paymentMethodId
            let newPayerCost: PXPayerCost? = targetModel.selectedPayerCost

            if let newPaymentMethod = viewModel.getPaymentMethod(targetId: newPaymentMethodId) {
                let currentPaymentData: PXPaymentData = viewModel.amountHelper.paymentData
                currentPaymentData.payerCost = newPayerCost
                currentPaymentData.paymentMethod = newPaymentMethod
                callbackChangePaymentData(currentPaymentData)
                print("newCardDidSelected: \(newPaymentMethodId)")
                loadingButtonComponent?.setEnabled()
            } else {
                loadingButtonComponent?.setDisabled()
            }
        }
    }

    func addPaymentMethodCardDidTap() {
        // TODO: Go to grupos -> add new card
        shouldChangePaymentMethod()
    }

    func didScroll(offset: CGPoint) {
        installmentInfoRow?.setSliderOffset(offset: offset)
    }
}

// MARK: Installment Row Info delegate.
extension PXOneTapViewController: PXOneTapInstallmentInfoViewProtocol, PXOneTapInstallmentsSelectorProtocol {

    func payerCostSelected(_ payerCost: PXPayerCost) {
        installmentInfoRow?.toggleInstallments()
        PXFeedbackGenerator.heavyImpactFeedback()

        let currentPaymentData: PXPaymentData = viewModel.amountHelper.paymentData
        currentPaymentData.payerCost = payerCost
        callbackChangePaymentData(currentPaymentData)
    }

    func hideInstallments() {
        self.installmentsSelectorView?.layoutIfNeeded()
        self.installmentInfoRow?.disableTap()

        //Animations
        loadingButtonComponent?.show(duration: 0.1)

        let animationDuration = 0.5

        slider.show(duration: animationDuration)

        var pxAnimator = PXAnimator(duration: animationDuration, dampingRatio: 1)
        pxAnimator.addAnimation(animation: { [weak self] in
            self?.cardSliderMarginConstraint?.constant = 0
            self?.contentView.layoutIfNeeded()
        })

        self.installmentsSelectorView?.collapse(animator: pxAnimator, completion: {
            self.installmentInfoRow?.enableTap()
            self.installmentsSelectorView?.removeFromSuperview()
            self.installmentsSelectorView?.layoutIfNeeded()
        })
    }

    func showInstallments(installmentData: PXInstallment?, selectedPayerCost: PXPayerCost?) {
        guard let installmentData = installmentData, let installmentInfoRow = installmentInfoRow else {
            return
        }

        PXFeedbackGenerator.selectionFeedback()

        self.installmentsSelectorView?.removeFromSuperview()
        self.installmentsSelectorView?.layoutIfNeeded()
        let viewModel = PXOneTapInstallmentsSelectorViewModel(installmentData: installmentData, selectedPayerCost: selectedPayerCost)
        let installmentsSelectorView = PXOneTapInstallmentsSelectorView(viewModel: viewModel)
        installmentsSelectorView.delegate = self
        self.installmentsSelectorView = installmentsSelectorView

        contentView.addSubview(installmentsSelectorView)
        PXLayout.matchWidth(ofView: installmentsSelectorView).isActive = true
        PXLayout.centerHorizontally(view: installmentsSelectorView).isActive = true
        PXLayout.put(view: installmentsSelectorView, onBottomOf: installmentInfoRow).isActive = true
        let installmentsSelectorViewHeight = PXCardSliderSizeManager.getWhiteViewHeight(viewController: self)-PXOneTapInstallmentInfoView.DEFAULT_ROW_HEIGHT
        PXLayout.setHeight(owner: installmentsSelectorView, height: installmentsSelectorViewHeight).isActive = true

        installmentsSelectorView.layoutIfNeeded()
        self.installmentInfoRow?.disableTap()

        //Animations
        loadingButtonComponent?.hide(duration: 0.1)

        let animationDuration = 0.5
        slider.hide(duration: animationDuration)

        var pxAnimator = PXAnimator(duration: animationDuration, dampingRatio: 1)
        pxAnimator.addAnimation(animation: { [weak self] in
            self?.cardSliderMarginConstraint?.constant = installmentsSelectorViewHeight
            self?.contentView.layoutIfNeeded()
        })

        installmentsSelectorView.expand(animator: pxAnimator) {
            self.installmentInfoRow?.enableTap()
        }
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
