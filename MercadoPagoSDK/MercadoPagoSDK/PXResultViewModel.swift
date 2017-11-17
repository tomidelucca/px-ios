//
//  PXResultViewModel.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 20/10/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

public class PXResultViewModel: NSObject {

    open var paymentResult: PaymentResult?
    open var instructionsInfo: InstructionsInfo?
    open var preference: PaymentResultScreenPreference
    var callback: ((PaymentResult.CongratsState) -> Void)!

    init(paymentResult: PaymentResult? = nil, instructionsInfo: InstructionsInfo? = nil, paymentResultScreenPreference: PaymentResultScreenPreference = PaymentResultScreenPreference()) {
        self.paymentResult = paymentResult
        self.instructionsInfo = instructionsInfo
        self.preference =  paymentResultScreenPreference
    }

    func primaryResultColor() -> UIColor {
        if isAccepted() {
            return .pxGreenMp
        }
        if isError() {
            return .pxRedMp
        }
        if isWarning() {
            return .pxOrangeMp
        }
        return .white
    }

    func isAccepted() -> Bool {
        guard let result = self.paymentResult else {
            return false
        }
        if result.isApproved() || result.isInProcess() || result.isPending() {
            return true
        }else {
            return false
        }
    }

    func isWarning() -> Bool {
        guard let result = self.paymentResult else {
            return false
        }
        if !result.isRejected() {
            return false
        }
        if result.statusDetail == RejectedStatusDetail.INVALID_ESC || result.statusDetail == RejectedStatusDetail.CALL_FOR_AUTH || result.statusDetail == RejectedStatusDetail.BAD_FILLED_CARD_NUMBER || result.statusDetail == RejectedStatusDetail.CARD_DISABLE || result.statusDetail == RejectedStatusDetail.INSUFFICIENT_AMOUNT || result.statusDetail == RejectedStatusDetail.BAD_FILLED_DATE || result.statusDetail == RejectedStatusDetail.BAD_FILLED_SECURITY_CODE || result.statusDetail == RejectedStatusDetail.BAD_FILLED_OTHER {
            return true
        }

        return false
    }
    func isError() -> Bool {
        guard let result = self.paymentResult else {
            return true
        }
        if !result.isRejected() {
            return false
        }
        return !isWarning()
    }

}
