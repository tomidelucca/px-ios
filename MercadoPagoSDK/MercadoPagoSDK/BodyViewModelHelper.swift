//
//  BodyViewModelHelper.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 11/27/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

extension PXResultViewModel {
    
    open func bodyComponentProps() -> BodyProps {
        let props = BodyProps(paymentResult: self.paymentResult, amount: self.amount, instruction: getInstrucion())
        return props
    }
    
    open func getInstrucion() -> Instruction? {
        guard let instructionsInfo = self.instructionsInfo else {
            return nil
        }
        return instructionsInfo.getInstruction()
    }
    
    open func getRapipagoProps() -> BodyProps {
        let instruc = Instruction()
        instruc.info = [
            "Dictale este codigo al cajero"
        ]
        instruc.subtitle = "Paga con estos datos"
        instruc.secondaryInfo = ["También enviamos estos datos a tu email"]
        let refer1 = InstructionReference()
        refer1.label = "Codigo"
        refer1.value = ["8442","988"]
        refer1.separator = " "

        instruc.references = [refer1]
        instruc.accreditationMessage = "El pago se acreditara al instante"
        let bodyProps = BodyProps(paymentResult: self.paymentResult, amount: self.amount, instruction: instruc)
        return bodyProps
    }
    
    open func getRedlinkProps() -> BodyProps {
        let instruc = Instruction()
        instruc.info = [
            "Primero sigue estos pasos en el cajero",
            "",
            "1. Ingresa a Pagos",
            "2. Pagos de impuestos y servicios",
            "3. Rubro cobranzas",
            "",
            "Luego te irá pidiendo estos datos"
        ]
        instruc.subtitle = "Paga con estos datos"
        instruc.secondaryInfo = ["También enviamos estos datos a tu email"]
        let refer1 = InstructionReference()
        refer1.label = "Codigo de Link pagos"
        refer1.value = ["0234","9625","061"]
        refer1.separator = " "
        
        let refer2 = InstructionReference()
        refer2.label = "Referencia para abonar"
        refer2.value = ["0008","4429","93"]
        refer2.separator = " "
        
        let refer3 = InstructionReference()
        refer3.label = "Concepto"
        refer3.value = ["MPAGO:COMPRA"]
        refer3.separator = ""
        
        let refer4 = InstructionReference()
        refer4.label = "Empresa"
        refer4.value = ["Mercado Libre - Mercado Pago"]
        refer4.separator = ""
        
        instruc.references = [refer1,refer2,refer3]
        instruc.accreditationMessage = "El pago se acreditara de 1 a 2 días habiles"
        let bodyProps = BodyProps(paymentResult: self.paymentResult, amount: self.amount, instruction: instruc)
        return bodyProps
    }
    
    open func getTestProps() -> BodyProps {
        let instruc = Instruction()
        instruc.info = [
            "Primero sigue estos pasos en el cajero",
            "",
            "1. Ingresa a Pagos",
            "2. Pagos de impuestos y servicios",
            "3. Rubro cobranzas",
            "",
            "Luego te irá pidiendo estos datos"
        ]
        instruc.subtitle = "Paga con estos datos y con estos otros tambien, asi hay 2 renglones"
        instruc.secondaryInfo = ["También enviamos estos datos a tu email", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc lacinia semper magna id commodo. Integer molestie ligula ut mauris sagittis dapibus. Aenean non enim blandit, rhoncus elit eu, ullamcorper elit. Nulla vitae venenatis elit. Praesent ac lorem accumsan, ultricies odio elementum, eleifend tellus. Donec vitae massa ornare, convallis urna id, posuere diam.", "También enviamos"]
        let refer1 = InstructionReference()
        refer1.label = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc lacinia semper magna id commodo"
        refer1.value = ["1234","1234","1234","1234","1234","1234","1234","1234","1234","1234","1234","1234","1234","1234","1234","1234","1234","1234","1234","1234","1234","1234","1234","1234"]
        refer1.separator = " "
        instruc.references = [refer1,refer1,refer1,refer1]
        instruc.tertiaryInfo = [
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin ac varius nunc. Pellentesque sit amet massa lectus. Aenean sem dui, gravida non tellus vel, vulputate ultrices est.",
            "Donec at est a lacus faucibus tincidunt id sed odio. Aenean convallis ultrices metus, et auctor dui dignissim ac. Suspendisse ultrices quam suscipit augue sollicitudin, in auctor urna accumsan. Ut sagittis dui vitae risus imperdiet, at dictum ex molestie. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Fusce quis nibh odio.",
            "Informacion terciaria 3"
        ]
        instruc.accreditationMessage = "Se acreditara en uno o dos dias habiles"
        instruc.accreditationComment = [
            "Donec at est a lacus faucibus tincidunt id sed odio. Aenean convallis ultrices metus, et auctor dui dignissim ac. Suspendisse ultrices quam suscipit augue sollicitudin, in auctor urna accumsan. Ut sagittis dui vitae risus imperdiet, at dictum ex molestie. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Fusce quis nibh odio.",
            "Informacion terciaria 3"
        ]
        let action1 = InstructionAction()
        action1.label = "Ir a banca en linea"
        action1.tag = "link"
        action1.url = "http://www.banamex.com.mx"
        instruc.actions = [action1,action1]
        let bodyProps = BodyProps(paymentResult: self.paymentResult, amount: self.amount, instruction: instruc)
        return bodyProps
    }
}

