//
//  ReviewScreenPreference.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 2/14/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

open class ReviewScreenPreference: NSObject {

    private var title = "Confirma tu compra".localized
    private var productsTitle = "Products".localized
    private var confirmButtonText = "Confirmar".localized
    private var cancelButtonText = "Cancelar Pago".localized
    
    open func setTitle(title : String){
        self.title = title
    }
    
    open func getTitle() -> String {
        return title
    }
    
    open func setProductsDeteail(productsTitle : String) {
        self.productsTitle = productsTitle
    }
    
    open func getProductsTitle() -> String {
        return self.productsTitle
    }
    
    open func setConfirmButtonText(confirmButtonText : String){
        self.confirmButtonText = confirmButtonText
    }
    
    open func getConfirmButtonText() -> String {
        return confirmButtonText
    }
    
    open func setCancelButtonText(cancelButtonText : String){
        self.cancelButtonText = cancelButtonText
    }
    
    open func getCancelButtonTitle() -> String {
        return cancelButtonText
    }
    
}
