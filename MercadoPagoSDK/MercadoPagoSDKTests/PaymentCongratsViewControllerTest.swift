//
//  PaymentCongratsViewControllerTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 21/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class PaymentCongratsViewControllerTest: BaseTest {
    
    var paymentCongratsViewController : PaymentCongratsViewController?
    static let noRateTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 67, green: 176,blue: 0), NSFontAttributeName : UIFont(name:MercadoPago.DEFAULT_FONT_NAME, size: 14)!]
    

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /*
     *   Pago aprobado con datos correctos y con cuotas sin interés
     */
    func testPaymentApproved_installmentsNoRate() {
        let payment = MockBuilder.buildPayment("visa", installments: 3)
        let paymentMethod = MockBuilder.buildPaymentMethod("visa")
        self.paymentCongratsViewController = PaymentCongratsViewController(payment: payment, paymentMethod: paymentMethod, callback: { (payment, status) in
            
        })
        
        let attributedNoRateString = NSMutableAttributedString(string: " ")
        attributedNoRateString.appendAttributedString(NSAttributedString(string: "Sin interés".localized, attributes :PaymentCongratsViewControllerTest.noRateTextAttributes))
        
        self.simulateViewDidLoadFor(self.paymentCongratsViewController!)
        XCTAssertEqual("approved", self.paymentCongratsViewController?.getLayoutName(payment))
        XCTAssertEqual(3, self.paymentCongratsViewController!.numberOfSectionsInTableView(self.paymentCongratsViewController!.congratsContentTable))
        
        let approvedPaymentCongratsHeader = self.paymentCongratsViewController!.tableView(self.paymentCongratsViewController!.congratsContentTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        XCTAssertTrue(approvedPaymentCongratsHeader.isKindOfClass(ApprovedPaymentHeaderTableViewCell))
        
        let header = self.paymentCongratsViewController!.tableView(self.paymentCongratsViewController!.congratsContentTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! ApprovedPaymentHeaderTableViewCell
        XCTAssertEqual(header.subtitle.text, payment.payer.email)
        XCTAssertEqual(header.headerDescription.text, "Te enviaremos los datos a")
        
        let body = self.paymentCongratsViewController!.tableView(self.paymentCongratsViewController!.congratsContentTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)) as! ApprovedPaymentBodyTableViewCell
        let paymentMethodIcon = MercadoPago.getImage(payment.paymentMethodId)
        XCTAssertEqual(body.creditCardIcon.image, paymentMethodIcon)
        XCTAssertEqual(body.creditCardLabel.text!, "terminada en ".localized + payment.card.lastFourDigits!)
        XCTAssertEqual(body.voucherId.text!, "Comprobante ".localized + String(payment._id))
        let amountText = Utils.getTransactionInstallmentsDescription("3", installmentAmount: MockBuilder.INSTALLMENT_AMOUNT, additionalString: attributedNoRateString)
        XCTAssertEqual(body.amountDescription.attributedText!, amountText)
        
   
    }
    
    /*
     *   Pago aprobado con datos correctos y con cuotas con interés
     */
    func testPaymentApproved_installmentsWithFinancialFee() {
        let payment = MockBuilder.buildPayment("master", installments: 6, includeFinancingFee: true)
        
        let paymentMethod = MockBuilder.buildPaymentMethod("master")
        self.paymentCongratsViewController = PaymentCongratsViewController(payment: payment, paymentMethod: paymentMethod, callback: { (payment, status) in
            
        })
        
        self.simulateViewDidLoadFor(self.paymentCongratsViewController!)
        XCTAssertEqual("approved", self.paymentCongratsViewController?.getLayoutName(payment))
        XCTAssertEqual(3, self.paymentCongratsViewController!.numberOfSectionsInTableView(self.paymentCongratsViewController!.congratsContentTable))
        
        let approvedPaymentCongratsHeader = self.paymentCongratsViewController!.tableView(self.paymentCongratsViewController!.congratsContentTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        XCTAssertTrue(approvedPaymentCongratsHeader.isKindOfClass(ApprovedPaymentHeaderTableViewCell))
        
        let header = self.paymentCongratsViewController!.tableView(self.paymentCongratsViewController!.congratsContentTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! ApprovedPaymentHeaderTableViewCell
        XCTAssertEqual(header.subtitle.text, payment.payer.email)
        XCTAssertEqual(header.headerDescription.text, "Te enviaremos los datos a")
        
        let body = self.paymentCongratsViewController!.tableView(self.paymentCongratsViewController!.congratsContentTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)) as! ApprovedPaymentBodyTableViewCell
        let paymentMethodIcon = MercadoPago.getImage(payment.paymentMethodId)
        XCTAssertEqual(body.creditCardIcon.image, paymentMethodIcon)
        XCTAssertEqual(body.creditCardLabel.text!, "terminada en ".localized + payment.card.lastFourDigits!)
        XCTAssertEqual(body.voucherId.text!, "Comprobante ".localized + String(payment._id))
        
        // Monto total de compra debería aparecer en pantalla
        let additionalTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 67, green: 176,blue: 0), NSFontAttributeName : UIFont(name:MercadoPago.DEFAULT_FONT_NAME, size: 14)!]
        let additionalString = NSMutableAttributedString(string: " ")
        additionalString.appendAttributedString(NSAttributedString(string : "( ", attributes: additionalTextAttributes))
        additionalString.appendAttributedString(Utils.getAttributedAmount(payment.transactionDetails.totalPaidAmount, thousandSeparator: ".", decimalSeparator: ",", currencySymbol: "$", color: UIColor(red: 67, green: 176,blue: 0), fontSize : 14, baselineOffset: 3))
        additionalString.appendAttributedString(NSAttributedString(string : " )", attributes: additionalTextAttributes))
        
        
        let amountText = Utils.getTransactionInstallmentsDescription("6", installmentAmount: MockBuilder.INSTALLMENT_AMOUNT, additionalString: additionalString)
        XCTAssertEqual(body.amountDescription.attributedText!, amountText)
        
        
    }
    
    
    /*
     *   Pago aprobado con datos correctos y cuotas sin interes, y fee detail
     */
    func testPaymentApproved_installmentsWithFeeDetailsNoRate() {
        let payment = MockBuilder.buildPayment("master", installments: 6)
        let feesDetail = FeesDetail()
        feesDetail.type = "test"
        payment.feesDetails.append(feesDetail)
        
        let paymentMethod = MockBuilder.buildPaymentMethod("master")
        self.paymentCongratsViewController = PaymentCongratsViewController(payment: payment, paymentMethod: paymentMethod, callback: { (payment, status) in
            
        })
        
        self.simulateViewDidLoadFor(self.paymentCongratsViewController!)
        XCTAssertEqual("approved", self.paymentCongratsViewController?.getLayoutName(payment))
        XCTAssertEqual(3, self.paymentCongratsViewController!.numberOfSectionsInTableView(self.paymentCongratsViewController!.congratsContentTable))
        
        let approvedPaymentCongratsHeader = self.paymentCongratsViewController!.tableView(self.paymentCongratsViewController!.congratsContentTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        XCTAssertTrue(approvedPaymentCongratsHeader.isKindOfClass(ApprovedPaymentHeaderTableViewCell))
        
        let header = self.paymentCongratsViewController!.tableView(self.paymentCongratsViewController!.congratsContentTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! ApprovedPaymentHeaderTableViewCell
        XCTAssertEqual(header.subtitle.text, payment.payer.email)
        XCTAssertEqual(header.headerDescription.text, "Te enviaremos los datos a")
        
        let body = self.paymentCongratsViewController!.tableView(self.paymentCongratsViewController!.congratsContentTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)) as! ApprovedPaymentBodyTableViewCell
        let paymentMethodIcon = MercadoPago.getImage(payment.paymentMethodId)
        XCTAssertEqual(body.creditCardIcon.image, paymentMethodIcon)
        XCTAssertEqual(body.creditCardLabel.text!, "terminada en ".localized + payment.card.lastFourDigits!)
        XCTAssertEqual(body.voucherId.text!, "Comprobante ".localized + String(payment._id))
        let attributedNoRateString = NSMutableAttributedString(string: " ")
        attributedNoRateString.appendAttributedString(NSAttributedString(string: "Sin interés".localized, attributes :PaymentCongratsViewControllerTest.noRateTextAttributes))
        let amountText = Utils.getTransactionInstallmentsDescription("6", installmentAmount: MockBuilder.INSTALLMENT_AMOUNT, additionalString: attributedNoRateString)

        XCTAssertEqual(body.amountDescription.attributedText!, amountText)
        
        
    }
    
    
    /*
     *   Pago aprobado sin datos de comprador
     */
    func testPaymentApproved_noPayer() {
        let payment = MockBuilder.buildPayment("visa", installments: 3)
        let paymentMethod = MockBuilder.buildPaymentMethod("visa")
        payment.payer = nil
        self.paymentCongratsViewController = PaymentCongratsViewController(payment: payment, paymentMethod: paymentMethod, callback: { (payment, status) in
            
        })
        
        let attributedNoRateString = NSMutableAttributedString(string: " ")
        attributedNoRateString.appendAttributedString(NSAttributedString(string: "Sin interés".localized, attributes :PaymentCongratsViewControllerTest.noRateTextAttributes))
        
        
        self.simulateViewDidLoadFor(self.paymentCongratsViewController!)
        XCTAssertEqual("approved", self.paymentCongratsViewController?.getLayoutName(payment))
        XCTAssertEqual(3, self.paymentCongratsViewController!.numberOfSectionsInTableView(self.paymentCongratsViewController!.congratsContentTable))
        
        let approvedPaymentCongratsHeader = self.paymentCongratsViewController!.tableView(self.paymentCongratsViewController!.congratsContentTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        XCTAssertTrue(approvedPaymentCongratsHeader.isKindOfClass(ApprovedPaymentHeaderTableViewCell))
        
        let header = self.paymentCongratsViewController!.tableView(self.paymentCongratsViewController!.congratsContentTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! ApprovedPaymentHeaderTableViewCell
        XCTAssertEqual(header.subtitle.text, "")
        XCTAssertEqual(header.headerDescription.text!, "")
        
        let body = self.paymentCongratsViewController!.tableView(self.paymentCongratsViewController!.congratsContentTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)) as! ApprovedPaymentBodyTableViewCell
        let paymentMethodIcon = MercadoPago.getImage(payment.paymentMethodId)
        XCTAssertEqual(body.creditCardIcon.image, paymentMethodIcon)
        XCTAssertEqual(body.creditCardLabel.text!, "terminada en ".localized + payment.card.lastFourDigits!)
        XCTAssertEqual(body.voucherId.text!, "Comprobante ".localized + String(payment._id))
        let amountText = Utils.getTransactionInstallmentsDescription("3", installmentAmount: MockBuilder.INSTALLMENT_AMOUNT, additionalString: attributedNoRateString)
        XCTAssertEqual(body.amountDescription.attributedText!, amountText)
        
    }
    
    /*
     *   Pago aprobado sin email de comprador
     */
    func testPaymentApproved_noEmailPayer() {
        let payment = MockBuilder.buildPayment("visa", installments: 3)
        let paymentMethod = MockBuilder.buildPaymentMethod("visa")
        payment.payer.email = nil
        self.paymentCongratsViewController = PaymentCongratsViewController(payment: payment, paymentMethod: paymentMethod, callback: { (payment, status) in
            
        })
        
        let attributedNoRateString = NSMutableAttributedString(string: " ")
        attributedNoRateString.appendAttributedString(NSAttributedString(string: "Sin interés".localized, attributes :PaymentCongratsViewControllerTest.noRateTextAttributes))
        
        
        self.simulateViewDidLoadFor(self.paymentCongratsViewController!)
        XCTAssertEqual("approved", self.paymentCongratsViewController?.getLayoutName(payment))
        XCTAssertEqual(3, self.paymentCongratsViewController!.numberOfSectionsInTableView(self.paymentCongratsViewController!.congratsContentTable))
        
        let approvedPaymentCongratsHeader = self.paymentCongratsViewController!.tableView(self.paymentCongratsViewController!.congratsContentTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        XCTAssertTrue(approvedPaymentCongratsHeader.isKindOfClass(ApprovedPaymentHeaderTableViewCell))
        
        let header = self.paymentCongratsViewController!.tableView(self.paymentCongratsViewController!.congratsContentTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! ApprovedPaymentHeaderTableViewCell
        XCTAssertEqual(header.subtitle.text, "")
        XCTAssertEqual(header.headerDescription.text!, "")
        
        let body = self.paymentCongratsViewController!.tableView(self.paymentCongratsViewController!.congratsContentTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)) as! ApprovedPaymentBodyTableViewCell
        let paymentMethodIcon = MercadoPago.getImage(payment.paymentMethodId)
        XCTAssertEqual(body.creditCardIcon.image, paymentMethodIcon)
        XCTAssertEqual(body.creditCardLabel.text!, "terminada en ".localized + payment.card.lastFourDigits!)
        XCTAssertEqual(body.voucherId.text!, "Comprobante ".localized + String(payment._id))
        let amountText = Utils.getTransactionInstallmentsDescription("3", installmentAmount: MockBuilder.INSTALLMENT_AMOUNT, additionalString: attributedNoRateString)
        XCTAssertEqual(body.amountDescription.attributedText!, amountText)
        
    }

    /*
     *   Pago aprobado con email vacio de comprador
     */
    func testPaymentApproved_emptyEmailPayer() {
        let payment = MockBuilder.buildPayment("visa", installments: 3)
        let paymentMethod = MockBuilder.buildPaymentMethod("visa")
        payment.payer.email = ""
        self.paymentCongratsViewController = PaymentCongratsViewController(payment: payment, paymentMethod: paymentMethod, callback: { (payment, status) in
            
        })
        
        let attributedNoRateString = NSMutableAttributedString(string: " ")
        attributedNoRateString.appendAttributedString(NSAttributedString(string: "Sin interés".localized, attributes :PaymentCongratsViewControllerTest.noRateTextAttributes))
        
        
        self.simulateViewDidLoadFor(self.paymentCongratsViewController!)
        XCTAssertEqual("approved", self.paymentCongratsViewController?.getLayoutName(payment))
        XCTAssertEqual(3, self.paymentCongratsViewController!.numberOfSectionsInTableView(self.paymentCongratsViewController!.congratsContentTable))
        
        let approvedPaymentCongratsHeader = self.paymentCongratsViewController!.tableView(self.paymentCongratsViewController!.congratsContentTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        XCTAssertTrue(approvedPaymentCongratsHeader.isKindOfClass(ApprovedPaymentHeaderTableViewCell))
        
        let header = self.paymentCongratsViewController!.tableView(self.paymentCongratsViewController!.congratsContentTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! ApprovedPaymentHeaderTableViewCell
        XCTAssertEqual(header.subtitle.text, "")
        XCTAssertEqual(header.headerDescription.text!, "")
        
        let body = self.paymentCongratsViewController!.tableView(self.paymentCongratsViewController!.congratsContentTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)) as! ApprovedPaymentBodyTableViewCell
        let paymentMethodIcon = MercadoPago.getImage(payment.paymentMethodId)
        XCTAssertEqual(body.creditCardIcon.image, paymentMethodIcon)
        XCTAssertEqual(body.creditCardLabel.text!, "terminada en ".localized + payment.card.lastFourDigits!)
        XCTAssertEqual(body.voucherId.text!, "Comprobante ".localized + String(payment._id))
        let amountText = Utils.getTransactionInstallmentsDescription("3", installmentAmount: MockBuilder.INSTALLMENT_AMOUNT, additionalString: attributedNoRateString)
        XCTAssertEqual(body.amountDescription.attributedText!, amountText)
        
    }

    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
