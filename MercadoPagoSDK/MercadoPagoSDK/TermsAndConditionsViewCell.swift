//
//  TermsAndConditionsViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 9/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class TermsAndConditionsViewCell: UITableViewCell, UITextViewDelegate {

    static let ROW_HEIGHT = CGFloat(60)
    
    @IBOutlet weak var termsAndConditionsText: MPTextView!
    
    var delegate : TermsAndConditionsDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.termsAndConditionsText.text = "Al pagar, afirmo que soy mayor de edad y acepto los Términos y Condiciones de Mercado Pago".localized
        let normalAttributes: [String:AnyObject] = [NSFontAttributeName : UIFont(name:MercadoPago.DEFAULT_FONT_NAME, size: 12) ?? UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName: UIColor.UIColorFromRGB(0x999999)]
        
        let mutableAttributedString = NSMutableAttributedString(string: self.termsAndConditionsText.text, attributes: normalAttributes)
        let tycLinkRange = (self.termsAndConditionsText.text as NSString).range(of: "Términos y Condiciones".localized)
        
        mutableAttributedString.addAttribute(NSLinkAttributeName, value: MercadoPagoContext.getTermsAndConditionsSite(), range: tycLinkRange)
        self.termsAndConditionsText.delegate = self
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineSpacing = CGFloat(6)
        
        mutableAttributedString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, mutableAttributedString.length))
        
        self.termsAndConditionsText.isUserInteractionEnabled = true
        
        self.termsAndConditionsText.attributedText = mutableAttributedString
    
        self.contentView.layer.borderColor = UIColor.grayTableSeparator().cgColor
        self.contentView.layer.borderWidth = 1.0
        
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        self.delegate?.openTermsAndConditions("Términos y Condiciones".localized, url : URL)
        return false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    public func getCellHeight() -> Float {
        var constraintSize = CGSize()
        let screenSize: CGRect = UIScreen.main.bounds
        constraintSize.width = screenSize.width - 46
        
        let text = self.termsAndConditionsText.text
        
        let attributes = [NSFontAttributeName: UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 12) ?? UIFont.systemFont(ofSize: 12)]
        
        let frame = text?.boundingRect(with: constraintSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        let stringSize = frame?.size
        return Float(128) + Float(stringSize!.height)
    }
    
}

protocol TermsAndConditionsDelegate {
    
    func openTermsAndConditions(_ title : String, url : URL)
}


