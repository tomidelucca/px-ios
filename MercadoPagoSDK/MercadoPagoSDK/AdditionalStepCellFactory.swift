//
//  AdditionalStepCellFactory.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 4/6/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation
import UIKit

class AdditionalStepCellFactory: NSObject {
    
    open class func buildCell(object: Cellable, width: Double, height: Double) -> UITableViewCell {
        
        if object.objectType == "payer_cost" {
            let bundle = MercadoPago.getBundle()
            let cell: PayerCostRowTableViewCell = bundle!.loadNibNamed("PayerCostRowTableViewCell", owner: nil, options: nil)?[0] as! PayerCostRowTableViewCell
            let showDescription = MercadoPagoCheckout.showPayerCostDescription()
            cell.fillCell(payerCost: object as! PayerCost, showDescription: showDescription)
            cell.addSeparatorLineToBottom(width: width, height: height)
            cell.selectionStyle = .none
            
            return cell
        }
        
        if object.objectType == "issuer" {
            let bundle = MercadoPago.getBundle()
            let cell: IssuerRowTableViewCell = bundle!.loadNibNamed("IssuerRowTableViewCell", owner: nil, options: nil)?[0] as! IssuerRowTableViewCell
            cell.fillCell(issuer: object as! Issuer, bundle: bundle!)
            cell.addSeparatorLineToBottom(width: width, height: height)
            cell.selectionStyle = .none
            
            return cell
        }
        
        if object.objectType == "entity_type" {
            let bundle = MercadoPago.getBundle()
            let cell: EntityTypeTableViewCell = bundle!.loadNibNamed("EntityTypeTableViewCell", owner: nil, options: nil)?[0] as! EntityTypeTableViewCell
            cell.fillCell(entityType: object as! EntityType)
            cell.addSeparatorLineToBottom(width: width, height: height)
            cell.selectionStyle = .none
            
            return cell
        }
        
        if object.objectType == "financial_instituions" {
            let bundle = MercadoPago.getBundle()
            let cell: FinancialInstitutionTableViewCell = bundle!.loadNibNamed("FinancialInstitutionTableViewCell", owner: nil, options: nil)?[0] as! FinancialInstitutionTableViewCell
            cell.fillCell(financialInstitution: object as! FinancialInstitution, bundle: bundle!)
            cell.addSeparatorLineToBottom(width: width, height: height)
            cell.selectionStyle = .none
            
            return cell
        }
        
        if object.objectType == "payment_method" {
            let bundle = MercadoPago.getBundle()
            let cell: CardTypeTableViewCell = bundle!.loadNibNamed("CardTypeTableViewCell", owner: nil, options: nil)?[0] as! CardTypeTableViewCell
            cell.setPaymentMethod(paymentMethod: object as! PaymentMethod)
            cell.addSeparatorLineToBottom(width: width, height: height)
            cell.selectionStyle = .none
            
            return cell
        }
        
        let defaultCell = UITableViewCell()
        defaultCell.textLabel?.text = "Default Cell"
        
        return defaultCell
    }
    
}
