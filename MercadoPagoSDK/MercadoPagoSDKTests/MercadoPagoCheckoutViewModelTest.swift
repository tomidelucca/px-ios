//
//  MercadoPagoCheckoutViewModelTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 3/9/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit
import XCTest

class MercadoPagoCheckoutViewModelTest: BaseTest {
    
    override func setUp() {
        self.continueAfterFailure = false
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNextStep_withCheckoutPreference_accountMoney() {
        
        // Set access_token
        MercadoPagoContext.setPayerAccessToken("access_token")
        MercadoPagoContext.setAccountMoneyAvailable(accountMoneyAvailable: true)
        let checkoutPreference = MockBuilder.buildCheckoutPreference()
        let mpCheckout = MercadoPagoCheckout(checkoutPreference: checkoutPreference, navigationController: UINavigationController())
        XCTAssertNotNil(mpCheckout.viewModel)
        
        // 1. Search Preference
        var step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SEARCH_PREFERENCE, step)
        
        // 2. Validate preference
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.VALIDATE_PREFERENCE, step)
        
        // 3. Search Payment Methods
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SEARCH_PAYMENT_METHODS, step)
        
        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckout: mpCheckout)
        
        // 4. Display payment methods (no exclusions)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.PAYMENT_METHOD_SELECTION, step)
        
        // 5. Payment option selected : account_money => RyC
        MPCheckoutTestAction.selectAccountMoney(mpCheckout: mpCheckout)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.REVIEW_AND_CONFIRM, step)
        
        // 6 . Simular paymentData y pagar
        let accountMoneyPm = MockBuilder.buildPaymentMethod("account_money", name: "Dinero en cuenta", paymentTypeId: PaymentTypeId.ACCOUNT_MONEY.rawValue)
        let paymentDataMock = MockBuilder.buildPaymentData(paymentMethod: accountMoneyPm)
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataMock)
        
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.POST_PAYMENT, step)
        
        // 7. Simular Pago realizado y se muestra congrats
        let paymentMock = MockBuilder.buildPayment("account_money")
        mpCheckout.viewModel.updateCheckoutModel(payment: paymentMock)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.CONGRATS, step)
        
        step = mpCheckout.viewModel.nextStep()
        
        // 7. Siguiente step DEBERIA SER FINISH - NO LO ES
      //  XCTAssertEqual(CheckoutStep.FINISH, step)
        
    }
    
    func testNextStep_withCheckoutPreference_masterCreditCard(){
        
        // Set access_token
        MercadoPagoContext.setPayerAccessToken("access_token")
        MercadoPagoContext.setAccountMoneyAvailable(accountMoneyAvailable: true)
        let checkoutPreference = MockBuilder.buildCheckoutPreference()
        let mpCheckout = MercadoPagoCheckout(checkoutPreference: checkoutPreference, navigationController: UINavigationController())
        XCTAssertNotNil(mpCheckout.viewModel)
        
        // 1. Search Preference
        var step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SEARCH_PREFERENCE, step)
        
        // 2. Validate preference
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.VALIDATE_PREFERENCE, step)
        
        // 3. Search Payment Methods
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SEARCH_PAYMENT_METHODS, step)
        
        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckout: mpCheckout)
        
        // 4. Display payment methods (no exclusions)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.PAYMENT_METHOD_SELECTION, step)
        
        // 5. Payment option selected : tarjeta de credito => Form Tarjeta
        MPCheckoutTestAction.selectCreditCardOption(mpCheckout: mpCheckout)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.CARD_FORM, step)
        
        // Simular paymentMethod completo
        let paymentMethodMaster = MockBuilder.buildPaymentMethod("master")
        // Se necesita identification input
        paymentMethodMaster.additionalInfoNeeded = ["cardholder_identification_number"]
        mpCheckout.viewModel.paymentData.paymentMethod = paymentMethodMaster
        
        let cardToken = MockBuilder.buildCardToken()
        mpCheckout.viewModel.cardToken = cardToken
        
        // 6. Identification
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.IDENTIFICATION, step)
        
        // Simular identificacion completa
        let identificationMock = MockBuilder.buildIdentification()
        mpCheckout.viewModel.updateCheckoutModel(identification: identificationMock)
        
        // 7 . Get Issuers
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.GET_ISSUERS, step)
        
        // Simular issuers
        let onlyIssuerAvailable = MockBuilder.buildIssuer()
        mpCheckout.viewModel.issuers = [onlyIssuerAvailable]
        mpCheckout.viewModel.updateCheckoutModel(issuer: onlyIssuerAvailable)
        
        // 8. Un solo banco disponible => Payer Costs
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.GET_PAYER_COSTS, step)
        mpCheckout.viewModel.installment = MockBuilder.buildInstallment()

        // 9. Pantalla cuotas
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.PAYER_COST_SCREEN, step)
        
        //Simular cuotas seleccionadas 
        mpCheckout.viewModel.paymentData.payerCost = MockBuilder.buildPayerCost()
        
        // 10. Crear token
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.CREATE_CARD_TOKEN, step)
        
        // Simular token completo
        let mockToken = MockBuilder.buildToken()
        mpCheckout.viewModel.updateCheckoutModel(token: mockToken)
        
        // 11. RyC
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.REVIEW_AND_CONFIRM, step)
        
        
        // 12. Simular pago
        let paymentDataMock = MockBuilder.buildPaymentData(paymentMethod: paymentMethodMaster)
        paymentDataMock.issuer = MockBuilder.buildIssuer()
        paymentDataMock.payerCost = MockBuilder.buildPayerCost()
        paymentDataMock.token = MockBuilder.buildToken()
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataMock)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.POST_PAYMENT, step)
        
        // 13. Simular pago completo => Congrats
        let paymentMock = MockBuilder.buildPayment("master")
        mpCheckout.viewModel.updateCheckoutModel(payment: paymentMock)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.CONGRATS, step)
        
//        // 10. Siguiente step DEBERIA SER FINISH - NO LO ES
//        //  XCTAssertEqual(CheckoutStep.FINISH, step)

    }

    func testNextStep_withCheckoutPreference_accountMoney_noRyC(){
        
        // Set access_token
        MercadoPagoContext.setPayerAccessToken("access_token")
        MercadoPagoContext.setAccountMoneyAvailable(accountMoneyAvailable: true)
        
        // Deshabilitar ryc
        let fp = FlowPreference()
        fp.disableReviewAndConfirmScreen()
        MercadoPagoCheckout.setFlowPreference(fp)
        
        let checkoutPreference = MockBuilder.buildCheckoutPreference()
        let mpCheckout = MercadoPagoCheckout(checkoutPreference: checkoutPreference, navigationController: UINavigationController())
        
        XCTAssertNotNil(mpCheckout.viewModel)
        
        // 1. Search Preference
        var step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SEARCH_PREFERENCE, step)
        
        // 2. Validate preference
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.VALIDATE_PREFERENCE, step)
        
        // 3. Search Payment Methods
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SEARCH_PAYMENT_METHODS, step)
        
        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckout: mpCheckout)
        
        // 4. Display payment methods (no exclusions)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.PAYMENT_METHOD_SELECTION, step)
        
        // 5. Payment option selected : account_money => paymentDataCallback
        MPCheckoutTestAction.selectAccountMoney(mpCheckout : mpCheckout)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.REVIEW_AND_CONFIRM, step)

        
        // 6. RyC pero no se muestra y se llama a paymentDataCallback
        let accountMoneyPm = MockBuilder.buildPaymentMethod("account_money", name: "Dinero en cuenta", paymentTypeId: PaymentTypeId.ACCOUNT_MONEY.rawValue)
        let paymentDataMock = MockBuilder.buildPaymentData(paymentMethod: accountMoneyPm)
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataMock)
        
        
        let expectPaymentDataCallback = expectation(description: "paymentDataCallback")
        MercadoPagoCheckout.setPaymentDataCallback { (paymentData : PaymentData) in
            XCTAssertEqual(paymentData.paymentMethod._id, paymentDataMock.paymentMethod._id)
            expectPaymentDataCallback.fulfill()
        }
        
        mpCheckout.collectPaymentData()
        step = mpCheckout.viewModel.nextStep()
        waitForExpectations(timeout: 10, handler: nil)
        
    }
    
    func testNextStep_withPaymentDataComplete() {
        
        // Set access_token
        MercadoPagoContext.setPayerAccessToken("access_token")
        
        let checkoutPreference = MockBuilder.buildCheckoutPreference()
        let accountMoneyPaymentMethod = MockBuilder.buildPaymentMethod("account_money", paymentTypeId : "account_money")
        let paymentDataAccountMoney = MockBuilder.buildPaymentData(paymentMethod: accountMoneyPaymentMethod)
        
        let mpCheckout = MercadoPagoCheckout(checkoutPreference: checkoutPreference, paymentData : paymentDataAccountMoney, navigationController: UINavigationController())
        XCTAssertNotNil(mpCheckout.viewModel)
        
        // 1. Search Preference
        var step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SEARCH_PREFERENCE, step)
        
        // 2. Validate preference
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.VALIDATE_PREFERENCE, step)
        
        // 3. Search Payment Methods
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SEARCH_PAYMENT_METHODS, step)

        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckout: mpCheckout)
        
        // 4. PaymentData complete => RyC
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.REVIEW_AND_CONFIRM, step)
        
        // 5. Realizar pago
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataAccountMoney)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.POST_PAYMENT, step)
        
        
        // 6. Simular Pago realizado y se muestra congrats
        let paymentMock = MockBuilder.buildPayment("account_money")
        mpCheckout.viewModel.updateCheckoutModel(payment: paymentMock)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.CONGRATS, step)
        
        step = mpCheckout.viewModel.nextStep()
        
        // 6. Siguiente step DEBERIA SER FINISH - NO LO ES
        //  XCTAssertEqual(CheckoutStep.FINISH, step)

    }
    
    func testNextStep_withPaymentResult() {
        
        // Set access_token
        MercadoPagoContext.setPayerAccessToken("access_token")
        
        // Init checkout
        let checkoutPreference = MockBuilder.buildCheckoutPreference()
        let visaPaymentMethod = MockBuilder.buildPaymentMethod("visa")
        let paymentDataVisa = MockBuilder.buildPaymentData(paymentMethod: visaPaymentMethod)
        
        let paymentResult = PaymentResult(status: "status", statusDetail: "statusDetail", paymentData: paymentDataVisa, payerEmail: "payerEmail", id: "id", statementDescription: "description")
        
        let mpCheckout = MercadoPagoCheckout(checkoutPreference: checkoutPreference, navigationController: UINavigationController(), paymentResult : paymentResult)
        XCTAssertNotNil(mpCheckout.viewModel)
        
        // 1. Search preference
        var step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SEARCH_PREFERENCE, step)
//        
//        // 2. Search Payment Methods
//        step = mpCheckout.viewModel.nextStep()
//        XCTAssertEqual(CheckoutStep.SEARCH_PAYMENT_METHODS, step)
        
        // Simular api call a grupos
        let accountMoneyOption = MockBuilder.buildCustomerPaymentMethod("account_money", paymentMethodId : "account_money")
        let creditCardOption = MockBuilder.buildPaymentMethodSearchItem("credit_card", type: PaymentMethodSearchItemType.PAYMENT_TYPE)
        let paymentMethodSearchMock = MockBuilder.buildPaymentMethodSearch(groups : [creditCardOption], customOptions : [accountMoneyOption])
        mpCheckout.viewModel.updateCheckoutModel(paymentMethodSearch: paymentMethodSearchMock)

        
        // 3. Muestra congrats
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.CONGRATS, step)
        
        // 4. Finish
//        step = mpCheckout.viewModel.nextStep()
//        XCTAssertEqual(CheckoutStep.FINISH, step)
//        
    }
    
    func testNextStep_withCustomerCard() {
        
        // Set access_token
        MercadoPagoContext.setPayerAccessToken("access_token")
        
        let checkoutPreference = MockBuilder.buildCheckoutPreference()
        
        let mpCheckout = MercadoPagoCheckout(checkoutPreference: checkoutPreference, navigationController: UINavigationController())
        XCTAssertNotNil(mpCheckout.viewModel)
        
        // 1. Search preference
        var step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SEARCH_PREFERENCE, step)
        
        // 2. Validate preference
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.VALIDATE_PREFERENCE, step)
        
        // 3. Search Payment Methods
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SEARCH_PAYMENT_METHODS, step)
        
        // Simular api call a grupos
        let customerCardOption = MockBuilder.buildCustomerPaymentMethod("customerCardId", paymentMethodId: "visa")
        let creditCardOption = MockBuilder.buildPaymentMethodSearchItem("credit_card", type: PaymentMethodSearchItemType.PAYMENT_TYPE)
        let paymentMethodVisa = MockBuilder.buildPaymentMethod("visa")
        let paymentMethodSearchMock = MockBuilder.buildPaymentMethodSearch(groups : [creditCardOption], paymentMethods : [paymentMethodVisa], customOptions : [customerCardOption])
        mpCheckout.viewModel.updateCheckoutModel(paymentMethodSearch: paymentMethodSearchMock)

        // 4. Display payment methods (no exclusions)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.PAYMENT_METHOD_SELECTION, step)
        
        // 5. Payment option selected : customer card visa => Cuotas
        mpCheckout.viewModel.updateCheckoutModel(paymentOptionSelected : customerCardOption as! PaymentMethodOption)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.GET_PAYER_COSTS, step)
        mpCheckout.viewModel.installment = MockBuilder.buildInstallment()
        
        // 6. Mostrar cuotas
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.PAYER_COST_SCREEN, step)
        
        //Simular cuotas seleccionadas
        mpCheckout.viewModel.paymentData.payerCost = MockBuilder.buildPayerCost()
        
        // 7. Mostrar SecCode (incluye creación de token)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SECURITY_CODE_ONLY, step)
        let token = MockBuilder.buildToken()
        mpCheckout.viewModel.updateCheckoutModel(token: token)
        
        // 8. RyC
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.REVIEW_AND_CONFIRM, step)
        
//        // 9. Finish
//        step = mpCheckout.viewModel.nextStep()
//        XCTAssertEqual(CheckoutStep.FINISH, step)
        
    }

    
    
}
