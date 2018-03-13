//
//  PXBusinessResult.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 8/3/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

@objc public enum PXBusinessResultStatus: Int {
    case APPROVED
    case REJECTED
    case PENDING
    case IN_PROGRESS
    
    func getDescription() -> String {
        switch self {
        case .APPROVED : return "APPROVED"
        case .REJECTED  : return "REJECTED"
        case .PENDING   : return "PENDING"
        case .IN_PROGRESS : return "IN PROGRESS"
        }
    }
}

/*
 Esta clase representa un resultado de pago de negocio.
 Por ejemplo, cuando hay un error al momento de realizar un pago que tiene que ver con el negocio y no con el payment method.
 */
open class PXBusinessResult: NSObject {

    var status : PXBusinessResultStatus // APPROVED REJECTED PENDING
    var titleResult : String // Titluo de Congrats
    var subTitleResult : String? // Sub Titluo de Congrats
    var relatedIcon : UIImage  // Icono de Congrats
    var principalAction : PXAction? // Boton principal (Azul)
    var secundaryAction : PXAction // Boton secundario (link) - Obligatoria
    var instructionText : String? // Texto
    /* De momento es inaccesible */private var showPaymentMethod : Bool = false // Si quiere que muestre la celda de PM
    
    //Datos que actualmente devuelve la procesadora de pagos
    var receiptId: String? = nil
    //------
    
    public init(receiptId: String? = nil, status : PXBusinessResultStatus, titleResult : String,subTitleResult :String? = nil, relatedIcon : UIImage, principalAction : PXAction? = nil, secundaryAction : PXAction, instructionText : String? = nil /*, showPaymentMethod : Bool = false*/ ) { // De momento no dejamos configurar el showPaymentMethod
        self.receiptId = receiptId
        self.status = status
        self.titleResult = titleResult
        self.subTitleResult = subTitleResult
        self.relatedIcon = relatedIcon
        self.principalAction = principalAction
        self.secundaryAction = secundaryAction
        self.instructionText = instructionText
        super.init()
    }    
}
