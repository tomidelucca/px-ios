//
//  PXBusinessResult.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 8/3/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

enum PXBusinessResultStatus: String {
    case APPROVED = "APPROVED"
    case REJECTED = "REJECTED"
    case PENDING = "PENDING"
}

/*
 Esta clase representa un resultado de pago de negocio.
 Por ejemplo, cuando hay un error al momento de realizar un pago que tiene que ver con el negocio y no con el payment method.
 */
class PXBusinessResult: NSObject {

    var status : PXBusinessResultStatus // APPROVED REJECTED PENDING
    var titleResult : String // Titluo de Congrats
    var relatedIcon : UIImage  // Icono de Congrats
    var principalAction : PXAction? // Boton principal (Azul)
    var secundaryAction : PXAction? // Boton secundario (link) - Si no se setea usamos nuestro default
    var instructionText : String? // Texto
    /* De momento es inaccesible */private var showPaymentMethod : Bool = false // Si quiere que muestre la celda de PM
    
    //Datos que actualmente devuelve la procesadora de pagos
    var paymentStatus: PXPaymentMethodPlugin.RemotePaymentStatus
    var statusDetails: String = ""
    var receiptId: String? = nil
    //------
    
    init(paymentStatus: PXPaymentMethodPlugin.RemotePaymentStatus, statusDetails: String = "", receiptId: String? = nil, status : PXBusinessResultStatus, titleResult : String, relatedIcon : UIImage, principalAction : PXAction? = nil, secundaryAction : PXAction? = nil, instructionText : String? = nil /*, showPaymentMethod : Bool = false*/ ) { // De momento no dejamos configurar el showPaymentMethod
        self.paymentStatus = paymentStatus
        self.statusDetails = statusDetails
        self.receiptId = receiptId
        self.status = status
        self.titleResult = titleResult
        self.relatedIcon = relatedIcon
        self.principalAction = principalAction
        self.secundaryAction = secundaryAction
        self.instructionText = instructionText
        super.init()
    }    
}
