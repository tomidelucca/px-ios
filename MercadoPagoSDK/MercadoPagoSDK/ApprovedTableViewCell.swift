//
//  ApprovedTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/26/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class ApprovedTableViewCell: UITableViewCell {

    @IBOutlet weak var paymentId: UILabel!
    @IBOutlet weak var installments: UILabel!
    @IBOutlet weak var installmentRate: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var paymentMethod: UIImageView!
    @IBOutlet weak var lastFourDigits: UILabel!
    @IBOutlet weak var statement: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func fillCell(payment: Payment){
        paymentId.text = "Nº \(payment._id)"
        
        let currency = MercadoPagoContext.getCurrency()
        //let installmentNumber = "\(payment.installments) x "
        let installmentNumber = payment.installments==1 ? "" : "\(payment.installments) x "
        let totalAmount = Utils.getAttributedAmount(payment.transactionDetails.installmentAmount, thousandSeparator: String(currency.thousandsSeparator), decimalSeparator: String(currency.decimalSeparator), currencySymbol: String(currency.symbol), color:UIColor(red: 51, green: 51, blue: 51), fontSize: 24, baselineOffset:11)
        let installmentLabel = NSMutableAttributedString(string: installmentNumber)
        installmentLabel.append(totalAmount)
        installments.attributedText =  installmentLabel
        
        if payment.installments != 1{
            if payment.transactionDetails.totalPaidAmount != payment.transactionAmount{
                installmentRate.text = ""
            }
            let attributedTotal = NSMutableAttributedString(attributedString: NSAttributedString(string: "( ", attributes: [NSForegroundColorAttributeName : UIColor.black]))
            attributedTotal.append(Utils.getAttributedAmount(payment.transactionDetails.totalPaidAmount, thousandSeparator: String(currency.thousandsSeparator), decimalSeparator: String(currency.decimalSeparator), currencySymbol: String(currency.symbol), color: UIColor.black, fontSize:16, baselineOffset:4))
            attributedTotal.append(NSAttributedString(string: " )", attributes: [NSForegroundColorAttributeName : UIColor.black]))
            total.attributedText = attributedTotal
        } else {
            total.text = ""
            installmentRate.text = ""
        }
        
        paymentMethod.image = MercadoPago.getImage(payment.paymentMethodId)
        
        lastFourDigits.text = payment.paymentMethodId == "account_money" ? "Dinero en cuenta de MercadoPago" : "Terminada en " + String(describing: payment.card.lastFourDigits!)
        statement.text = "En tu estado de cuenta verás el cargo como " + payment.statementDescriptor
        
    }
    func addSeparatorLineToTop(width: Double, y: Int){
        var lineFrame = CGRect(origin: CGPoint(x: 0,y :y), size: CGSize(width: width, height: 0.5))
        var line = UIView(frame: lineFrame)
        line.alpha = 0.6
        line.backgroundColor = UIColor(red: 153, green: 153, blue: 153)
        addSubview(line)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
