//
//  PXResultAddCardFailedViewModel.swift
//  MercadoPagoSDKV4
//
//  Created by Diego Flores Domenech on 24/9/18.
//

import UIKit

class PXResultAddCardFailedViewModel: PXResultViewModelInterface {
    
    let buttonCallback: () -> ()
    let linkCallback: () -> ()
    
    init(buttonCallback: @escaping () -> (), linkCallback: @escaping () -> ()) {
        self.buttonCallback = buttonCallback
        self.linkCallback = linkCallback
    }
    
    func getPaymentData() -> PXPaymentData {
        return PXPaymentData()
    }
    
    func primaryResultColor() -> UIColor {
        return ThemeManager.shared.warningColor()
    }
    
    func setCallback(callback: @escaping (PaymentResult.CongratsState) -> Void) {
        
    }
    
    func getPaymentStatus() -> String {
        return ""
    }
    
    func getPaymentStatusDetail() -> String {
        return ""
    }
    
    func getPaymentId() -> String? {
        return nil
    }
    
    func isCallForAuth() -> Bool {
        return false
    }
    
    func buildHeaderComponent() -> PXHeaderComponent {
        let props = PXHeaderProps(labelText: NSAttributedString(string: "Algo salió mal...".localized), title: NSAttributedString(string: "No pudimos cargar los datos de tu tarjeta".localized, attributes: [NSAttributedStringKey.font: UIFont.ml_regularSystemFont(ofSize: 26)]), backgroundColor: ThemeManager.shared.warningColor(), productImage: UIImage(named: "card_icon", in: ResourceManager.shared.getBundle(), compatibleWith: nil), statusImage: UIImage(named: "need_action_badge", in: ResourceManager.shared.getBundle(), compatibleWith: nil))
        let header = PXHeaderComponent(props: props)
        return header
    }
    
    func buildFooterComponent() -> PXFooterComponent {
        let buttonAction = PXAction(label: "Intentar de nuevo".localized, action: self.buttonCallback)
        let linkAction = PXAction(label: "Ir a Mis tarjetas".localized, action: self.linkCallback)
        let props = PXFooterProps(buttonAction: buttonAction, linkAction: linkAction, primaryColor: UIColor.ml_meli_blue(), animationDelegate: nil)
        let footer = PXFooterComponent(props: props)
        return footer
    }
    
    func buildReceiptComponent() -> PXReceiptComponent? {
        return nil
    }
    
    func buildBodyComponent() -> PXComponentizable? {
        return nil
    }
    
    func buildTopCustomView() -> UIView? {
        return nil
    }
    
    func buildBottomCustomView() -> UIView? {
        return nil
    }
    
    func trackInfo() {
        
    }
    

}
