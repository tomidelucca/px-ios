//
//  BankDeal.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 22/5/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import Foundation
import MercadoPagoServicesV4

@objcMembers open class BankDeal: NSObject {

	open var promoId: String!
	open var issuer: PXIssuer!
	open var recommendedMessage: String!
	open var paymentMethods: [PXPaymentMethod]!
	open var legals: String!
	open var url: String?

	open class func getDateFromString(_ string: String!) -> Date! {
		if string == nil {
			return nil
		}
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		var dateArr = string.split {$0 == "T"}.map(String.init)
		return dateFormatter.date(from: dateArr[0])
	}
}
