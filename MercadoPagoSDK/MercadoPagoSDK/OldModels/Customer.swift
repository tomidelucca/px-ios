//
//  Customer.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

/** :nodoc: */
@objcMembers open class Customer: NSObject {
    open var address: PXAddress?
    open var cards: [PXCard]?
    open var defaultCard: String?
    open var customerDescription: String?
    open var dateCreated: Date?
    open var dateLastUpdated: Date?
    open var email: String?
    open var firstName: String?
    open var customerId: String?
    open var identification: PXIdentification?
    open var lastName: String?
    open var liveMode: Bool?
    open var metadata: NSDictionary?
    open var phone: Phone?
    open var registrationDate: Date?

}
