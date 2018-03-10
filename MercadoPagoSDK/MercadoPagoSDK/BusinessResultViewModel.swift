//
//  BusinessResultViewModel.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 8/3/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

class BusinessResultViewModel: NSObject, PXResultViewModelInterface {
    
    let businessResult : PXBusinessResult
    let paymentData : PaymentData
    
    init(businessResult : PXBusinessResult, paymentData : PaymentData) {
        self.businessResult = businessResult
        self.paymentData = paymentData
        super.init()
    }
    
    func getPaymentData() -> PaymentData {
        return self.paymentData
    }
    
    func primaryResultColor() -> UIColor {
        
        switch self.businessResult.status {
        case .APPROVED:
            return ThemeManager.shared.getTheme().successColor()
        case .REJECTED:
            return ThemeManager.shared.getTheme().rejectedColor()
        case .PENDING:
            return ThemeManager.shared.getTheme().warningColor()
        default:
             return .pxWhite
        }
        
    }
    
    func setCallback(callback: @escaping (PaymentResult.CongratsState) -> Void) {
        // Nothing to do
    }
    
    func getPaymentStatus() -> String {
        return businessResult.status.rawValue
    }
    
    func getPaymentStatusDetail() -> String {
        return businessResult.status.rawValue
    }
    
    func getPaymentId() -> String? {
       return  businessResult.receiptId
    }
    
    func isCallForAuth() -> Bool {
        return false
    }
    
    func getBadgeImage() -> UIImage? {
        switch self.businessResult.status {
        case .APPROVED:
            return MercadoPago.getImage("ok_badge")
        case .REJECTED:
            return MercadoPago.getImage("error_badge")
        case .PENDING:
            return MercadoPago.getImage("pending_badge")
        default:
            return nil
        }
    }
    func buildHeaderComponent() -> PXHeaderComponent {
        let headerProps = PXHeaderProps(labelText: businessResult.titleResult.toAttributedString(), title: (businessResult.subTitleResult?.toAttributedString())!, backgroundColor: primaryResultColor(), productImage: businessResult.relatedIcon, statusImage: getBadgeImage())
        return PXHeaderComponent(props: headerProps)
    }
    
    func buildFooterComponent() -> PXFooterComponent {
        let footerProps = PXFooterProps(buttonAction: businessResult.principalAction, linkAction: businessResult.secundaryAction)
        return PXFooterComponent(props: footerProps)
    }
    
    func buildReceiptComponent() -> PXReceiptComponent? {
        guard let recieptId = businessResult.receiptId else {
            return nil
        }
        let date = Date()
        let recieptProps = PXReceiptProps(dateLabelString: Utils.getFormatedStringDate(date), receiptDescriptionString: "Número de operación ".localized + recieptId)
        return PXReceiptComponent(props: recieptProps)
    }
    
    func buildBodyComponent() -> PXBodyComponent? {
        return nil
    }
    
    func buildTopCustomComponent() -> PXCustomComponentizable? {
        return nil
    }
    
    func buildBottomCustomComponent() -> PXCustomComponentizable? {
        return nil
    }
    

}
