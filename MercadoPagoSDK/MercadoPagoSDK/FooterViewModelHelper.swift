//
//  FooterViewModelHelper.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

extension PXResultViewModel {

    func getFooterComponentData() -> FooterData {
        return FooterData(buttonAction: getActionButton(), linkAction: getActionLink(), primaryColor: UIColor.primaryColor())
    }

    func getActionButton() -> FooterAction? {
         var actionButton: FooterAction?
        if let label = self.getButtonLabel(), let action = self.getButtonAction() {
            actionButton = FooterAction(label: label, action: action)
        }
        return actionButton
    }
    func getActionLink() -> FooterAction? {
        var actionLink: FooterAction?

        if let labelLink = self.getLinkLabel(), let actionOfLink = self.getLinkAction() {
            actionLink = FooterAction(label: labelLink, action: actionOfLink)
        }
        return actionLink
    }

    func getButtonLabel() -> String? {
        guard let result = self.paymentResult else {
            return nil
        }
        if self.isAccepted() {
            if result.isWaitingForPayment() {
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
            }else if result.statusDetail == RejectedStatusDetail.CALL_FOR_AUTH || result.statusDetail == RejectedStatusDetail.INSUFFICIENT_AMOUNT {
                return "Pagar con otro medio".localized
            }else if result.statusDetail == RejectedStatusDetail.CARD_DISABLE {
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
        guard let result = self.paymentResult else {
            return nil
        }
        if self.isAccepted() {
           return "Seguir comprando".localized
        } else if self.isError() {
            return "Cancelar pago".localized
        } else if self.isWarning() {
            if result.statusDetail == RejectedStatusDetail.CALL_FOR_AUTH || result.statusDetail == RejectedStatusDetail.INSUFFICIENT_AMOUNT {
                return "Cancelar pago".localized
            } else {
                return "Pagar con otro medio".localized
            }
        }
        return "Seguir comprando".localized
    }
    func getButtonAction() -> (() -> Void)? {
        guard let result = self.paymentResult else {
            return { self.pressButton() }
        }
        if self.isAccepted() {
            if result.isWaitingForPayment() {
                if preference.getPendingSecondaryButtonCallback() != nil {
                    return { self.preference.getPendingSecondaryButtonCallback()!(result) }
                }else {
                    return nil
                }
            }else if preference.getApprovedSecondaryButtonCallback() != nil {
                return { self.preference.getApprovedSecondaryButtonCallback()!(result) }
            }else {
                return nil
            }
        }
        if (self.isWarning() || self.isError()) && preference.getRejectedSecondaryButtonCallback()  != nil {
            return { self.preference.getRejectedSecondaryButtonCallback()!(result)  }
        }
        return { self.pressButton() }
    }
    func getLinkAction() -> (() -> Void)? {

        return { self.pressLink() }
    }

    func pressButton() {
        guard let result = self.paymentResult else {
            return
        }

        if self.isAccepted() {
             self.callback(PaymentResult.CongratsState.ok)
        } else if self.isError() {
             self.callback(PaymentResult.CongratsState.cancel_SELECT_OTHER)
        } else if self.isWarning() {
            if result.statusDetail == RejectedStatusDetail.CALL_FOR_AUTH || result.statusDetail == RejectedStatusDetail.INSUFFICIENT_AMOUNT {
                self.callback(PaymentResult.CongratsState.cancel_SELECT_OTHER)
            }else {
                self.callback(PaymentResult.CongratsState.cancel_RETRY)
            }
        }
    }

    func pressLink() {
        guard let result = self.paymentResult else {
            return
        }
        if self.isAccepted() {
            self.callback(PaymentResult.CongratsState.ok)
        } else if self.isError() {
            self.callback(PaymentResult.CongratsState.ok) //
        } else if self.isWarning() {
            if result.statusDetail == RejectedStatusDetail.CALL_FOR_AUTH || result.statusDetail == RejectedStatusDetail.INSUFFICIENT_AMOUNT {
                self.callback(PaymentResult.CongratsState.ok)
            }else {
                self.callback(PaymentResult.CongratsState.cancel_SELECT_OTHER)
            }
        }
    }

}
