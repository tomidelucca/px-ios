//
//  InstructionsViewControllerTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 15/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class InstructionsViewControllerTest: BaseTest {
    
    var instructionsViewController : InstructionsViewController?

    override func setUp() {
        super.setUp()
        MercadoPagoContext.setPublicKey(MockBuilder.MOCK_PUBLIC_KEY)
        let offlinePayment = MockBuilder.buildPayment("oxxo")
        self.instructionsViewController = InstructionsViewController(payment: offlinePayment, callback: { (Payment) -> Void in
            
        })
        self.simulateViewDidLoadFor(self.instructionsViewController!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInstructionsScreens(){
        XCTAssertEqual((instructionsViewController?.instructionsByPaymentMethod["oxxo"])!, ["body" : "simpleInstructionsCell", "body_heigth" : 137, "footer" : "defaultInstructionsFooterCell", "footer_height" : 116])
        
        XCTAssertEqual(instructionsViewController!.instructionsByPaymentMethod["serfin_ticket"]!, ["body" : "instructionsTwoLabelsCell" , "body_heigth" : 189, "footer" : "defaultInstructionsFooterCell", "footer_height" : 116])
        
        XCTAssertEqual(instructionsViewController!.instructionsByPaymentMethod["bancomer_ticket"]!, ["body" : "instructionsTwoLabelsCell" , "body_heigth" : 189, "footer" : "intructionsWithTertiaryInfoFooterCell", "footer_height" : 200])
        
        XCTAssertEqual(instructionsViewController!.instructionsByPaymentMethod["7eleven"]!,["body" : "instructionsTwoLabelsCell" , "body_heigth" : 189, "footer" : "defaultInstructionsFooterCell", "footer_height" : 116])
        
        XCTAssertEqual(instructionsViewController!.instructionsByPaymentMethod["banamex_ticket"]!,["body" : "instructionsCell" , "body_heigth" : 264, "footer" : "defaultInstructionsFooterCell", "footer_height" : 116])
        
        XCTAssertEqual(instructionsViewController!.instructionsByPaymentMethod["telecomm"]!,["body" : "instructionsCell" , "body_heigth" : 264, "footer" : "intructionsWithTertiaryInfoFooterCell", "footer_height" : 200])
        
        
        XCTAssertEqual(instructionsViewController!.instructionsByPaymentMethod["serfin_bank_transfer"]!,["body" : "simpleInstructionWithButtonViewCell" , "body_heigth" : 208, "footer" : "intructionsWithSecondaryInfoFooterCell", "footer_height" : 168])
        
        XCTAssertEqual(instructionsViewController!.instructionsByPaymentMethod["banamex_bank_transfer"]!,["body" : "instructionsWithButtonCell" , "body_heigth" : 276, "footer" : "intructionsWithSecondaryInfoFooterCell", "footer_height" : 168])
        
        XCTAssertEqual(instructionsViewController!.instructionsByPaymentMethod["bancomer_bank_transfer"]!,["body" : "instructionsTwoLabelsAndButtonViewCell" , "body_heigth" : 258, "footer" : "intructionsWithSecondaryInfoFooterCell", "footer_height" : 168])
    
    }
    
    func testViewDidLoad() {

        XCTAssertNotNil(self.instructionsViewController?.currentInstruction)
        XCTAssertNotNil(self.instructionsViewController?.congratsTable)
        
    }
    
    func testVerifyInstructionsTableConstraints(){
        XCTAssertEqual(self.instructionsViewController?.numberOfSectionsInTableView(self.instructionsViewController!.congratsTable), 4)

        XCTAssertEqual(self.instructionsViewController!.tableView(self.instructionsViewController!.congratsTable, numberOfRowsInSection: 1), 1)
        
    }
    
    func testCellRowAtIndexes(){
 
        let instructionsHeader = self.instructionsViewController!.tableView(self.instructionsViewController!.congratsTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! InstructionsHeaderViewCell
        
        XCTAssertEqual(instructionsHeader.headerTitle.text, self.instructionsViewController!.currentInstruction?.title)

        let instructionsBodyForOxxo = self.instructionsViewController!.tableView(self.instructionsViewController!.congratsTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1))
        
        XCTAssertNotNil(instructionsBodyForOxxo)
        
        let instructionsFooterForOxxo = self.instructionsViewController!.tableView(self.instructionsViewController!.congratsTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 2))
       
        XCTAssertNotNil(instructionsFooterForOxxo)
    }
    
    func testResolveBodyHeightForRow (){
        XCTAssertEqual(self.instructionsViewController?.resolveInstructionsBodyHeightForRow("oxxo"), 137)
        XCTAssertEqual(self.instructionsViewController?.resolveInstructionsBodyHeightForRow("serfin_ticket"), 189)
        XCTAssertEqual(self.instructionsViewController?.resolveInstructionsBodyHeightForRow("bancomer_ticket"), 189)
        XCTAssertEqual(self.instructionsViewController?.resolveInstructionsBodyHeightForRow("7eleven"), 189)
        XCTAssertEqual(self.instructionsViewController?.resolveInstructionsBodyHeightForRow("banamex_ticket"),
                            264)
        XCTAssertEqual(self.instructionsViewController?.resolveInstructionsBodyHeightForRow("telecomm"), 264)
        XCTAssertEqual(self.instructionsViewController?.resolveInstructionsBodyHeightForRow("serfin_bank_transfer"), 208)
        XCTAssertEqual(self.instructionsViewController?.resolveInstructionsBodyHeightForRow("banamex_bank_transfer"), 276)
        XCTAssertEqual(self.instructionsViewController?.resolveInstructionsBodyHeightForRow("bancomer_bank_transfer"), 258)
    }
    
    func testResolveInstructionsFooterHeight (){
        XCTAssertEqual(self.instructionsViewController?.resolveInstructionsFooterHeight("oxxo"), 116)
        XCTAssertEqual(self.instructionsViewController?.resolveInstructionsFooterHeight("serfin_ticket"), 116)
        XCTAssertEqual(self.instructionsViewController?.resolveInstructionsFooterHeight("bancomer_ticket"), 200)
        XCTAssertEqual(self.instructionsViewController?.resolveInstructionsFooterHeight("7eleven"), 116)
        XCTAssertEqual(self.instructionsViewController?.resolveInstructionsFooterHeight("banamex_ticket"),
            116)
        XCTAssertEqual(self.instructionsViewController?.resolveInstructionsFooterHeight("telecomm"), 200)
        XCTAssertEqual(self.instructionsViewController?.resolveInstructionsFooterHeight("serfin_bank_transfer"), 168)
        XCTAssertEqual(self.instructionsViewController?.resolveInstructionsFooterHeight("banamex_bank_transfer"), 168)
        XCTAssertEqual(self.instructionsViewController?.resolveInstructionsFooterHeight("bancomer_bank_transfer"), 168)
    }
    
    func testFinishInstruction(){
        let expectMercadoPagoStylesAreCleared = expectationWithDescription("finishInstruction")
        self.instructionsViewController?.callback = { (Payment) -> Void in
            expectMercadoPagoStylesAreCleared.fulfill()
        }
        self.instructionsViewController?.finishInstructions()
        self.waitForExpectationsWithTimeout(10.0, handler: nil)
        XCTAssertNil(self.instructionsViewController?.navigationController?.navigationBar.titleTextAttributes)
        XCTAssertNil(self.instructionsViewController?.navigationController?.navigationBar.barTintColor)
        
    }
    
    func testDefaultInstructionsFooterCell(){
        var oxxoInstructions = Instruction()
        let expectInstructionIsLoaded = expectationWithDescription("loadOxxoInstructions")
        let mockedInstructionService = InstructionsService()
        mockedInstructionService.getInstructionsForPaymentId(MockBuilder.MOCK_PAYMENT_ID, paymentMethodId: "oxxo", success: { (instruction) -> Void in
                oxxoInstructions = instruction
                expectInstructionIsLoaded.fulfill()
            }) { (error) -> Void in
                
        }
        
        let defaultInstructionsFooterCell = self.instructionsViewController!.resolveInstructionsFooter("oxxo") as! DefaultInstructionsFooterViewCell
        XCTAssertNotNil(defaultInstructionsFooterCell.secondaryInfoTitle.text)

        
        waitForExpectationsWithTimeout(10.0, handler: nil)
        
        XCTAssertEqual(defaultInstructionsFooterCell.secondaryInfoTitle.text, oxxoInstructions.secondaryInfo![0])
        XCTAssertEqual(defaultInstructionsFooterCell.acreditationMessage.text, oxxoInstructions.accreditationMessage)
        
    }
    
    func testDefaultInstructionsWithSecondaryInfoFooterCell(){
        var serfinBTInstructions = Instruction()
        let expectInstructionIsLoaded = expectationWithDescription("loadSerfinBTInstructions")
        let mockedInstructionService = InstructionsService()
        mockedInstructionService.getInstructionsForPaymentId(MockBuilder.MOCK_PAYMENT_ID, paymentMethodId: "serfin_bank_transfer", success: { (instruction) -> Void in
            serfinBTInstructions = instruction
            self.instructionsViewController?.currentInstruction = instruction
            expectInstructionIsLoaded.fulfill()
            }) { (error) -> Void in
                
        }
        
        let instructionsFooterCell = self.instructionsViewController!.resolveInstructionsFooter("serfin_bank_transfer") as! InstructionsFooterWithSecondaryInfoViewCell
       
        
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
        
         XCTAssertNotNil(instructionsFooterCell.secondaryInfoTitle.text)
        XCTAssertEqual(instructionsFooterCell.secondaryInfoTitle.text, serfinBTInstructions.secondaryInfo![0])
        XCTAssertNotNil(instructionsFooterCell.secondaryInfoSubtitle.text)
        XCTAssertEqual(instructionsFooterCell.secondaryInfoSubtitle.text, serfinBTInstructions.secondaryInfo![1])
        XCTAssertEqual(instructionsFooterCell.acreditationMessage.text, serfinBTInstructions.accreditationMessage)
        
    }
    
    func testDefaultInstructionsWithTertiaryInfoFooterCell(){
        var bancomerInstructions = Instruction()
        let expectInstructionIsLoaded = expectationWithDescription("loadBancomerTicketInstructions")
        let mockedInstructionService = InstructionsService()
        mockedInstructionService.getInstructionsForPaymentId(MockBuilder.MOCK_PAYMENT_ID, paymentMethodId: "bancomer_ticket", success: { (instruction) -> Void in
            bancomerInstructions = instruction
            self.instructionsViewController?.currentInstruction = instruction
            expectInstructionIsLoaded.fulfill()
            }) { (error) -> Void in
                
        }
        
        let instructionsFooterCell = self.instructionsViewController!.resolveInstructionsFooter("bancomer_ticket") as! InstructionsFooterWithTertiaryInfoViewCell
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
        
    
        XCTAssertNotNil(instructionsFooterCell.secondaryInfoTitle.text)
        XCTAssertEqual(instructionsFooterCell.secondaryInfoTitle.text, bancomerInstructions.secondaryInfo![0])
        XCTAssertNotNil(instructionsFooterCell.secondaryInfoSubtitle.text)
        XCTAssertEqual(instructionsFooterCell.secondaryInfoSubtitle.text, bancomerInstructions.tertiaryInfo![0])
        XCTAssertNotNil(instructionsFooterCell.secondayInfoComment.text)
        XCTAssertEqual(instructionsFooterCell.secondayInfoComment.text, bancomerInstructions.tertiaryInfo![1])
        XCTAssertEqual(instructionsFooterCell.acreditationMessage.text, bancomerInstructions.accreditationMessage)
        
    }
    
    
    func testCashInstructionsBody(){
        
        var banamexInstructions = Instruction()
        let expectInstructionIsLoaded = expectationWithDescription("loadBanamexTicketInstructions")
        let mockedInstructionService = InstructionsService()
        mockedInstructionService.getInstructionsForPaymentId(MockBuilder.MOCK_PAYMENT_ID, paymentMethodId: "banamex_ticket", success: { (instruction) -> Void in
            banamexInstructions = instruction
            self.instructionsViewController?.currentInstruction = banamexInstructions
            expectInstructionIsLoaded.fulfill()
            }) { (error) -> Void in
                
        }
        
        let instructionsCell = self.instructionsViewController!.resolveInstructionsBodyViewCell("banamex_ticket") as! InstructionsViewCell
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
        
        
        XCTAssertNotNil(instructionsCell.infoTitle.text)
        XCTAssertEqual(instructionsCell.infoTitle.text, banamexInstructions.info[0])
        XCTAssertNotNil(instructionsCell.firstReferenceLabel.text)
        XCTAssertEqual(instructionsCell.firstReferenceLabel.text, banamexInstructions.references[0].label.uppercaseString)
        XCTAssertEqual(instructionsCell.firstReferenceValue.text, banamexInstructions.references[0].getFullReferenceValue())
        XCTAssertEqual(instructionsCell.secondReferenceLabel.text, banamexInstructions.references[1].label.uppercaseString)
        XCTAssertEqual(instructionsCell.secondReferenceValue.text, banamexInstructions.references[1].getFullReferenceValue())
        
        XCTAssertEqual(instructionsCell.thirdReferenceLabel.text, banamexInstructions.references[2].label.uppercaseString)
        XCTAssertEqual(instructionsCell.thirdReferenceValue.text, banamexInstructions.references[2].getFullReferenceValue())

    }
    
    func testCashSimpleInstructionsBody(){
        var oxxoInstructions = Instruction()
        let expectInstructionIsLoaded = expectationWithDescription("loadOxxoTicketInstructions")
        let mockedInstructionService = InstructionsService()
        mockedInstructionService.getInstructionsForPaymentId(MockBuilder.MOCK_PAYMENT_ID, paymentMethodId: "banamex_ticket", success: { (instruction) -> Void in
            oxxoInstructions = instruction
            self.instructionsViewController?.currentInstruction = instruction
            expectInstructionIsLoaded.fulfill()
            }) { (error) -> Void in
                
        }
        
        let instructionsCell = self.instructionsViewController!.resolveInstructionsBodyViewCell("oxxo") as! SimpleInstructionsViewCell
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
        
        
        XCTAssertNotNil(instructionsCell.infoTitle.text)
        XCTAssertEqual(instructionsCell.infoTitle.text, oxxoInstructions.info[0])
        XCTAssertNotNil(instructionsCell.referenceValue.text)
        XCTAssertEqual(instructionsCell.referenceValue.text, oxxoInstructions.references[0].getFullReferenceValue())

    }
    
    func testCashTwoLabelsInstructionsBody(){
        var bancomerTicketInstructions = Instruction()
        let expectInstructionIsLoaded = expectationWithDescription("loadBancomerTicketInstructions")
        let mockedInstructionService = InstructionsService()
        mockedInstructionService.getInstructionsForPaymentId(MockBuilder.MOCK_PAYMENT_ID, paymentMethodId: "bancomer_ticket", success: { (instruction) -> Void in
            self.instructionsViewController?.currentInstruction = instruction
            bancomerTicketInstructions = instruction
            expectInstructionIsLoaded.fulfill()
            }) { (error) -> Void in
                
        }
        
        let instructionsCell = self.instructionsViewController!.resolveInstructionsBodyViewCell("bancomer_ticket") as! InstructionsTwoLabelsViewCell
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
        
        
        XCTAssertNotNil(instructionsCell.infoTitle.text)
        XCTAssertEqual(instructionsCell.infoTitle.text, bancomerTicketInstructions.info[0])
        XCTAssertNotNil(instructionsCell.firstReferenceTitle.text)
        XCTAssertEqual(instructionsCell.firstReferenceTitle.text, bancomerTicketInstructions.references[0].label.uppercaseString)
        
        XCTAssertEqual(instructionsCell.firstReferenceValue.text, bancomerTicketInstructions.references[0].getFullReferenceValue())
        
        XCTAssertEqual(instructionsCell.secondReferenceTitle.text, bancomerTicketInstructions.references[1].label.uppercaseString)
        
        XCTAssertEqual(instructionsCell.secondReferenceValue.text, bancomerTicketInstructions.references[1].getFullReferenceValue())
        
    }
    
    func testBTTwoLabelsAndButtonBody(){
    
        var bancomerBTInstructions = Instruction()
        let expectInstructionIsLoaded = expectationWithDescription("loadBancomerBTInstructions")
        let mockedInstructionService = InstructionsService()
        mockedInstructionService.getInstructionsForPaymentId(MockBuilder.MOCK_PAYMENT_ID, paymentMethodId: "bancomer_bank_transfer", success: { (instruction) -> Void in
            self.instructionsViewController?.currentInstruction = instruction
            bancomerBTInstructions = instruction
            expectInstructionIsLoaded.fulfill()
            }) { (error) -> Void in
                
        }
        
        let instructionsCell = self.instructionsViewController!.resolveInstructionsBodyViewCell("bancomer_bank_transfer") as! InstructionsTwoLabelsAndButtonViewCell
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
        
        
        XCTAssertNotNil(instructionsCell.infoTitle.text)
        XCTAssertEqual(instructionsCell.infoTitle.text, bancomerBTInstructions.info[0])
        XCTAssertNotNil(instructionsCell.referenceLabelFirst)
        XCTAssertEqual(instructionsCell.referenceLabelFirst.text, bancomerBTInstructions.references[0].label.uppercaseString)
        
        XCTAssertEqual(instructionsCell.referenceValueFirst.text, bancomerBTInstructions.references[0].getFullReferenceValue())
        
        XCTAssertEqual(instructionsCell.referenceLabelSecond.text, bancomerBTInstructions.references[1].label.uppercaseString)
        
        XCTAssertEqual(instructionsCell.referenceValueSecond.text, bancomerBTInstructions.references[1].getFullReferenceValue())

    }
    
    func testBTInstructionsWithButtonBody(){
        
        var banamexBTInstructions = Instruction()
        let expectInstructionIsLoaded = expectationWithDescription("loadBancomerBTInstructions")
        let mockedInstructionService = InstructionsService()
        mockedInstructionService.getInstructionsForPaymentId(MockBuilder.MOCK_PAYMENT_ID, paymentMethodId: "banamex_bank_transfer", success: { (instruction) -> Void in
            self.instructionsViewController?.currentInstruction = instruction
            banamexBTInstructions = instruction
            expectInstructionIsLoaded.fulfill()
            }) { (error) -> Void in
                
        }
        
        let instructionsCell = self.instructionsViewController!.resolveInstructionsBodyViewCell("banamex_bank_transfer") as! InstructionsWithButtonViewCell
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
        
        
        XCTAssertNotNil(instructionsCell.referenceLabelFirst)
        XCTAssertEqual(instructionsCell.referenceLabelFirst.text, banamexBTInstructions.references[0].label.uppercaseString)
        XCTAssertNotNil(instructionsCell.referenceValueFirst)
        XCTAssertEqual(instructionsCell.referenceValueFirst.text, banamexBTInstructions.references[0].getFullReferenceValue())
        
        XCTAssertEqual(instructionsCell.referenceLabelSecond.text, banamexBTInstructions.references[1].label.uppercaseString)
        
        XCTAssertEqual(instructionsCell.referenceValueSecond.text, banamexBTInstructions.references[1].getFullReferenceValue())
        
        XCTAssertEqual(instructionsCell.referenceLabelThird.text, banamexBTInstructions.references[2].label.uppercaseString)
        
        XCTAssertEqual(instructionsCell.referenceValueThird.text, banamexBTInstructions.references[2].getFullReferenceValue())
        
    }
}
