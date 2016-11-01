//
//  RejectedTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/28/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class RejectedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitile: UILabel!
    @IBOutlet weak var button: UIButton!
    var callback: ((_ payment : Payment, _ status : MPStepBuilder.CongratsState) -> Void)? = nil
    var payment: Payment? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        button.layer.cornerRadius = 3
    }
    func setCallback(callback: @escaping ((_ payment : Payment, _ status : MPStepBuilder.CongratsState) -> Void)){
        self.callback = callback
    }
    func fillCell (payment: Payment){
        if payment.status == "rejected"{
            if payment.statusDetail == "cc_rejected_call_for_authorize"{
                var title = (payment.statusDetail + "_title")
                self.title.text = title.localized
                self.subtitile.text = ""
            } else {
                var title = (payment.statusDetail + "_subtitle_" + payment.paymentTypeId)
                
                if !title.existsLocalized() {
                    title = ""
                }
                self.subtitile.text = title.localized
            }
        } else {
            self.subtitile.text = "En menos de 1 hora te enviaremos por e-mail el resultado."
        }
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //callback!(self.payment!, MPStepBuilder.CongratsState.cancel_RETRY)
        // Configure the view for the selected state
    }
    
}
