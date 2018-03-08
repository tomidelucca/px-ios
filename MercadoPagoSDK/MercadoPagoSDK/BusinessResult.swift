//
//  BusinessResult.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 8/3/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

enum BusinessResultStatus {
    case APPROVED
    case REJECTED
    case PENDING
}

/*
 Esta clase representa un resultado de pago de negocio.
 Por ejemplo, cuando hay un error al momento de realizar un pago que tiene que ver con el negocio y no con el payment method.
 */
class BusinessResult: NSObject {

    var status : BusinessResultStatus
    var titleResult : String
    var relatedIcon : UIImage
    var principalAction : PXAction?
    var secundaryAction : PXAction?
    var instructionComponent : PXComponent?
    
    init(status : BusinessResultStatus, titleResult : String, relatedIcon : UIImage, principalAction : PXAction?, secundaryAction : PXAction?, instructionComponent : PXComponent?) {
        self.status = status
        self.titleResult = titleResult
        self.relatedIcon = relatedIcon
        self.principalAction = principalAction
        self.secundaryAction = secundaryAction
        self.instructionComponent = instructionComponent
        super.init()
    }
    
}
