//
//  PXPayment.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

private func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l__?, r__?):
    return l__ < r__
  case (nil, _?):
    return true
  default:
    return false
  }
}

private func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l__?, r__?):
    return l__ > r__
  default:
    return rhs < lhs
  }
}

/**
 This is our Payment object. When we make the payment, we return this object in the checkout exit. More details in: `PXLifeCycleProtocol` finishCheckout method.
 */
@objcMembers open class PXPayment: NSObject {
    // MARK: Public accessors.
    /**
     * binaryMode
     */
    open var binaryMode: Bool!
    /**
     * callForAuthorizeId
     */
    open var callForAuthorizeId: String!
    /**
     * captured
     */
    open var captured: Bool!
    /**
     * card
     */
    open var card: Card!
    /**
     * currencyId
     */
    open var currencyId: String!
    /**
     * dateApproved
     */
    open var dateApproved: Date!
    /**
     * dateCreated
     */
    open var dateCreated: Date!
    /**
     * dateLastUpdated
     */
    open var dateLastUpdated: Date!
    /**
     * paymentDescription
     */
    open var paymentDescription: String!
    /**
     * externalReference
     */
    open var externalReference: String!
    /**
     * feesDetails
     */
    open var feesDetails: [FeesDetail]!
    /**
     * paymentId
     */
    open var paymentId: String = ""
    /**
     * installments
     */
    open var installments: Int = 0
    /**
     * liveMode
     */
    open var liveMode: Bool!
    /**
     * metadata
     */
    open var metadata: NSObject!
    /**
     * moneyReleaseDate
     */
    open var moneyReleaseDate: Date!
    /**
     * notificationUrl
     */
    open var notificationUrl: String!
    /**
     * order
     */
    open var order: Order!
    /**
     * payer
     */
    open var payer: Payer!
    /**
     * paymentMethodId
     */
    open var paymentMethodId: String!
    /**
     * paymentTypeId
     */
    open var paymentTypeId: String!
    /**
     * refunds
     */
    open var refunds: [Refund]!
    /**
     * statementDescriptor
     */
    open var statementDescriptor: String!
    /**
     * status
     */
    open var status: String!
    /**
     * statusDetail
     */
    open var statusDetail: String!
    /**
     * transactionAmount
     */
    open var transactionAmount: Double = 0
    /**
     * transactionAmountRefunded
     */
    open var transactionAmountRefunded: Double = 0
    /**
     * transactionDetails
     */
    open var transactionDetails: TransactionDetails!
    /**
     * collectorId
     */
    open var collectorId: String!
    /**
     * couponAmount
     */
    open var couponAmount: Double = 0
    /**
     * differentialPricingId
     */
    open var differentialPricingId: NSNumber = 0
    /**
     * issuerId
     */
    open var issuerId: Int = 0
    /**
     * tokenId
     */
    open var tokenId: String?

    /// :nodoc:
    override public init() {
        super.init()
    }

    internal class func fromJSON(_ json: NSDictionary) -> PXPayment {
                let payment: PXPayment = PXPayment()

                if let paymentId = JSONHandler.attemptParseToString(json["id"]) {
                        payment.paymentId = paymentId
                    }
                if let binaryMode = JSONHandler.attemptParseToBool(json["binary_mode"]) {
                        payment.binaryMode = binaryMode
                    }
                if let captured = JSONHandler.attemptParseToBool(json["captured"]) {
                        payment.captured = captured
                    }
                if let currencyId = JSONHandler.attemptParseToString(json["currency_id"]) {
                        payment.currencyId = currencyId
                    }
                if let moneyReleaseDate = JSONHandler.attemptParseToString(json["money_release_date"]) {
                        payment.moneyReleaseDate = Utils.getDateFromString(moneyReleaseDate)
                    }
                if let dateCreated = JSONHandler.attemptParseToString(json["date_created"]) {
                        payment.dateCreated = Utils.getDateFromString(dateCreated)
                    }
                if let dateLastUpdated = JSONHandler.attemptParseToString(json["date_last_updated"]) {
                        payment.dateLastUpdated = Utils.getDateFromString(dateLastUpdated)
                    }
                if let dateApproved = JSONHandler.attemptParseToString(json["date_approved"]) {
                        payment.dateApproved = Utils.getDateFromString(dateApproved)
                    }
                if let paymentDescription = JSONHandler.attemptParseToString(json["description"]) {
                        payment.paymentDescription = paymentDescription
                    }
                if let externalReference = JSONHandler.attemptParseToString(json["external_reference"]) {
                        payment.externalReference = externalReference
                    }
                if let installments = JSONHandler.attemptParseToInt(json["installments"]) {
                        payment.installments = installments
                    }
                if let liveMode = JSONHandler.attemptParseToBool(json["live_mode"]) {
                        payment.liveMode = liveMode
                    }
                if let notificationUrl = JSONHandler.attemptParseToString(json["notification_url"]) {
                        payment.notificationUrl = notificationUrl
                    }
                var feesDetails: [FeesDetail] = [FeesDetail]()
                if let feesDetailsArray = json["fee_details"] as? NSArray {
                        for index in 0..<feesDetailsArray.count {
                                if let feedDic = feesDetailsArray[index] as? NSDictionary {
                                        feesDetails.append(FeesDetail.fromJSON(feedDic))
                                    }
                            }
                    }
                payment.feesDetails = feesDetails
                let cardDic = json["card"] as? NSDictionary
                if cardDic != nil && cardDic?.count > 0 {
                        payment.card = Card.fromJSON(cardDic!)
                    }
                if let orderDic = json["order"] as? NSDictionary {
                        payment.order = Order.fromJSON(orderDic)
                    }
                if let payerDic = json["payer"] as? NSDictionary {
                        payment.payer = Payer.fromJSON(payerDic)
                    }
                if let paymentMethodId = JSONHandler.attemptParseToString(json["payment_method_id"]) {
                        payment.paymentMethodId = paymentMethodId
                    }
                if let paymentTypeId = JSONHandler.attemptParseToString(json["payment_type_id"]) {
                        payment.paymentTypeId = paymentTypeId
                    }
                var refunds: [Refund] = [Refund]()
                if let refArray = json["refunds"] as? NSArray {
                        for index in 0..<refArray.count {
                                if let refDic = refArray[index] as? NSDictionary {
                                        refunds.append(Refund.fromJSON(refDic))
                                    }
                            }
                    }
                payment.refunds = refunds
                if let statementDescriptor = JSONHandler.attemptParseToString(json["statement_descriptor"]) {
                        payment.statementDescriptor = statementDescriptor
                    }
                if let status = JSONHandler.attemptParseToString(json["status"]) {
                        payment.status = status
                    }
                if let statusDetail = JSONHandler.attemptParseToString(json["status_detail"]) {
                        payment.statusDetail = statusDetail
                    }
                if let transactionAmount = JSONHandler.attemptParseToDouble(json["transaction_amount"]) {
                        payment.transactionAmount = transactionAmount
                    }

                if let transactionAmountRefunded = JSONHandler.attemptParseToDouble(json["transaction_amount_refunded"]) {
                        payment.transactionAmountRefunded = transactionAmountRefunded
                    }
                if let tdDic = json["transaction_details"] as? NSDictionary {
                        payment.transactionDetails = TransactionDetails.fromJSON(tdDic)
                    }
                if let collectorId = JSONHandler.attemptParseToString(json["collector_id"]) {
                        payment.collectorId = collectorId
                    }
                if let couponAmount = JSONHandler.attemptParseToDouble(json["coupon_amount"]) {
                        payment.couponAmount = couponAmount
                    }
                if let differentialPricingId = JSONHandler.attemptParseToString(json["differential_pricing_id"])?.numberValue {
                        payment.differentialPricingId = differentialPricingId
                    }

                if let issuerId = JSONHandler.attemptParseToInt(json["issuer_id"]) {
                        payment.issuerId = issuerId
                   }

                if let tokenId = JSONHandler.attemptParseToString(json["token"]) {
                        payment.tokenId = tokenId
                    }

                return payment
            }

    internal func toJSONString() -> String {
        let obj: [String: Any] = [
            "id": String(describing: self.paymentId),
            "transaction_amount": self.transactionAmount,
            "tokenId": self.tokenId == nil ? "" : self.tokenId!,
            "issuerId": self.issuerId,
            "description": self.paymentDescription,
            "installments": self.installments == 0 ? 0 : self.installments,
            "payment_method_id": self.paymentMethodId,
            "status": self.status,
            "status_detail": self.statusDetail,
            "card": card == nil ? "" : card.toJSONString()
        ]
        return JSONHandler.jsonCoding(obj)
    }

    internal func isRejected() -> Bool {
        return self.status == PXPaymentStatus.REJECTED.rawValue
    }
}
