//
//  TermsAndConditionsViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 9/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class TermsAndConditionsViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var termsAndConditionsText: MPTextView!
    @IBOutlet weak var paymentButton: MPButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.paymentButton.layer.cornerRadius = 4
        self.paymentButton.clipsToBounds = true
        
        let normalAttributes: [String:AnyObject] = [NSFontAttributeName : UIFont(name: "ProximaNova-Light", size: 12)!,NSForegroundColorAttributeName: UIColor().UIColorFromRGB(0x999999)]
        
        let mutableAttributedString = NSMutableAttributedString(string: self.termsAndConditionsText.text, attributes: normalAttributes)
        let termsAndConditionsText = self.termsAndConditionsText.text as? NSString
        let tycLinkRange = termsAndConditionsText!.rangeOfString("términos y condiciones".localized)
        //TODO  hardcoded
        mutableAttributedString.addAttribute(NSLinkAttributeName, value: "http://www.mercadopago.com.mx/ayuda/terminos-y-condiciones_715", range: tycLinkRange)
        
        let style = NSMutableParagraphStyle()
        style.alignment = .Center
        
        mutableAttributedString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, mutableAttributedString.length))
        
        self.termsAndConditionsText.userInteractionEnabled = true
        self.termsAndConditionsText.attributedText = mutableAttributedString
    
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        UIApplication.sharedApplication().openURL(URL)
        return false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
