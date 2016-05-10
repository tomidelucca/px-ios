//
//  AuthorizePaymentBodyTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 9/5/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class AuthorizePaymentBodyTableViewCell: CallbackCancelTableViewCell, CongratsFillmentDelegate {

    static let ROW_HEIGHT = CGFloat(150)
    
    var alreadyAuthorizedAction : (Void -> Void)?
    
    @IBOutlet weak var completeCardButton: MPButton!
    @IBOutlet weak var cancelButton: MPButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ViewUtils.drawBottomLine(150, width: self.bounds.width, inView: self)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillCell(payment: Payment, callbackCancel: (Void -> Void)?) -> UITableViewCell {
        self.callbackCancel = callbackCancel
        if alreadyAuthorizedAction == nil {
            self.completeCardButton.addTarget(self, action: "invokeCallbackCancel", forControlEvents: .TouchUpInside)
        }
        self.cancelButton.titleLabel?.text = "Elegí otro medio de pago".localized
        self.cancelButton.addTarget(self, action: "invokeCallbackCancel", forControlEvents: .TouchUpInside)
        return self
    }
    
}
