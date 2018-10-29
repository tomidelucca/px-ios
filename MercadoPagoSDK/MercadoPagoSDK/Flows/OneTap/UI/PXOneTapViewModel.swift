//
//  PXOneTapViewModel.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 15/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

final class PXOneTapViewModel: PXReviewViewModel {
    var expressData: [PXOneTapDto]?
    var paymentMethods: [PXPaymentMethod] = [PXPaymentMethod]()
    private var cardSliderViewModel: [PXCardSliderViewModel] = [PXCardSliderViewModel]()

    // Tracking overrides.
    override var screenName: String { return TrackingUtil.ScreenId.REVIEW_AND_CONFIRM_ONE_TAP }
    override var screenId: String { return TrackingUtil.ScreenId.REVIEW_AND_CONFIRM_ONE_TAP }

    override func trackConfirmActionEvent() {
        MPXTracker.sharedInstance.trackActionEvent(action: TrackingUtil.ACTION_CHECKOUT_CONFIRMED, screenId: screenId, screenName: screenName)
    }

    override func trackInfo() {
        var properties: [String: String] = [TrackingUtil.METADATA_PAYMENT_METHOD_ID: self.amountHelper.paymentData.paymentMethod?.id ?? "", TrackingUtil.METADATA_PAYMENT_TYPE_ID: self.amountHelper.paymentData.paymentMethod?.paymentTypeId ?? "", TrackingUtil.METADATA_AMOUNT_ID: self.amountHelper.preferenceAmountWithCharges.stringValue]

        if let customerCard = paymentOptionSelected as? CustomerPaymentMethod {
            properties[TrackingUtil.METADATA_CARD_ID] = customerCard.customerPaymentMethodId
        }
        if let installments = self.amountHelper.paymentData.payerCost?.installments {
            properties[TrackingUtil.METADATA_INSTALLMENTS] = installments.stringValue
        }

        MPXTracker.sharedInstance.trackScreen(screenId: screenId, screenName: screenName, properties: properties)
    }
}

// MARK: - Extra events
extension PXOneTapViewModel {
    func trackTapSummaryDetailEvent() {
        var properties: [String: String] = [String: String]()
        properties[TrackingUtil.Metadata.HAS_DISCOUNT] = hasDiscount().description
        properties[TrackingUtil.Metadata.INSTALLMENTS] = amountHelper.paymentData.getNumberOfInstallments().stringValue
        MPXTracker.sharedInstance.trackActionEvent(action: TrackingUtil.Event.TAP_SUMMARY_DETAIL, screenId: screenId, screenName: screenName, properties: properties)
    }

    func trackTapBackEvent() {
        MPXTracker.sharedInstance.trackActionEvent(action: TrackingUtil.Event.TAP_BACK, screenId: screenId, screenName: screenName)
    }
}

extension PXOneTapViewModel {
    func createCardSliderViewModel() {
        var sliderModel: [PXCardSliderViewModel] = []
        guard let expressNode = expressData else { return }
        for targetNode in expressNode {
            if let accountMoney = targetNode.accountMoney {
                // TODO: Translation
                let cardData = PXCardDataFactory().create(cardName: "Total en tu cuenta: $ \(accountMoney.availableBalance)", cardNumber: "", cardCode: "", cardExpiration: "")
                sliderModel.append(PXCardSliderViewModel(targetNode.paymentMethodId, AccountMoneyCard(), cardData, [PXPayerCost](), nil))
            } else if let targetCardData = targetNode.oneTapCard {
                if let cardName = targetCardData.cardUI?.name, let cardNumber = targetCardData.cardUI?.lastFourDigits, let cardExpiration = targetCardData.cardUI?.expiration {

                    // TODO: Proper cardNumber ended.
                    let cardData = PXCardDataFactory().create(cardName: cardName.uppercased(), cardNumber: cardNumber, cardCode: "", cardExpiration: cardExpiration)

                    let templateCard = TemplateCard()
                    if let cardPattern = targetCardData.cardUI?.cardPattern {
                        templateCard.cardPattern = cardPattern
                    }
                    if let cardBackgroundColor = targetCardData.cardUI?.color {
                        templateCard.cardBackgroundColor = cardBackgroundColor.hexToUIColor()
                    }

                    /*
                     Issuer image disabled in OneTap first iteration.
                    if let issuerId = targetNode.oneTapCard?.cardUI?.issuerId {
                        templateCard.bankImage = ResourceManager.shared.getImage("issuer_\(String(issuerId))")
                    } */

                    // ResourceManager.shared.getImage("icoTc_" + targetNode.paymentMethodId.lowercased()
                    if let paymentMethodImage = ResourceManager.shared.getImageForPaymentMethod(withDescription: targetNode.paymentMethodId) {
                        templateCard.cardLogoImage = paymentMethodImage
                    }

                    var payerCost: [PXPayerCost] = [PXPayerCost]()
                    if let pCost = targetCardData.payerCosts {
                        payerCost = pCost
                    }

                    sliderModel.append((targetNode.paymentMethodId, templateCard, cardData, payerCost, targetCardData.selectedPayerCost))
                }
            }
        }
        sliderModel.append(PXCardSliderViewModel("", EmptyCard(), nil, [PXPayerCost](), nil))
        cardSliderViewModel = sliderModel
    }

    func getCardSliderViewModel() -> [PXCardSliderViewModel] {
        return cardSliderViewModel
    }

    func getInstallmentInfoViewModel() -> [PXOneTapInstallmentInfoViewModel] {
        var model: [PXOneTapInstallmentInfoViewModel] = [PXOneTapInstallmentInfoViewModel]()
        let sliderViewModel = getCardSliderViewModel()
        for sliderNode in sliderViewModel {
            let installment = PXInstallment(issuer: nil, payerCosts: sliderNode.payerCost, paymentMethodId: nil, paymentTypeId: nil)
            let selectedPayerCost = sliderNode.selectedPayerCost
            let installmentInfoModel = PXOneTapInstallmentInfoViewModel(text: getInstallmentInfoAttrText(sliderNode.selectedPayerCost), installmentData: installment, selectedPayerCost: selectedPayerCost, shouldShow: selectedPayerCost != nil)
            model.append(installmentInfoModel)
        }
        // TODO: Check [] empty array scenario
        return model
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
            // TODO: Check with Android and Backend rule based on recommendedMessage or installmentRate.
            // if let recommendedMessage = payerCostData.recommendedMessage {
            if payerCostData.installmentRate == 0 {
                let secondAttributes: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.font: Utils.getFont(size: PXLayout.XS_FONT), NSAttributedStringKey.foregroundColor: ThemeManager.shared.noTaxAndDiscountLabelTintColor()]
                // let secondText = " \(recommendedMessage)"
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

    func getPaymentMethod(targetId: String) -> PXPaymentMethod? {
        return paymentMethods.filter({return $0.id == targetId}).first
    }
}
