//
//  ResultViewModelTest.swift
//  MercadoPagoSDKTests
//
//  Created by Demian Tejo on 31/10/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import XCTest

class ResultViewModelTest: BaseTest {
    
    let approvedTitleDummy = "ATD"
    let rejectedTitleDummy = "RTD"
    let pendingTitleDummy = "PTD"
    let approvedLabelDummy = "ALD"
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testViewModelWithoutPreferenceAndApprovedPayment() {
        let paymentResult = MockBuilder.buildPaymentResult("approved", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult, amount:1000.0, instructionsInfo: nil)
        let headerView = buildHeaderView(resultViewModel: resultViewModel)
        let footerView = buildFooterView(resultViewModel: resultViewModel)
        
        XCTAssertEqual(headerView.backgroundColor, UIColor.pxGreenMp)
        XCTAssertNil(footerView.principalButton)
        XCTAssertEqual(footerView.linkButton?.title(for: .normal), "Seguir comprando".localized)
        XCTAssertEqual(headerView.circleImage?.image, MercadoPago.getImage("default_item_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(headerView.badgeImage?.image, MercadoPago.getImage("ok_badge"))
        XCTAssertNil(headerView.statusLabel?.attributedText)
        XCTAssertEqual(headerView.messageLabel?.attributedText?.string, "¡Listo, se acreditó tu pago!".localized)
        XCTAssertTrue(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
    }
    
    func testViewModelWithoutPreferenceAndRejectedPayment() {
        let paymentResult = MockBuilder.buildPaymentResult("rejected", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult,amount:1000.0, instructionsInfo: nil)
        let headerView = buildHeaderView(resultViewModel: resultViewModel)
        let footerView = buildFooterView(resultViewModel: resultViewModel)
        XCTAssertEqual(footerView.principalButton?.title(for: .normal), "Pagar con otro medio".localized)
        XCTAssertEqual(footerView.linkButton?.title(for: .normal), "Cancelar pago".localized)
        XCTAssertEqual(headerView.backgroundColor, UIColor.pxRedMp)
        XCTAssertEqual(headerView.circleImage?.image, MercadoPago.getImage("card_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(headerView.badgeImage?.image, MercadoPago.getImage("error_badge"))
        XCTAssertEqual(headerView.statusLabel?.attributedText?.string, "Algo salió mal...".localized)
        XCTAssertFalse(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertTrue(resultViewModel.isError())
    }
    
    func testViewModelWithoutPreferenceAndPendingPayment() {
        let paymentResult = MockBuilder.buildPaymentResult("in_process", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult,amount:1000.0, instructionsInfo: nil)
        let headerView = buildHeaderView(resultViewModel: resultViewModel)
        let footerView = buildFooterView(resultViewModel: resultViewModel)
        XCTAssertNil(footerView.principalButton)
        XCTAssertEqual(footerView.linkButton?.title(for: .normal), "Seguir comprando".localized)
        XCTAssertEqual(headerView.backgroundColor, UIColor.pxGreenMp)
        XCTAssertEqual(headerView.circleImage?.image, MercadoPago.getImage("card_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(headerView.badgeImage?.image, MercadoPago.getImage("pending_badge"))
        XCTAssertNil(headerView.statusLabel?.attributedText)
        XCTAssertEqual(headerView.messageLabel?.attributedText?.string, "Estamos procesando el pago".localized)
        XCTAssertTrue(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
    }
    
    func testViewModelWithTextPreferenceAndApprovedPayment() {
        let preference = PaymentResultScreenPreference()
        preference.setApproved(title: approvedTitleDummy)
        preference.setApproved(labelText: approvedLabelDummy)
        let paymentResult = MockBuilder.buildPaymentResult("approved", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult,amount:1000.0, instructionsInfo: nil, paymentResultScreenPreference:preference)
        let headerView = buildHeaderView(resultViewModel: resultViewModel)
        let footerView = buildFooterView(resultViewModel: resultViewModel)
        XCTAssertNil(footerView.principalButton)
        XCTAssertEqual(footerView.linkButton?.title(for: .normal), "Seguir comprando".localized)
        XCTAssertEqual(headerView.backgroundColor, UIColor.pxGreenMp)
        XCTAssertEqual(headerView.circleImage?.image, MercadoPago.getImage("default_item_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(headerView.badgeImage?.image, MercadoPago.getImage("ok_badge"))
        XCTAssertTrue(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
        XCTAssertEqual(headerView.statusLabel?.attributedText?.string, approvedLabelDummy)
        XCTAssertEqual(headerView.messageLabel?.attributedText?.string, approvedTitleDummy)
    }
    
    func testViewModelWithTextPreferenceAndRejectedPayment() {
        let preference = PaymentResultScreenPreference()
        preference.setRejected(title: rejectedTitleDummy)
        let paymentResult = MockBuilder.buildPaymentResult("rejected", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult,amount:1000.0, instructionsInfo: nil, paymentResultScreenPreference: preference)
        let headerView = buildHeaderView(resultViewModel: resultViewModel)
        let footerView = buildFooterView(resultViewModel: resultViewModel)
        XCTAssertEqual(footerView.principalButton?.title(for: .normal), "Pagar con otro medio".localized)
        XCTAssertEqual(footerView.linkButton?.title(for: .normal), "Cancelar pago".localized)
        XCTAssertEqual(headerView.backgroundColor, UIColor.pxRedMp)
        XCTAssertEqual(headerView.circleImage?.image, MercadoPago.getImage("card_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(headerView.badgeImage?.image, MercadoPago.getImage("error_badge"))
        XCTAssertFalse(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertTrue(resultViewModel.isError())
        XCTAssertEqual(headerView.messageLabel?.attributedText?.string, rejectedTitleDummy)
        XCTAssertEqual(headerView.statusLabel?.attributedText?.string, "Algo salió mal...".localized)
    }
    
    func testViewModelWithTextPreferenceAndPendingPayment() {
        let preference = PaymentResultScreenPreference()
        preference.setPending(title: pendingTitleDummy)
        preference.disablePendingLabelText()
        let paymentResult = MockBuilder.buildPaymentResult("in_process", paymentMethodId: "visa")
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult,amount:1000.0, instructionsInfo: nil, paymentResultScreenPreference: preference)
        let headerView = buildHeaderView(resultViewModel: resultViewModel)
        let footerView = buildFooterView(resultViewModel: resultViewModel)
        XCTAssertNil(footerView.principalButton)
        XCTAssertEqual(footerView.linkButton?.title(for: .normal), "Seguir comprando".localized)
        XCTAssertEqual(headerView.backgroundColor, UIColor.pxGreenMp)
        XCTAssertEqual(headerView.circleImage?.image, MercadoPago.getImage("card_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(headerView.badgeImage?.image, MercadoPago.getImage("pending_badge"))
        XCTAssertTrue(resultViewModel.isAccepted())
        XCTAssertFalse(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
        XCTAssertEqual(headerView.statusLabel?.attributedText, nil)
        XCTAssertEqual(headerView.messageLabel?.attributedText?.string, "Estamos procesando el pago".localized)
    }
    
    func testViewModelWithTextPreferenceAndCallForAuth() {
        let preference = PaymentResultScreenPreference()
        preference.setPending(title: pendingTitleDummy)
        preference.disablePendingLabelText()
        let paymentResult = MockBuilder.buildPaymentResult("rejected", paymentMethodId: "visa")
        paymentResult.statusDetail = RejectedStatusDetail.CALL_FOR_AUTH
        paymentResult.paymentData?.payerCost = PayerCost(installments: 1, installmentRate: 1, labels: [], minAllowedAmount: 100, maxAllowedAmount: 100, recommendedMessage: "", installmentAmount: 1, totalAmount: 100)
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult,amount:1000.0, instructionsInfo: nil, paymentResultScreenPreference: preference)
        let headerView = buildHeaderView(resultViewModel: resultViewModel)
        let footerView = buildFooterView(resultViewModel: resultViewModel)
        XCTAssertEqual(footerView.principalButton?.title(for: .normal), "Pagar con otro medio".localized)
        XCTAssertEqual(footerView.linkButton?.title(for: .normal), "Cancelar pago".localized)
        XCTAssertEqual(headerView.backgroundColor, UIColor.pxOrangeMp)
        XCTAssertEqual(headerView.circleImage?.image, MercadoPago.getImage("card_icon", bundle: MercadoPago.getBundle()!))
        XCTAssertEqual(headerView.badgeImage?.image, MercadoPago.getImage("need_action_badge"))
        XCTAssertFalse(resultViewModel.isAccepted())
        XCTAssertTrue(resultViewModel.isWarning())
        XCTAssertFalse(resultViewModel.isError())
        XCTAssertEqual(headerView.statusLabel?.attributedText?.string, "Algo salió mal...".localized.toAttributedString().string)
    }
    
    func testBodyWithInstructions() {
        let paymentResult = MockBuilder.buildPaymentResult("pending", paymentMethodId: "rapipago")
        let paymentMethod = MockBuilder.buildPaymentMethod("rapipago")
        let instructionsInfo = MockBuilder.buildInstructionsInfo(paymentMethod: paymentMethod)
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult, amount: 1000.0, instructionsInfo: instructionsInfo)
        let bodyView = buildBodyView(resultViewModel: resultViewModel)
        
        //Instructions View
        guard let instructionsView = bodyView as? PXInstructionsView else {
            XCTAssertTrue(false, "The view is not of the expected class")
            return
        }
        
        //Instructions Subtitle View
        XCTAssertNotNil(instructionsView.subtitleView)
        let subtitleView = instructionsView.subtitleView as! PXInstructionsSubtitleView
        XCTAssertEqual(subtitleView.subtitleLabel?.text, "Veja como é fácil pagar o seu produto")
        
        //Instructions Secondary Info View
        XCTAssertNotNil(instructionsView.secondaryInfoView)
        let secondaryInfoView = instructionsView.secondaryInfoView as! PXInstructionsSecondaryInfoView
        XCTAssertEqual(secondaryInfoView.secondaryInfoLabels?.count, 1)
        XCTAssertEqual(secondaryInfoView.secondaryInfoLabels![0].text, "Uma cópia desse boleto foi enviada ao seu e-mail -payer.email- caso você precise realizar o pagamento depois.")
        
        //Instructions Content View
        XCTAssertNotNil(instructionsView.contentView)
        let contentView = instructionsView.contentView as! PXInstructionsContentView
        XCTAssertNotNil(contentView.infoView)
        XCTAssertNotNil(contentView.referencesView)
        XCTAssertNil(contentView.tertiaryInfoView)
        XCTAssertNotNil(contentView.accreditationTimeView)
        XCTAssertNil(contentView.actionsView)
        
        //Info View
        let infoView = contentView.infoView as! PXInstructionsInfoView
        XCTAssertNil(infoView.titleLabel)
        XCTAssertNotNil(infoView.contentLabels)
        XCTAssertEqual(infoView.contentLabels?.count, 2)
        XCTAssertEqual(infoView.contentLabels![0].text, "1. Acesse o seu Internet Banking ou abra o aplicativo do seu banco.")
        XCTAssertEqual(infoView.contentLabels![1].text, "2. Utilize o código abaixo para realizar o pagamento.")
        XCTAssertNil(infoView.bottomDivider)
        
        //References View
        let referencesView = contentView.referencesView as! PXInstructionsReferencesView
        XCTAssertNil(referencesView.titleLabel)
        XCTAssertNotNil(referencesView.referencesComponents)
        XCTAssertEqual(referencesView.referencesComponents?.count, 1)
        //Reference View
        let referenceView = referencesView.referencesComponents![0] as! PXInstructionsReferenceView
        XCTAssertNotNil(referenceView.titleLabel)
        XCTAssertNotNil(referenceView.referenceLabel)
        XCTAssertEqual(referenceView.titleLabel?.text, "Número")
        XCTAssertEqual(referenceView.referenceLabel?.text, "2379 1729 0000 0400 1003 3802 6025 4607 2909 0063 3330")
        
        //Accreditation Time View
        let accreditationTimeView = contentView.accreditationTimeView as! AccreditationTimeView
        XCTAssertNotNil(accreditationTimeView.accreditationMessageLabel)
        let text = "Assim que você pagar, será aprovado automaticamente entre 1 e 2 dias úteis, mas considere: Em caso de feriados, será identificado até às 18h do segundo dia útil subsequente ao feriado."
        let clockImage = NSTextAttachment()
        clockImage.image = MercadoPago.getImage("iconTime")
        let clockAttributedString = NSAttributedString(attachment: clockImage)
        let labelAttributedString = NSMutableAttributedString(string: String(describing: " "+text))
        labelAttributedString.insert(clockAttributedString, at: 0)
        let labelTitle = labelAttributedString
        
        XCTAssertEqual(accreditationTimeView.accreditationMessageLabel?.text, labelTitle.string)
        XCTAssertNil(accreditationTimeView.accreditationCommentsComponents)
    }
    
    func testBodyWithAllInstructionsComponents() {
        let paymentResult = MockBuilder.buildPaymentResult("pending", paymentMethodId: "rapipago")
        let instructionsInfo = MockBuilder.buildCompleteInstructionsInfo()
        let resultViewModel = PXResultViewModel(paymentResult: paymentResult, amount: 1000.0, instructionsInfo: instructionsInfo)
        let bodyView = buildBodyView(resultViewModel: resultViewModel)
        
        //Instructions View
        guard let instructionsView = bodyView as? PXInstructionsView else {
            XCTAssertTrue(false, "The view is not of the expected class")
            return
        }
        
        //Instructions Subtitle View
        XCTAssertNotNil(instructionsView.subtitleView)
        let subtitleView = instructionsView.subtitleView as! PXInstructionsSubtitleView
        XCTAssertEqual(subtitleView.subtitleLabel?.text, "Paga con estos datos")
        
        //Instructions Secondary Info View
        XCTAssertNotNil(instructionsView.secondaryInfoView)
        let secondaryInfoView = instructionsView.secondaryInfoView as! PXInstructionsSecondaryInfoView
        XCTAssertEqual(secondaryInfoView.secondaryInfoLabels?.count, 1)
        XCTAssertEqual(secondaryInfoView.secondaryInfoLabels![0].text, "También enviamos estos datos a tu email")
        
        //Instructions Content View
        XCTAssertNotNil(instructionsView.contentView)
        let contentView = instructionsView.contentView as! PXInstructionsContentView
        
        //Content View Sub components
        XCTAssertNotNil(contentView.infoView)
        XCTAssertNotNil(contentView.referencesView)
        XCTAssertNotNil(contentView.tertiaryInfoView)
        XCTAssertNotNil(contentView.accreditationTimeView)
        XCTAssertNotNil(contentView.actionsView)
        
        //Info View
        let infoView = contentView.infoView as! PXInstructionsInfoView
        XCTAssertNotNil(infoView.titleLabel)
        XCTAssertEqual(infoView.titleLabel?.text, "Primero sigue estos pasos en el cajero")
        XCTAssertNotNil(infoView.contentLabels)
        XCTAssertEqual(infoView.contentLabels?.count, 3)
        XCTAssertEqual(infoView.contentLabels![0].text, "1. Ingresa a Pagos")
        XCTAssertEqual(infoView.contentLabels![1].text, "2. Pagos de impuestos y servicios")
        XCTAssertEqual(infoView.contentLabels![2].text, "3. Rubro cobranzas")
        XCTAssertNotNil(infoView.bottomDivider)
        
        //References View
        let referencesView = contentView.referencesView as! PXInstructionsReferencesView
        XCTAssertNotNil(referencesView.titleLabel)
        XCTAssertEqual(referencesView.titleLabel?.text, "Luego te irá pidiendo estos datos")
        XCTAssertNotNil(referencesView.referencesComponents)
        XCTAssertEqual(referencesView.referencesComponents?.count, 3)
        //Reference View 0
        var referenceView = referencesView.referencesComponents![0] as! PXInstructionsReferenceView
        XCTAssertNotNil(referenceView.titleLabel)
        XCTAssertNotNil(referenceView.referenceLabel)
        XCTAssertEqual(referenceView.titleLabel?.text, "Referencia para abonar")
        XCTAssertEqual(referenceView.referenceLabel?.text, "2379 1729 0000 0400 1003 3802 6025 4607 2909 0063 3330")
        
        //Reference View 1
        referenceView = referencesView.referencesComponents![1] as! PXInstructionsReferenceView
        XCTAssertNotNil(referenceView.titleLabel)
        XCTAssertNotNil(referenceView.referenceLabel)
        XCTAssertEqual(referenceView.titleLabel?.text, "Concepto")
        XCTAssertEqual(referenceView.referenceLabel?.text, "MPAGO:COMPRA")
        
        //Reference View 2
        referenceView = referencesView.referencesComponents![2] as! PXInstructionsReferenceView
        XCTAssertNotNil(referenceView.titleLabel)
        XCTAssertNotNil(referenceView.referenceLabel)
        XCTAssertEqual(referenceView.titleLabel?.text, "Empresa")
        XCTAssertEqual(referenceView.referenceLabel?.text, "Mercado Libre - Mercado Pago")
        
        //Tertiary Info View
        let tertiaryInfoView = contentView.tertiaryInfoView as! PXInstructionsTertiaryInfoView
        XCTAssertNotNil(tertiaryInfoView.tertiaryInfoLabels)
        XCTAssertEqual(tertiaryInfoView.tertiaryInfoLabels?.count, 1)
        XCTAssertEqual(tertiaryInfoView.tertiaryInfoLabels![0].text, "Si pagas un fin de semana o feriado, será al siguiente día hábil.")
        
        //Accreditation Time View
        let accreditationTimeView = contentView.accreditationTimeView as! AccreditationTimeView
        XCTAssertNotNil(accreditationTimeView.accreditationMessageLabel)
        let text = "Assim que você pagar, será aprovado automaticamente entre 1 e 2 dias úteis, mas considere: Em caso de feriados, será identificado até às 18h do segundo dia útil subsequente ao feriado."
        let clockImage = NSTextAttachment()
        clockImage.image = MercadoPago.getImage("iconTime")
        let clockAttributedString = NSAttributedString(attachment: clockImage)
        let labelAttributedString = NSMutableAttributedString(string: String(describing: " "+text))
        labelAttributedString.insert(clockAttributedString, at: 0)
        let labelTitle = labelAttributedString
        XCTAssertEqual(accreditationTimeView.accreditationMessageLabel?.text, labelTitle.string)
        
        //Accreditation Comment Views
        XCTAssertNotNil(accreditationTimeView.accreditationCommentsComponents)
        XCTAssertEqual(accreditationTimeView.accreditationCommentsComponents?.count, 1)
        let accreditationCommentView = accreditationTimeView.accreditationCommentsComponents![0] as! AccreditationCommentView
        XCTAssertNotNil(accreditationCommentView.commentLabel)
        XCTAssertEqual(accreditationCommentView.commentLabel?.text, "Pagamentos realizados em correspondentes bancários podem ultrapassar este prazo.")
        
        //Actions View
        let actionsView = contentView.actionsView as! ActionsView
        XCTAssertNotNil(actionsView.actionsViews)
        XCTAssertEqual(actionsView.actionsViews?.count, 1)
        
        //Action View
        let actionView = actionsView.actionsViews![0] as! ActionView
        XCTAssertNotNil(actionView.actionButton)
        let actionButton = actionView.actionButton as! MPButton
        XCTAssertEqual(actionButton.titleLabel?.text, "Ir a banca en línea")
        XCTAssertEqual(actionButton.actionLink, "http://www.bancomer.com.mx")
    }
    
    func buildHeaderView(resultViewModel: PXResultViewModel) -> HeaderView {
        let data = HeaderProps(labelText: resultViewModel.labelTextHeader(), title: resultViewModel.titleHeader(), backgroundColor: resultViewModel.primaryResultColor(), productImage: resultViewModel.iconImageHeader(), statusImage: resultViewModel.badgeImage())
        let headerComponent = HeaderComponent(props: data)
        return HeaderRenderer().render(header: headerComponent)
    }
    
    func buildBodyView(resultViewModel: PXResultViewModel) -> PXBodyView {
        let props = resultViewModel.bodyComponentProps()
        let bodyComponent = PXBodyComponent(props: props)
        return PXBodyRenderer().render(body: bodyComponent)
    }
    
    func buildFooterView(resultViewModel: PXResultViewModel) -> FooterView {
        let data = FooterProps(buttonAction: resultViewModel.getActionButton(), linkAction: resultViewModel.getActionLink())
        let footerComponent = FooterComponent(props: data)
        return FooterRenderer().render(footer: footerComponent)
    }
}

