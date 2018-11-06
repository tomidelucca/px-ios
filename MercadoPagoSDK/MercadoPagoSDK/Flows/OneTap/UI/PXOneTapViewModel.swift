//
//  PXOneTapViewModel.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 15/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final class PXOneTapViewModel: PXReviewViewModel {
    // Privates
    private var cardSliderViewModel: [PXCardSliderViewModel] = [PXCardSliderViewModel]()
    // Publics
    var expressData: [PXOneTapDto]?
    var paymentMethods: [PXPaymentMethod] = [PXPaymentMethod]()
    var paymentMethodPlugins: [PXPaymentMethodPlugin]?
    var items: [PXItem] = [PXItem]()

    override func trackConfirmActionEvent() {
        MPXTracker.sharedInstance.trackActionEvent(action: TrackingPaths.ACTION_CHECKOUT_CONFIRMED, screenId: "screenId", screenName: TrackingPaths.Screens.getOneTapPath())
    }

    override func trackInfo() {
        var properties: [String: String] = [TrackingPaths.METADATA_PAYMENT_METHOD_ID: self.amountHelper.paymentData.paymentMethod?.id ?? "", TrackingPaths.METADATA_PAYMENT_TYPE_ID: self.amountHelper.paymentData.paymentMethod?.paymentTypeId ?? "", TrackingPaths.METADATA_AMOUNT_ID: self.amountHelper.preferenceAmountWithCharges.stringValue]

        if let customerCard = paymentOptionSelected as? CustomerPaymentMethod {
            properties[TrackingPaths.METADATA_CARD_ID] = customerCard.customerPaymentMethodId
        }
        if let installments = self.amountHelper.paymentData.payerCost?.installments {
            properties[TrackingPaths.METADATA_INSTALLMENTS] = installments.stringValue
        }

        MPXTracker.sharedInstance.trackScreen(screenName: TrackingPaths.Screens.getOneTapPath(), properties: properties)
    }
}

// MARK: - Extra events
extension PXOneTapViewModel {
    func trackTapSummaryDetailEvent() {
        var properties: [String: String] = [String: String]()
        properties[TrackingPaths.Metadata.HAS_DISCOUNT] = hasDiscount().description
        properties[TrackingPaths.Metadata.INSTALLMENTS] = amountHelper.paymentData.getNumberOfInstallments().stringValue
        MPXTracker.sharedInstance.trackActionEvent(action: TrackingPaths.Event.TAP_SUMMARY_DETAIL, screenId: TrackingPaths.Screens.getOneTapPath(), screenName: TrackingPaths.Screens.getOneTapPath(), properties: properties)
    }

    func trackTapBackEvent() {
        MPXTracker.sharedInstance.trackActionEvent(action: TrackingPaths.Event.TAP_BACK, screenId: TrackingPaths.Screens.getOneTapPath(), screenName: TrackingPaths.Screens.getOneTapPath())
    }
}

// MARK: ViewModels Publics.
extension PXOneTapViewModel {
    func createCardSliderViewModel() {
        var sliderModel: [PXCardSliderViewModel] = []
        let currency = SiteManager.shared.getCurrency()
        let amTitle: String = "onetap_am_total_balance".localized_beta
        guard let expressNode = expressData else { return }
        for targetNode in expressNode {
            if let accountMoney = targetNode.accountMoney {
                let displayAmount = Utils.getAmountFormated(amount: accountMoney.availableBalance, forCurrency: currency)
                let cardData = PXCardDataFactory().create(cardName: "\(amTitle) \(displayAmount)", cardNumber: "", cardCode: "", cardExpiration: "")
                let viewModelCard = PXCardSliderViewModel(targetNode.paymentMethodId, "", AccountMoneyCard(), cardData, [PXPayerCost](), nil, nil, false)
                if  accountMoney.invested {
                    viewModelCard.displayMessage = "onetap_invested_account_money".localized_beta
                }
                sliderModel.append(viewModelCard)
            } else if let targetCardData = targetNode.oneTapCard {
                if let cardName = targetCardData.cardUI?.name, let cardNumber = targetCardData.cardUI?.lastFourDigits, let cardExpiration = targetCardData.cardUI?.expiration {

                    let cardData = PXCardDataFactory().create(cardName: cardName.uppercased(), cardNumber: cardNumber, cardCode: "", cardExpiration: cardExpiration, cardPattern: targetCardData.cardUI?.cardPattern)

                    let templateCard = TemplateCard()
                    if let cardPattern = targetCardData.cardUI?.cardPattern {
                        templateCard.cardPattern = cardPattern
                    }

                    if let cardBackgroundColor = targetCardData.cardUI?.color {
                        templateCard.cardBackgroundColor = cardBackgroundColor.hexToUIColor()
                    }

                    if let cardFontColor = targetCardData.cardUI?.fontColor {
                        templateCard.cardFontColor = cardFontColor.hexToUIColor()
                    }

                    if let paymentMethodImage = ResourceManager.shared.getPaymentMethodCardImage(paymentMethodId: targetNode.paymentMethodId.lowercased()) {
                        templateCard.cardLogoImage = paymentMethodImage
                    }

                    var payerCost: [PXPayerCost] = [PXPayerCost]()
                    if let pCost = targetCardData.payerCosts {
                        payerCost = pCost
                    }

                    var targetIssuerId: String = ""
                    if let issuerId = targetNode.oneTapCard?.cardUI?.issuerId {
                        targetIssuerId = issuerId
                    }

                    var showArrow: Bool = true
                    var displayMessage: String?
                    if let targetPaymentMethodId = targetNode.paymentTypeId, targetPaymentMethodId == PXPaymentTypes.DEBIT_CARD.rawValue {
                        showArrow = false
                        displayMessage = ""
                    } else if targetCardData.selectedPayerCost == nil {
                        showArrow = false
                    }

                    let viewModelCard = PXCardSliderViewModel(targetNode.paymentMethodId, targetIssuerId, templateCard, cardData, payerCost, targetCardData.selectedPayerCost, nil, showArrow)
                    viewModelCard.displayMessage = displayMessage
                    sliderModel.append(viewModelCard)
                }
            }
        }
        sliderModel.append(PXCardSliderViewModel("", "", EmptyCard(), nil, [PXPayerCost](), nil, nil, false))
        cardSliderViewModel = sliderModel
    }

    func getInstallmentInfoViewModel() -> [PXOneTapInstallmentInfoViewModel] {
        var model: [PXOneTapInstallmentInfoViewModel] = [PXOneTapInstallmentInfoViewModel]()
        let sliderViewModel = getCardSliderViewModel()
        for sliderNode in sliderViewModel {
            let installment = PXInstallment(issuer: nil, payerCosts: sliderNode.payerCost, paymentMethodId: nil, paymentTypeId: nil)
            let selectedPayerCost = sliderNode.selectedPayerCost
            if let displayMessage = sliderNode.displayMessage {
                let installmentInfoModel = PXOneTapInstallmentInfoViewModel(text: getDisplayMessageAttrText(displayMessage), installmentData: installment, selectedPayerCost: selectedPayerCost, shouldShowArrow: sliderNode.shouldShowArrow)
                model.append(installmentInfoModel)
            } else {
                let installmentInfoModel = PXOneTapInstallmentInfoViewModel(text: getInstallmentInfoAttrText(sliderNode.selectedPayerCost), installmentData: installment, selectedPayerCost: selectedPayerCost, shouldShowArrow: sliderNode.shouldShowArrow)
                model.append(installmentInfoModel)
            }
        }
        return model
    }

    func getHeaderViewModel() -> PXOneTapHeaderViewModel {
        let isDefaultStatusBarStyle = ThemeManager.shared.statusBarStyle() == .default
        let summaryColor = isDefaultStatusBarStyle ? UIColor.black : ThemeManager.shared.whiteColor()
        let summaryAlpha: CGFloat = 0.45
        let discountColor = isDefaultStatusBarStyle ? ThemeManager.shared.noTaxAndDiscountLabelTintColor() : ThemeManager.shared.whiteColor()
        let discountAlpha: CGFloat = 1
        let totalColor = isDefaultStatusBarStyle ? UIColor.black : ThemeManager.shared.whiteColor()
        let totalAlpha: CGFloat = 1

        let currency = SiteManager.shared.getCurrency()
        let totalAmountToShow = Utils.getAmountFormated(amount: amountHelper.amountToPayWithoutPayerCost, forCurrency: currency)
        let yourPurchaseToShow = Utils.getAmountFormated(amount: amountHelper.preferenceAmount, forCurrency: currency)
        var customData: [OneTapHeaderSummaryData] = [OneTapHeaderSummaryData]()

        if let discount = amountHelper.discount {
            customData.append(OneTapHeaderSummaryData("onetap_purchase_summary_title".localized_beta, yourPurchaseToShow, summaryColor, summaryAlpha, false, nil))
            let discountToShow = Utils.getAmountFormated(amount: discount.couponAmount, forCurrency: currency)
            let helperImage: UIImage? = isDefaultStatusBarStyle ? ResourceManager.shared.getImage("helper_ico") : ResourceManager.shared.getImage("helper_ico_light")
            customData.append(OneTapHeaderSummaryData(discount.getDiscountDescription(), "- \(discountToShow)", discountColor, discountAlpha, false, helperImage))
        }

        customData.append(OneTapHeaderSummaryData("onetap_purchase_summary_total".localized_beta, totalAmountToShow, totalColor, totalAlpha, true, nil))

        // HeaderImage
        var headerImage: UIImage = UIImage()
        var headerTitle: String = ""
        if let headerUrl = items.first?.getPictureURL() {
            headerImage = PXUIImage(url: headerUrl)
        } else {
            if let defaultImage = ResourceManager.shared.getImage("MPSDK_review_iconoCarrito_white") {
                headerImage = defaultImage
            }
        }

        // HeaderTitle
        if let headerTitleStr = items.first?._description {
            headerTitle = headerTitleStr
        } else if let headerTitleStr = items.first?.title {
            headerTitle = headerTitleStr
        }

        let headerVM = PXOneTapHeaderViewModel(icon: headerImage, title: headerTitle, data: customData)
        return headerVM
    }

    func getCardSliderViewModel() -> [PXCardSliderViewModel] {
        return cardSliderViewModel
    }

    func updateCardSliderViewModel(newPayerCost: PXPayerCost?, forIndex: Int) -> Bool {
        if cardSliderViewModel.indices.contains(forIndex) {
            cardSliderViewModel[forIndex].selectedPayerCost = newPayerCost
            return true
        }
        return false
    }

    func getPaymentMethod(targetId: String) -> PXPaymentMethod? {
        if let plugins = paymentMethodPlugins, let pluginsPms = plugins.filter({return $0.getId() == targetId}).first {
            return pluginsPms.toPaymentMethod()
        }
        return paymentMethods.filter({return $0.id == targetId}).first
    }
}

// MARK: Privates.
extension PXOneTapViewModel {
    private func getDisplayMessageAttrText(_ displayMessage: String) -> NSAttributedString {
        let attributes: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.font: Utils.getFont(size: PXLayout.XS_FONT), NSAttributedStringKey.foregroundColor: ThemeManager.shared.greyColor()]
        let attributedString = NSAttributedString(string: displayMessage, attributes: attributes)
        return attributedString
    }

    private func getInstallmentInfoAttrText(_ payerCost: PXPayerCost?) -> NSMutableAttributedString {
        let text: NSMutableAttributedString = NSMutableAttributedString(string: "")

        if let payerCostData = payerCost {
            // First attr
            let currency = SiteManager.shared.getCurrency()
            let firstAttributes: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.font: Utils.getSemiBoldFont(size: PXLayout.XS_FONT), NSAttributedStringKey.foregroundColor: ThemeManager.shared.boldLabelTintColor()]
            let amountDisplayStr = Utils.getAmountFormated(amount: payerCostData.installmentAmount, forCurrency: currency).trimmingCharacters(in: .whitespaces)
            let firstText = "\(payerCostData.installments)x \(amountDisplayStr)"
            let firstAttributedString = NSAttributedString(string: firstText, attributes: firstAttributes)
            text.append(firstAttributedString)

            // Second attr
            // if let recommendedMessage = payerCostData.recommendedMessage {
            if payerCostData.installmentRate == 0 {
                let secondAttributes: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.font: Utils.getFont(size: PXLayout.XS_FONT), NSAttributedStringKey.foregroundColor: ThemeManager.shared.noTaxAndDiscountLabelTintColor()]
                let secondText = " Sin interés".localized
                let secondAttributedString = NSAttributedString(string: secondText, attributes: secondAttributes)
                text.append(secondAttributedString)
            }

            // Third attr
            if let cftDisplayStr = payerCostData.getCFTValue(), payerCostData.hasCFTValue() {
                let thirdAttributes: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.font: Utils.getFont(size: PXLayout.XS_FONT), NSAttributedStringKey.foregroundColor: ThemeManager.shared.greyColor()]
                let thirdText = " CFT: \(cftDisplayStr)"
                let thirdAttributedString = NSAttributedString(string: thirdText, attributes: thirdAttributes)
                text.append(thirdAttributedString)
            }
        }
        return text
    }
}
