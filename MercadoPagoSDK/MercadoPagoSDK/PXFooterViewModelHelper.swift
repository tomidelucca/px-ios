//
//  PXFooterViewModelHelper.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

extension PXResultViewModel {

    func getFooterComponentProps() -> PXFooterProps {
        return PXFooterProps(buttonAction: getActionButton(), linkAction: getActionLink())
    }

    func getActionButton() -> PXFooterAction? {
         var actionButton: PXFooterAction?
        if let label = self.getButtonLabel(), let action = self.getButtonAction() {
            actionButton = PXFooterAction(label: label, action: action)
        }
        return actionButton
    }
    func getActionLink() -> PXFooterAction? {
        var actionLink: PXFooterAction?

        if let labelLink = self.getLinkLabel(), let actionOfLink = self.getLinkAction() {
            actionLink = PXFooterAction(label: labelLink, action: actionOfLink)
        }
        return actionLink
    }

    func getButtonLabel() -> String? {
        if self.isAccepted() {
            if self.paymentResult.isWaitingForPayment() {
                if preference.getPendingSecondaryButtonText() != nil {
                    return preference.getPendingSecondaryButtonText()!
                } else {
                    return nil
                }
            }else if preference.getApprovedSecondaryButtonText() != nil {
                return preference.getApprovedSecondaryButtonText()
            }else {
                return nil
            }
        } else if self.isError() {
            if let labelError = preference.getRejectedSecondaryButtonText() {
                return labelError
            }else {
                return "Pagar con otro medio".localized
            }
        } else if self.isWarning() {
            if let labelWarning = preference.getPendingSecondaryButtonText() {
                return labelWarning
            }else if self.paymentResult.statusDetail == RejectedStatusDetail.CALL_FOR_AUTH || self.paymentResult.statusDetail == RejectedStatusDetail.INSUFFICIENT_AMOUNT {
                return "Pagar con otro medio".localized
            }else if self.paymentResult.statusDetail == RejectedStatusDetail.CARD_DISABLE {
                return "Ya habilité mi tarjeta".localized
            } else {
                return "Revisar los datos de tarjeta".localized
            }
        }
        return nil
    }
    func getLinkLabel() -> String? {
        if let label = preference.getExitButtonTitle() {
            return label
        }
        if self.isAccepted() {
           return "Seguir comprando".localized
        } else if self.isError() {
            return "Cancelar pago".localized
        } else if self.isWarning() {
            if self.paymentResult.statusDetail == RejectedStatusDetail.CALL_FOR_AUTH || self.paymentResult.statusDetail == RejectedStatusDetail.INSUFFICIENT_AMOUNT {
                return "Cancelar pago".localized
            } else {
                return "Pagar con otro medio".localized
            }
        }
        return "Seguir comprando".localized
    }
    func getButtonAction() -> (() -> Void)? {
        if self.isAccepted() {
            if self.paymentResult.isWaitingForPayment() {
                if preference.getPendingSecondaryButtonCallback() != nil {
                    return { self.preference.getPendingSecondaryButtonCallback()!(self.paymentResult) }
                }else {
                    return nil
                }
            }else if preference.getApprovedSecondaryButtonCallback() != nil {
                return { self.preference.getApprovedSecondaryButtonCallback()!(self.paymentResult) }
            }else {
                return nil
            }
        }
        if (self.isWarning() || self.isError()) && preference.getRejectedSecondaryButtonCallback()  != nil {
            return { self.preference.getRejectedSecondaryButtonCallback()!(self.paymentResult)  }
        }
        return { self.pressButton() }
    }
    func getLinkAction() -> (() -> Void)? {

        return { self.pressLink() }
    }

    func pressButton() {

        if self.isAccepted() {
             self.callback(PaymentResult.CongratsState.ok)
        } else if self.isError() {
             self.callback(PaymentResult.CongratsState.cancel_SELECT_OTHER)
        } else if self.isWarning() {
            if self.paymentResult.statusDetail == RejectedStatusDetail.CALL_FOR_AUTH || self.paymentResult.statusDetail == RejectedStatusDetail.INSUFFICIENT_AMOUNT {
                self.callback(PaymentResult.CongratsState.cancel_SELECT_OTHER)
            }else {
                self.callback(PaymentResult.CongratsState.cancel_RETRY)
            }
        }
    }

    func pressLink() {

        if self.isAccepted() {
            self.callback(PaymentResult.CongratsState.ok)
        } else if self.isError() {
            self.callback(PaymentResult.CongratsState.ok) //
        } else if self.isWarning() {
            if self.paymentResult.statusDetail == RejectedStatusDetail.CALL_FOR_AUTH || self.paymentResult.statusDetail == RejectedStatusDetail.INSUFFICIENT_AMOUNT {
                self.callback(PaymentResult.CongratsState.ok)
            }else {
                self.callback(PaymentResult.CongratsState.cancel_SELECT_OTHER)
            }
        }
    }

}
