//
//  PXResultAddCardSuccessViewModel.swift
//  MercadoPagoSDKV4
//
//  Created by Diego Flores Domenech on 24/9/18.
//

import UIKit

protocol PXResultAddCardViewModel {
    var buttonCallback: () -> () { get }
    var linkCallback: () -> () { get }
    init(buttonCallback: @escaping () -> (), linkCallback: @escaping () -> ())
}

class PXResultAddCardSuccessViewModel: PXResultViewModelInterface, PXResultAddCardViewModel {
    
    let buttonCallback: () -> ()
    let linkCallback: () -> ()
    
    required init(buttonCallback: @escaping () -> (), linkCallback: @escaping () -> ()) {
        self.buttonCallback = buttonCallback
        self.linkCallback = linkCallback
    }
    
    func getPaymentData() -> PXPaymentData {
        return PXPaymentData()
    }
    
    func primaryResultColor() -> UIColor {
        return ThemeManager.shared.successColor()
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
        let props = PXHeaderProps(labelText: nil, title: NSAttributedString(string: "¡Listo! Tu tarjeta quedó guardada"), backgroundColor: ThemeManager.shared.successColor(), productImage: UIImage(named: "card_icon", in: ResourceManager.shared.getBundle(), compatibleWith: nil), statusImage: UIImage(named: "ok_badge", in: ResourceManager.shared.getBundle(), compatibleWith: nil))
        let header = PXHeaderComponent(props: props)
        return header
    }
    
    func buildFooterComponent() -> PXFooterComponent {
        let buttonAction = PXAction(label: "Cargar otra tarjeta", action: self.buttonCallback)
        let linkAction = PXAction(label: "Ir al inicio", action: self.linkCallback)
        let props = PXFooterProps(buttonAction: buttonAction, linkAction: linkAction, primaryColor: UIColor.ml_meli_blue(), animationDelegate: nil)
        let footer = PXFooterComponent(props: props)
        return footer
    }
    
    func buildReceiptComponent() -> PXReceiptComponent? {
        return nil
    }
    
    func buildBodyComponent() -> PXComponentizable? {
        return PXAddCardCongratsBodyComponent()
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
