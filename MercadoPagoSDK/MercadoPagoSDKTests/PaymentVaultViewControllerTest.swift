//
//  PaymentVaultViewControllerTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 22/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class PaymentVaultViewControllerTest: BaseTest {
    
    var paymentVaultViewController : MockPaymentVaultViewController?
    var mpNavigationController : MPNavigationController?
    var paymentMethodSelected : PaymentMethod?
    var tokenCreated : Token?
    var issuerSelected : Issuer?
    var payerCostSelected : PayerCost?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInit() {
        
        self.paymentVaultViewController = MockPaymentVaultViewController(amount: 2579, currencyId: MockBuilder.MLA_CURRENCY, paymentPreference: nil, callback: { (paymentMethod, tokenId, issuer, installments) -> Void in
            
        })
        
        XCTAssertEqual(paymentVaultViewController!.merchantBaseUrl, MercadoPagoContext.baseURL())
        XCTAssertEqual(paymentVaultViewController!.publicKey, MercadoPagoContext.publicKey())
        XCTAssertEqual(paymentVaultViewController!.merchantAccessToken,  MercadoPagoContext.merchantAccessToken())
        XCTAssertNil(paymentVaultViewController?.currentPaymentMethodSearch)
        XCTAssertNil(paymentVaultViewController?.paymentMethods)
        
        MercadoPagoTestContext.sharedInstance.expectation = expectationWithDescription("waitForGroups")
        self.simulateViewDidLoadFor(self.paymentVaultViewController!)
        waitForExpectationsWithTimeout(60, handler: nil)
        
        XCTAssertNotNil(self.paymentVaultViewController?.currentPaymentMethodSearch)
        XCTAssertTrue(self.paymentVaultViewController?.currentPaymentMethodSearch!.count > 1)
        XCTAssertNotNil(paymentVaultViewController?.paymentMethods)
        XCTAssertNotNil(paymentVaultViewController?.paymentMethods.count > 1)
        XCTAssertNotNil(self.paymentVaultViewController?.paymentsTable)
        // Verify preference description row
        XCTAssertTrue(self.paymentVaultViewController?.paymentsTable.numberOfRowsInSection(0) == 0)
        // Payments options
        XCTAssertTrue(self.paymentVaultViewController?.paymentsTable.numberOfRowsInSection(1) > 0)

    }

    /*
     * Selección de medio de pago: se excluyen medios off (solo tarjeta disponible). Se redirige al usuario al formulario de tarjeta.
     * Selección de tarjeta inicia formulario de tarjeta.
     *
     */
    func testPaymentVaultMLA_onlyCreditCard(){
        
        let excludedPaymentTypeIds = Set([PaymentTypeId.TICKET.rawValue, PaymentTypeId.BANK_TRANSFER.rawValue])
        let paymentPreference = PaymentPreference(defaultPaymentTypeId: nil, excludedPaymentMethodsIds: nil, excludedPaymentTypesIds: excludedPaymentTypeIds, defaultPaymentMethodId: nil, maxAcceptedInstallment: nil, defaultInstallments: nil)
        
        self.paymentVaultViewController = MockPaymentVaultViewController(amount: 2579, currencyId: MockBuilder.MLA_CURRENCY, paymentPreference: paymentPreference, callback: { (paymentMethod, token, issuer, payerCost) in
            XCTAssertNotNil(paymentMethod)
            // Verificar selección correcta
            XCTAssertEqual(paymentMethod, self.paymentMethodSelected)
            XCTAssertEqual(token, self.tokenCreated)
            XCTAssertEqual(issuer, self.issuerSelected)
            XCTAssertEqual(payerCost, self.payerCostSelected)
        })
        
        self.simulateViewDidLoadFor(self.paymentVaultViewController!)
        
        XCTAssertEqual(self.paymentVaultViewController!.paymentPreference, paymentPreference)
        XCTAssertNotNil(self.paymentVaultViewController?.currentPaymentMethodSearch)
        
        let availablePaymentTypes = MockBuilder.MLA_PAYMENT_TYPES.subtract(excludedPaymentTypeIds)
        XCTAssertTrue(self.paymentVaultViewController?.currentPaymentMethodSearch.count == availablePaymentTypes.count)
        
        // Se seleccionó opción de CC
        XCTAssertEqual(self.paymentVaultViewController!.currentPaymentMethodSearch[0].idPaymentMethodSearchItem, PaymentTypeId.CREDIT_CARD.rawValue)
        
        // Se selecciono una acción por default
        XCTAssertTrue(self.paymentVaultViewController!.optionSelected)
        
    }
    
    /*
     * Selección de medio de pago: sin exlusiones. Todos los medios de pago disponibles.
     * Selección de tarjeta inicia formulario de tarjeta.
     * Selección de medio off retorna el medio de pago correspondiente.
     *
     */
    func testPaymentVaultMLA_noPaymentPreference(){
        
        self.paymentVaultViewController = MockPaymentVaultViewController(amount: 2579, currencyId: MockBuilder.MLA_CURRENCY, paymentPreference: nil, callback: { (paymentMethod, token, issuer, payerCost) in
            XCTAssertNotNil(paymentMethod)
            // Verificar selección correcta
            XCTAssertEqual(paymentMethod, self.paymentMethodSelected)
            XCTAssertEqual(token, self.tokenCreated)
            XCTAssertEqual(issuer, self.issuerSelected)
            XCTAssertEqual(payerCost, self.payerCostSelected)
        })
        
        self.simulateViewDidLoadFor(self.paymentVaultViewController!)
        
        XCTAssertNil(paymentVaultViewController?.paymentPreference)
        XCTAssertNotNil(self.paymentVaultViewController?.currentPaymentMethodSearch)
        XCTAssertTrue(self.paymentVaultViewController?.currentPaymentMethodSearch.count == MockBuilder.MLA_PAYMENT_TYPES.count)
        
        
        let ccCell = self.paymentVaultViewController!.tableView(self.paymentVaultViewController!.paymentsTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)) as! PaymentSearchCell
        XCTAssertEqual(self.paymentVaultViewController?.currentPaymentMethodSearch[0].description, ccCell.paymentTitle.text)
        
        let cashOptions = self.paymentVaultViewController?.currentPaymentMethodSearch[1].children
        XCTAssertNotNil(cashOptions)
        XCTAssertTrue(cashOptions?.count == 4)
        
        let redLinkOptions = self.paymentVaultViewController?.currentPaymentMethodSearch[2].children
        XCTAssertNotNil(redLinkOptions)
        XCTAssertTrue(redLinkOptions?.count == 2)

        
    }
    
    /*
     * Selección de medio de pago: se excluyen tarjetas y Transferencia bancaria. Ticket únicamente disponible.
     * Solo selección de medio de ticket disponible. Se retorna el medio de pago correspondiente.
     *
     */
    func testPaymentVaultMLA_ticketAvailable(){
        
        let excludedPaymentTypeIds = Set([PaymentTypeId.CREDIT_CARD.rawValue, PaymentTypeId.BANK_TRANSFER.rawValue])
        let paymentPreference = PaymentPreference(defaultPaymentTypeId: nil, excludedPaymentMethodsIds: nil, excludedPaymentTypesIds: excludedPaymentTypeIds, defaultPaymentMethodId: nil, maxAcceptedInstallment: nil, defaultInstallments: nil)
        
        self.paymentVaultViewController = MockPaymentVaultViewController(amount: 2579, currencyId: MockBuilder.MLA_CURRENCY, paymentPreference: paymentPreference, callback: { (paymentMethod, token, issuer, payerCost) in
            XCTAssertNotNil(paymentMethod)
            // Verificar selección correcta
            XCTAssertEqual(paymentMethod, self.paymentMethodSelected)
            XCTAssertEqual(token, self.tokenCreated)
            XCTAssertEqual(issuer, self.issuerSelected)
            XCTAssertEqual(payerCost, self.payerCostSelected)
        })
        
        self.simulateViewDidLoadFor(self.paymentVaultViewController!)
        
        XCTAssertEqual(self.paymentVaultViewController?.paymentPreference, paymentPreference)
        XCTAssertNotNil(self.paymentVaultViewController?.currentPaymentMethodSearch)
        XCTAssertTrue(self.paymentVaultViewController?.currentPaymentMethodSearch.count == 4)
        
        
        let offlinePM = self.paymentVaultViewController!.tableView(self.paymentVaultViewController!.paymentsTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)) as! OfflinePaymentMethodCell
        for paymentMethodOff in (self.paymentVaultViewController?.currentPaymentMethodSearch)! {
            XCTAssertNotNil(offlinePM)
            XCTAssertEqual(offlinePM.comment.text, paymentMethodOff.comment)
        }
        
        
    }
    
    /*
     * Selección de medio de pago: Un solo medio de pago off disponible.
     * No se visualiza pantalla de medios de pago. Se reotrna el medio de pago correspondiente.
     *
     */
    func testPaymentVaultMLA_onePaymentMethodOff(){
        
        let excludedPaymentTypeIds = Set([PaymentTypeId.CREDIT_CARD.rawValue, PaymentTypeId.BANK_TRANSFER.rawValue])
        let excludedPaymentMethodIds = Set(arrayLiteral: "bapropagos", "rapipago", "cargavirtual")
        let paymentPreference = PaymentPreference(defaultPaymentTypeId: nil, excludedPaymentMethodsIds: excludedPaymentMethodIds, excludedPaymentTypesIds: excludedPaymentTypeIds, defaultPaymentMethodId: nil, maxAcceptedInstallment: nil, defaultInstallments: nil)
        
        self.paymentVaultViewController = MockPaymentVaultViewController(amount: 2579, currencyId: MockBuilder.MLA_CURRENCY, paymentPreference: paymentPreference, callback: { (paymentMethod, token, issuer, payerCost) in
            XCTAssertNotNil(paymentMethod)
            // Verificar selección correcta
            XCTAssertEqual(paymentMethod, self.paymentMethodSelected)
            XCTAssertEqual(token, self.tokenCreated)
            XCTAssertEqual(issuer, self.issuerSelected)
            XCTAssertEqual(payerCost, self.payerCostSelected)
        })
        
        self.simulateViewDidLoadFor(self.paymentVaultViewController!)
        
        XCTAssertEqual(self.paymentVaultViewController?.paymentPreference, paymentPreference)
        XCTAssertNotNil(self.paymentVaultViewController?.currentPaymentMethodSearch)
        XCTAssertTrue(self.paymentVaultViewController?.currentPaymentMethodSearch.count == 1)
        
        // Se seleccionó una acción por default
        XCTAssertTrue(self.paymentVaultViewController!.optionSelected)
        
    }
    
}


