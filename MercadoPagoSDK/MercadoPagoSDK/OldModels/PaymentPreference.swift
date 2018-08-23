//
//  PreferencePaymentMethods.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 12/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoServicesV4

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

private func <= <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l__?, r__?):
    return l__ <= r__
  default:
    return !(rhs < lhs)
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

internal class PaymentPreference {
    var excludedPaymentMethodIds: Set<String>?
    var excludedPaymentTypeIds: Set<String>?
    var defaultPaymentMethodId: String?
    var maxAcceptedInstallments: Int = 0
    var defaultInstallments: Int = 0
    var defaultPaymentTypeId: String?
    var cardId: String?

    internal class func fromJSON(_ json: NSDictionary) -> PaymentPreference {
               let preferencePaymentMethods = PaymentPreference()

               var excludedPaymentMethods = Set<String>()
                if let pmArray = json["excluded_payment_methods"] as? NSArray {
                       for index in 0..<pmArray.count {
                                if let pmDic = pmArray[index] as? NSDictionary {
                                        let pmDicValue = pmDic.value(forKey: "id") as? String
                                        if pmDicValue != nil && pmDicValue!.count > 0 {
                                                excludedPaymentMethods.insert(pmDicValue!)
                                            }
                                    }
                           }
                        preferencePaymentMethods.excludedPaymentMethodIds = excludedPaymentMethods
                    }

                var excludedPaymentTypesIds = Set<String>()
                if let ptArray = json["excluded_payment_types"] as? NSArray {
                        for index in 0..<ptArray.count {
                                if let ptDic = ptArray[index] as? NSDictionary {
                                        let ptDicValue = ptDic.value(forKey: "id") as? String
                                        if ptDicValue != nil && ptDicValue?.count > 0 {
                                                excludedPaymentTypesIds.insert(ptDicValue!)
                                            }
                                    }
                            }
                        preferencePaymentMethods.excludedPaymentTypeIds = Set<String>(excludedPaymentTypesIds)
                    }

                if let defaultPaymentMethodId = JSONHandler.attemptParseToString(json["default_payment_method_id"]) {
                        preferencePaymentMethods.defaultPaymentMethodId = defaultPaymentMethodId
                    }
                if let maxAcceptedInstallments = JSONHandler.attemptParseToInt(json["installments"]) {
                        preferencePaymentMethods.maxAcceptedInstallments = maxAcceptedInstallments
                    }
                if let defaultInstallments = JSONHandler.attemptParseToInt(json["default_installments"]) {
                        preferencePaymentMethods.defaultInstallments = defaultInstallments
                    }

                return preferencePaymentMethods
            }

    internal func autoSelectPayerCost(_ payerCostList: [PXPayerCost]) -> PXPayerCost? {
        if payerCostList.count == 0 {
            return nil
        }
        if payerCostList.count == 1 {
            return payerCostList.first
        }

            for payercost in payerCostList where payercost.installments == defaultInstallments {
                return payercost
            }

        if (payerCostList.first?.installments <= maxAcceptedInstallments)
            && (payerCostList[1].installments > maxAcceptedInstallments) {
                return payerCostList.first
        } else {
            return nil
        }

    }

    internal func validate() -> Bool {
        if maxAcceptedInstallments <= 0 {
            return false
        }
        if PaymentType.allPaymentIDs.count <= excludedPaymentTypeIds?.count {
            return false
        }

        return true
    }

    internal func getExcludedPaymentTypesIds() -> Set<String>? {
        if excludedPaymentTypeIds != nil {
            return excludedPaymentTypeIds
        }
        return nil
    }

    internal func getDefaultInstallments() -> Int {
        if defaultInstallments > 0 {
            return defaultInstallments
        }
        return 0
    }

    internal func getMaxAcceptedInstallments() -> Int {
        if maxAcceptedInstallments > 0 {
            return maxAcceptedInstallments
        }
        return 0
    }

    internal func getExcludedPaymentMethodsIds() -> Set<String>? {
        if excludedPaymentMethodIds != nil {
            return excludedPaymentMethodIds
        }
        return nil
    }

    internal func getDefaultPaymentMethodId() -> String? {
        if defaultPaymentMethodId != nil && defaultPaymentMethodId!.isNotEmpty {
            return defaultPaymentMethodId
        }
        return nil
    }

    internal func addSettings(_ defaultPaymentTypeId: String? = nil, excludedPaymentMethodsIds: Set<String>? = nil, excludedPaymentTypesIds: Set<String>? = nil, defaultPaymentMethodId: String? = nil, maxAcceptedInstallment: Int? = nil, defaultInstallments: Int? = nil) -> PaymentPreference {

        if excludedPaymentMethodsIds != nil {
           self.excludedPaymentMethodIds =  excludedPaymentMethodsIds
        }

        if excludedPaymentTypesIds != nil {
            self.excludedPaymentTypeIds = excludedPaymentTypesIds
        }

        if defaultPaymentMethodId != nil {
             self.defaultPaymentMethodId = defaultPaymentMethodId
        }

        if maxAcceptedInstallment != nil {
            self.maxAcceptedInstallments = maxAcceptedInstallment!
        }

        if defaultInstallments != nil {
            self.defaultInstallments = defaultInstallments!
        }

        if defaultPaymentTypeId != nil {
            self.defaultPaymentTypeId = defaultPaymentTypeId
        }

        return self
    }
}
