//
//  CheckoutViewControllerTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 22/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest
@testable import MercadoPagoSDK

class CheckoutViewControllerTest: BaseTest {
    
    var checkoutViewController : MockCheckoutViewController?
    var preference : CheckoutPreference?
    var selectedPaymentMethod : PaymentMethod?
    var selectedPayerCost : PayerCost?
    var selectedIssuer : Issuer?
    var createdToken : Token?
    
    override func setUp() {
        super.setUp()
        self.checkoutViewController = MockCheckoutViewController(preferenceId: MockBuilder.PREF_ID_NO_EXCLUSIONS, callback: { (payment) in
            
        })

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitParameters() {
        
        XCTAssertEqual(checkoutViewController!.preferenceId, MockBuilder.PREF_ID_NO_EXCLUSIONS)
        XCTAssertEqual(checkoutViewController!.publicKey, MercadoPagoContext.publicKey())
        XCTAssertEqual(checkoutViewController!.accessToken, MercadoPagoContext.merchantAccessToken())
        XCTAssertNil(checkoutViewController!.paymentMethod)
    }
    
    func testSetupCheckoutWithPreference(){
        MPServicesBuilder.getPreference(MockBuilder.PREF_ID_NO_EXCLUSIONS, success: { (preference) in
            self.preference = preference
        }) { (error) in
            XCTFail()
        }
        
        // Cargar vista
        self.simulateViewDidLoadFor(self.checkoutViewController!)
        
        // Verificar preferencia
        XCTAssertEqual(self.preference?._id, self.checkoutViewController!.preference?._id)
        
        // Verificar atributos iniciales de pantalla
        checkInitialScreenAttributes()
        
    }
    
   
    /*
     *  Todos los medios de pago disponibles.
     *  Se selecciona medio off para pago.
     *  Última pantalla es instrucciones de pago
     */
    func testCheckoutMLA_preferenceWithNoExclusionsPaymentOff(){
        self.checkoutViewController = MockCheckoutViewController(preferenceId: MockBuilder.PREF_ID_NO_EXCLUSIONS, callback: { (payment : Payment) in
            
            
        })
        
        // Metodo de pago no seleccionado
        XCTAssertNil(checkoutViewController?.paymentMethod)
        
        self.simulateViewDidLoadFor(checkoutViewController!)
        
        XCTAssertNotNil(checkoutViewController?.paymentMethodSearch)
        XCTAssertTrue(checkoutViewController?.paymentMethodSearch?.groups.count == MockBuilder.MLA_PAYMENT_TYPES.count)
        
        // Verificar selección de medio off
        verifyPaymentVaultSelection_paymentMethodOff("rapipago")
        
        
        MercadoPagoTestContext.addExpectation(expectationWithDescription(BaseTest.WAIT_FOR_REQUEST_EXPECTATION_DESCRIPTION))
        
        // Pago con medio off
        verifyConfirmPaymentOff()
        
        // Verificar que ultima pantalla sea instrucciones de pago
        let lastViewController = self.checkoutViewController!.navigationController?.viewControllers.last
        XCTAssertNotNil(lastViewController)
        XCTAssertTrue(lastViewController!.isKindOfClass(InstructionsViewController))

        waitForExpectationsWithTimeout(BaseTest.WAIT_EXPECTATION_TIME_INTERVAL, handler: nil)
        //Verificar payment method id seleccionado en instrucciones
        let instructionsVC = (lastViewController as! InstructionsViewController)
        XCTAssertEqual(instructionsVC.payment.paymentMethodId, self.selectedPaymentMethod?._id)
        
    }
    
    /*
     *  Todos los medios de pago disponible. 
     *  Se selecciona cc para pago.
     *  Última pantalla es congrats
     */
    func testCheckoutMLA_preferenceWithNoExclusionsPaymentCreditCard(){
       
        self.checkoutViewController = MockCheckoutViewController(preferenceId: MockBuilder.PREF_ID_NO_EXCLUSIONS, callback: { (payment : Payment) in
            
        })
        
        // Metodo de pago no seleccionado
        XCTAssertNil(checkoutViewController?.paymentMethod)
        
       self.checkoutViewController = self.simulateViewDidLoadFor(checkoutViewController!) as! MockCheckoutViewController
        
        XCTAssertNotNil(checkoutViewController?.paymentMethodSearch)
        XCTAssertTrue(checkoutViewController?.paymentMethodSearch?.groups.count == MockBuilder.MLA_PAYMENT_TYPES.count)
        
        // Pago con tarjeta de crédito
        verifyPaymentVaultSelection_creditCard()
        
        verifyConfirmPaymentCC()
        
        // Verificar que ultima pantalla sea de pago aprobado
        let lastViewController = self.checkoutViewController!.navigationController?.viewControllers.last
        XCTAssertNotNil(lastViewController)
        XCTAssertTrue(lastViewController!.isKindOfClass(PaymentCongratsViewController))
        
        //Verificar payment method id seleccionado en instrucciones
        let congrats = (lastViewController as! PaymentCongratsViewController)
        //XCTAssertEqual(congrats.payment.paymentMethodId, self.selectedPaymentMethod?._id)

        
    }
    
    
    /*
     *  Solo pago con CC disponible.
     *  Se selecciona cc para pago.
     *  Última pantalla es congrats
     */
    func testCheckoutMLA_preferenceOnlyCCPaymentCreditCard(){
        
        self.checkoutViewController = MockCheckoutViewController(preferenceId: MockBuilder.PREF_ID_CC, callback: { (payment : Payment) in
            
        })
        
        // Metodo de pago no seleccionado
        XCTAssertNil(checkoutViewController?.paymentMethod)
        
        self.simulateViewDidLoadFor(checkoutViewController!)
        
        // Solo tarjeta de crédito disponible
        XCTAssertNotNil(checkoutViewController?.paymentMethodSearch)
        let excludedPaymentTypeIds = Set([PaymentTypeId.TICKET.rawValue, PaymentTypeId.BANK_TRANSFER.rawValue])
        let availablePaymentTypes = MockBuilder.MLA_PAYMENT_TYPES.subtract(excludedPaymentTypeIds)
        XCTAssertTrue(checkoutViewController?.paymentMethodSearch?.groups.count == availablePaymentTypes.count)
        
        // Pago con tarjeta de crédito
        verifyPaymentVaultSelection_creditCard()
        
        // Verificar cantidad de celdas en pantalla
        let numberOfRows = self.checkoutViewController?.tableView(self.checkoutViewController!.checkoutTable, numberOfRowsInSection: 1)
        XCTAssertEqual(numberOfRows, 4)
        
        // Crear pago con tarjeta
        verifyConfirmPaymentCC()
        
        // Verificar que ultima pantalla sea de pago aprobado
        let lastViewController = self.checkoutViewController!.navigationController?.viewControllers.last
        XCTAssertNotNil(lastViewController)
        XCTAssertTrue(lastViewController!.isKindOfClass(PaymentCongratsViewController))
        
        
        //Verificar payment method id seleccionado en instrucciones
        let congrats = (lastViewController as! PaymentCongratsViewController)
        //XCTAssertEqual(congrats.payment.paymentMethodId, self.selectedPaymentMethod?._id)
        
        
    }
    
    
    
    /*
     *  Solo pago con ticket disponible.
     *  Se selecciona pagofacil para pago.
     *  Última pantalla es instrucciones
     */
    func testCheckoutMLA_preferenceOnlyTicketPaymentOff(){
        
        self.checkoutViewController = MockCheckoutViewController(preferenceId: MockBuilder.PREF_ID_TICKET, callback: { (payment : Payment) in
            
        })
        
        // Metodo de pago no seleccionado
        XCTAssertNil(checkoutViewController?.paymentMethod)
        
        self.simulateViewDidLoadFor(checkoutViewController!)
        
        // Solo medios off disponibles
        XCTAssertNotNil(checkoutViewController?.paymentMethodSearch)
        // Solo ticket disponible
        XCTAssertTrue(checkoutViewController?.paymentMethodSearch?.groups.count == 1)
        XCTAssertNotNil(checkoutViewController!.paymentMethodSearch!.groups[0].children)
        XCTAssertTrue(checkoutViewController?.paymentMethodSearch?.groups[0].children.count == 3)
    
        // Seleccionar método de pago
        verifyPaymentVaultSelection_paymentMethodOff("pagofacil")
        
        // Verificar cantidad de celdas en pantalla
        let numberOfRows = self.checkoutViewController?.tableView(self.checkoutViewController!.checkoutTable, numberOfRowsInSection: 1)
        XCTAssertEqual(numberOfRows, 3)
        
        // Crear pago
        verifyConfirmPaymentOff()
        
        // Verificar que ultima pantalla sea de pago aprobado
        let lastViewController = self.checkoutViewController!.navigationController?.viewControllers.last
        XCTAssertNotNil(lastViewController)
        XCTAssertTrue(lastViewController!.isKindOfClass(InstructionsViewController))
        
        
        //Verificar payment method id seleccionado en instrucciones
        let instructions = (lastViewController as! InstructionsViewController)
        XCTAssertEqual(instructions.payment.paymentMethodId, self.selectedPaymentMethod?._id)
        
        
    }
    
    
    /*
     *  Solo pago disponible con rapipago.
     *  Última pantalla es instrucciones de rapipago.
     */
    func testCheckoutMLA_preferenceOnlyPagoFacilPaymentMethodOff(){
        
        self.checkoutViewController = MockCheckoutViewController(preferenceId: MockBuilder.PREF_ID_PAGOFACIL, callback: { (payment : Payment) in
            
        })
        
        // Metodo de pago no seleccionado
        XCTAssertNil(checkoutViewController?.paymentMethod)
        
        self.simulateViewDidLoadFor(checkoutViewController!)
        
        
        // Solo pagofacil disponible
        XCTAssertNotNil(checkoutViewController?.paymentMethodSearch)
        XCTAssertTrue(checkoutViewController?.paymentMethodSearch?.groups.count == 1)
        
        // Seleccionar método de pago
        verifyPaymentVaultSelection_paymentMethodOff("pagofacil")
        
        // Verificar cantidad de celdas en pantalla
        let numberOfRows = self.checkoutViewController?.tableView(self.checkoutViewController!.checkoutTable, numberOfRowsInSection: 1)
        XCTAssertEqual(numberOfRows, 3)
        
        // Crear pago con pagofacil
        verifyConfirmPaymentOff()
        
        // Verificar que ultima pantalla sea de pago aprobado
        let lastViewController = self.checkoutViewController!.navigationController?.viewControllers.last
        XCTAssertNotNil(lastViewController)
        XCTAssertTrue(lastViewController!.isKindOfClass(InstructionsViewController))
        
        
        //Verificar payment method id seleccionado en instrucciones
        let instructions = (lastViewController as! InstructionsViewController)
        XCTAssertEqual(instructions.payment.paymentMethodId, self.selectedPaymentMethod?._id)
        
        
    }

    
    func verifyPaymentVaultSelection_paymentMethodOff(paymentMethodId : String){
        
        self.selectedPaymentMethod = Utils.findPaymentMethod((self.checkoutViewController?.paymentMethodSearch!.paymentMethods)!, paymentMethodId: paymentMethodId)
        
        // Selección de medio off
        checkoutViewController?.navigationController?.popViewControllerAnimated(true)
        checkoutViewController?.paymentVaultCallback(selectedPaymentMethod!, token: nil, issuer: nil, payerCost: nil)
        
        XCTAssertEqual(checkoutViewController?.paymentMethod, selectedPaymentMethod)
    
    }
    
    
    
    func verifyPaymentVaultSelection_creditCard(){
        
        self.selectedPaymentMethod = Utils.findPaymentMethod((self.checkoutViewController?.paymentMethodSearch!.paymentMethods)!, paymentMethodId: "visa")
        self.selectedPayerCost = MockBuilder.buildPayerCost()
        self.selectedIssuer = MockBuilder.buildIssuer()
        self.createdToken = MockBuilder.buildToken()
        
        // Selección Tarjeta
        checkoutViewController?.paymentVaultCallback(selectedPaymentMethod!, token: self.createdToken, issuer: self.selectedIssuer, payerCost: self.selectedPayerCost)
        
        XCTAssertEqual(checkoutViewController?.paymentMethod, selectedPaymentMethod)
        XCTAssertEqual(checkoutViewController?.payerCost, self.selectedPayerCost)
        XCTAssertEqual(checkoutViewController?.issuer, self.selectedIssuer)
        XCTAssertEqual(checkoutViewController?.token, self.createdToken)
        
    }
    
    func checkInitialScreenAttributes(){
        // Verificar descripción de compra
        XCTAssertTrue(checkoutViewController!.displayPreferenceDescription)
        
        let sections = checkoutViewController?.numberOfSectionsInTableView((checkoutViewController?.checkoutTable)!)
        XCTAssertEqual(sections, 2)
        
        checkoutViewController?.checkoutTable.reloadData()
        XCTAssertNotNil(checkoutViewController?.checkoutTable)
        
        let preferenceDescriptionCell = checkoutViewController?.tableView(checkoutViewController!.checkoutTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! PreferenceDescriptionTableViewCell
        XCTAssertEqual(preferenceDescriptionCell.preferenceDescription.text, self.checkoutViewController?.preference?.items![0].title!)
        
        let preferenceAmount = preferenceDescriptionCell.preferenceAmount.attributedText
        
        let amountInCHOVC = self.checkoutViewController!.preference!.getAmount()
        let amountAttributedText = Utils.getAttributedAmount(amountInCHOVC, thousandSeparator: ".", decimalSeparator: ",", currencySymbol: "$")
        XCTAssertEqual(preferenceAmount!.string, amountAttributedText.string)
    
        let termsAndConditionsCell = checkoutViewController!.tableView(checkoutViewController!.checkoutTable, cellForRowAtIndexPath: NSIndexPath(forRow: 3, inSection: 1)) as!TermsAndConditionsViewCell
        XCTAssertNotNil(termsAndConditionsCell)
        
    }
    
    
    func verifyConfirmPaymentOff() {

        let termsAndConditionsCell = checkoutViewController!.tableView(checkoutViewController!.checkoutTable, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 1)) as!TermsAndConditionsViewCell
        XCTAssertNotNil(termsAndConditionsCell)
        let paymentButton = termsAndConditionsCell.paymentButton
        
        // Verificar que este disponible botón de pago y pagar
        XCTAssertTrue(paymentButton.enabled.boolValue)
        self.checkoutViewController!.confirmPayment()
        
        
    }
    
    func verifyConfirmPaymentCC(){
        let termsAndConditionsCell = checkoutViewController!.tableView(checkoutViewController!.checkoutTable, cellForRowAtIndexPath: NSIndexPath(forRow: 3, inSection: 1)) as! TermsAndConditionsViewCell
        XCTAssertNotNil(termsAndConditionsCell)
        let paymentButton = termsAndConditionsCell.paymentButton
        
        XCTAssertTrue(paymentButton.enabled.boolValue)
        self.checkoutViewController!.confirmPayment()

    }
//
//    func testConfirmPaymentOn() {
//        self.simulateViewDidLoadFor(self.checkoutViewController!)
//        self.checkoutViewController!.paymentMethod = MockBuilder.buildPaymentMethod("visa")
//      //  self.checkoutViewController!.paymentMethod?.paymentTypeId = PaymentTypeId.CREDIT_CARD
//        
//        let termsAndConditionsCell = checkoutViewController!.tableView(checkoutViewController!.checkoutTable, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 1)) as!TermsAndConditionsViewCell
//        XCTAssertNotNil(termsAndConditionsCell)
//        self.checkoutViewController!.paymentButton = termsAndConditionsCell.paymentButton
//        
//       // self.checkoutViewController!.confirmPayment()
//        //TODO
//    }
    
//    func testViewForFooterInSection() {
//        self.simulateViewDidLoadFor(self.checkoutViewController!)
//        let noCopyrightCell = self.checkoutViewController?.tableView(self.checkoutViewController!.checkoutTable, viewForFooterInSection: 0)
//        XCTAssertNil(noCopyrightCell)
//        
//        let copyrightCell = self.checkoutViewController?.tableView(self.checkoutViewController!.checkoutTable, viewForFooterInSection: 1)
//        XCTAssertNotNil(copyrightCell)
//        
//        var footerHeight = self.checkoutViewController!.tableView(self.checkoutViewController!.checkoutTable, heightForFooterInSection: 0)
//        XCTAssertEqual(footerHeight, 0)
//        footerHeight = self.checkoutViewController!.tableView(self.checkoutViewController!.checkoutTable, heightForFooterInSection: 1)
//       // XCTAssertEqual(footerHeight, 140)
//    }
//
//    


    func testOfflinePaymentMethodSelectedCell(){
//        self.simulateViewDidLoadFor(self.checkoutViewController!)
//        self.checkoutViewController!.paymentMethod = MockBuilder.buildPaymentMethod("bancomer_ticket")
//        self.checkoutViewController!.paymentMethod?.paymentTypeId = PaymentTypeId.TICKET
//        self.checkoutViewController!.paymentMethod!.comment = "comment"
//        
//        let paymentMethodCell = self.checkoutViewController!.tableView(self.checkoutViewController!.checkoutTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)) as! OfflinePaymentMethodCell
//        XCTAssertEqual(checkoutViewController?.title, "Revisa si está todo bien...".localized)
//        let termsAndConditions = self.checkoutViewController!.tableView(self.checkoutViewController!.checkoutTable, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 1)) as! TermsAndConditionsViewCell
//        XCTAssertEqual(termsAndConditions.termsAndConditionsText.text, "Al pagar afirme que es mayor de edad y acepto los términos y condiciones de Mercado Pago")
//        let cellComment = paymentMethodCell.comment.text!
//        XCTAssertEqual(cellComment, self.checkoutViewController!.paymentMethod!.comment!)
//        
        
    }
    
}
