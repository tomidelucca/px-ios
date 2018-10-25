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
    func getCardSliderViewModel() -> [PXCardSliderViewModel] {
        var sliderModel: [PXCardSliderViewModel] = []
        guard let expressNode = expressData else { return sliderModel }

        for targetNode in expressNode {
            if let accountMoney = targetNode.accountMoney {
                // TODO: Translation
                let cardData = PXCardDataFactory().create(cardName: "Total en tu cuenta: $ \(accountMoney.availableBalance)", cardNumber: "", cardCode: "", cardExpiration: "")
                sliderModel.append(PXCardSliderViewModel(AccountMoneyCard(), cardData))
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

                    if let issuerId = targetNode.oneTapCard?.cardUI?.issuerId {
                        templateCard.bankImage = ResourceManager.shared.getImage("issuer_\(String(issuerId))")
                    }

                    //ResourceManager.shared.getImageForPaymentMethod(withDescription: targetNode.paymentMethodId)
                    //ResourceManager.shared.getImage("icoTc_" + targetNode.paymentMethodId.lowercased()
                    if let paymentMethodImage = ResourceManager.shared.getImageForPaymentMethod(withDescription: targetNode.paymentMethodId) {
                        templateCard.cardLogoImage = paymentMethodImage
                    }

                    sliderModel.append((templateCard, cardData))
                }
            }
        }
        sliderModel.append(PXCardSliderViewModel(EmptyCard(), nil))
        return sliderModel
    }
}
