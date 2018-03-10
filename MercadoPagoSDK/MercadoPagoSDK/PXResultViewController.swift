//
//  PXResultViewController.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 20/10/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit
import MercadoPagoPXTracking

class PXResultViewController: PXComponentContainerViewController {
    
    override open var screenName: String { get { return TrackingUtil.SCREEN_NAME_PAYMENT_RESULT } }
    override open var screenId: String { get { return TrackingUtil.SCREEN_ID_PAYMENT_RESULT } }
    
    let viewModel: PXResultViewModelInterface
    var headerView: UIView?
    var receiptView: UIView?
    var topCustomView: UIView?
    var bottomCustomView: UIView?
    var bodyView: UIView?
    var footerView: UIView?
    
    init(viewModel: PXResultViewModelInterface, callback : @escaping ( _ status: PaymentResult.CongratsState) -> Void) {
        self.viewModel = viewModel
        self.viewModel.setCallback(callback: callback)
        super.init()
        self.scrollView.backgroundColor = viewModel.primaryResultColor()
        self.shouldHideNavigationBar = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func trackInfo() {
        
        var metadata = [TrackingUtil.METADATA_PAYMENT_IS_EXPRESS: TrackingUtil.IS_EXPRESS_DEFAULT_VALUE,
                        TrackingUtil.METADATA_PAYMENT_STATUS: self.viewModel.getPaymentStatus(),
                        TrackingUtil.METADATA_PAYMENT_STATUS_DETAIL: self.viewModel.getPaymentStatusDetail(),
                        TrackingUtil.METADATA_PAYMENT_ID: self.viewModel.getPaymentId()]
        if let pm = self.viewModel.getPaymentData().getPaymentMethod() {
            metadata[TrackingUtil.METADATA_PAYMENT_METHOD_ID] = pm._id
        }
        if let issuer = self.viewModel.getPaymentData().getIssuer() {
            metadata[TrackingUtil.METADATA_ISSUER_ID] = issuer._id
        }
        
        let finalId = "\(screenId)/\(self.viewModel.getPaymentStatus())"
        
        var name = screenName
        if self.viewModel.isCallForAuth() {
            name = TrackingUtil.SCREEN_NAME_PAYMENT_RESULT_CALL_FOR_AUTH
        }
        
        MPXTracker.trackScreen(screenId: finalId, screenName: name, metadata: metadata)
    }
    
    func renderViews() {
        
        self.contentView.prepareforRender()
        
        //Add Header
        self.headerView = self.buildHeaderView()
        if let headerView = self.headerView {
            contentView.addSubview(headerView)
            PXLayout.pinTop(view: headerView, to: contentView).isActive = true
            PXLayout.matchWidth(ofView: headerView).isActive = true
        }

        //Add Receipt
        self.receiptView = self.buildReceiptView()
        if let receiptView = self.receiptView {
            receiptView.addSeparatorLineToBottom(height: 1)
            contentView.addSubviewToButtom(receiptView)
            PXLayout.matchWidth(ofView: receiptView).isActive = true
        }
       
        
        //Add Top Custom Component
        self.topCustomView = buildTopCustomView()
        if let topCustomView = self.topCustomView {
            topCustomView.clipsToBounds = true
            contentView.addSubviewToButtom(topCustomView)
            PXLayout.matchWidth(ofView: topCustomView).isActive = true
        }
        
        
        
        //Add Body
        self.bodyView = self.buildBodyView()
        if let bodyView = self.bodyView {
            contentView.addSubviewToButtom(bodyView)
            PXLayout.matchWidth(ofView: bodyView).isActive = true
            PXLayout.centerHorizontally(view: bodyView).isActive = true
            bodyView.addSeparatorLineToBottom(height: 1)
        }
        
        
        //Add Bottom Custom Component
        self.bottomCustomView = buildBottomCustomView()
        if let bottomCustomView = self.bottomCustomView{
            bottomCustomView.clipsToBounds = true
            contentView.addSubviewToButtom(bottomCustomView)
            PXLayout.matchWidth(ofView: bottomCustomView).isActive = true
        }
   
        //Add Footer
        self.footerView = self.buildFooterView()
        if let footerView = self.footerView {
            contentView.addSubviewToButtom(footerView)
            PXLayout.matchWidth(ofView: footerView).isActive = true
            PXLayout.centerHorizontally(view: footerView, to: contentView).isActive = true
            self.view.layoutIfNeeded()
            PXLayout.setHeight(owner: footerView, height: footerView.frame.height).isActive = true
        }

        PXLayout.pinLastSubviewToBottom(view: contentView)?.isActive = true
        super.refreshContentViewSize()
        if isEmptySpaceOnScreen() {
            if shouldExpandHeader() {
                expandHeader()
            } else {
                expandBody()
            }
        }
        self.view.layoutIfNeeded()
        self.contentView.layoutIfNeeded()
        self.view.layoutIfNeeded()
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.contentView.frame.height)
        super.refreshContentViewSize()
    }
    
    func expandHeader() {
        self.view.layoutIfNeeded()
        self.scrollView.layoutIfNeeded()
        if let bodyView = self.bodyView {
            PXLayout.setHeight(owner: bodyView, height: 0.0).isActive = true
        }
        if let receiptView = self.receiptView {
            PXLayout.setHeight(owner: receiptView, height: 0.0).isActive = true
        }
        PXLayout.setHeight(owner: self.contentView, height: totalContentViewHeigth()).isActive = true
    }
    
    func expandBody() {
        guard let bodyView = self.bodyView else {
            return
        }
        self.view.layoutIfNeeded()
        self.scrollView.layoutIfNeeded()
        let headerHeight = self.headerView != nil ? self.headerView?.frame.height : 0
        let footerHeight = self.footerView != nil ? self.footerView?.frame.height : 0
        let receiptHeight = self.receiptView != nil ? self.receiptView?.frame.height : 0
        let topCustomViewHeight = self.topCustomView != nil ? self.topCustomView?.frame.height : 0
        let bottomCustomViewHeight = self.bottomCustomView != nil ? self.bottomCustomView?.frame.height : 0
        let restHeight = totalContentViewHeigth() - footerHeight! - headerHeight! - receiptHeight! - topCustomViewHeight! - bottomCustomViewHeight!
        PXLayout.setHeight(owner: bodyView, height: restHeight).isActive = true
    }
    
    func isEmptySpaceOnScreen() -> Bool {
        self.view.layoutIfNeeded()
        return self.contentView.frame.height < totalContentViewHeigth()
    }
    
    func shouldExpandHeader() -> Bool {
        self.view.layoutIfNeeded()
        return bodyView?.frame.height == 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ViewUtils.addStatusBar(self.view, color: viewModel.primaryResultColor())
        self.view.layoutIfNeeded()
        renderViews()
    }
}

// Components
extension PXResultViewController {
    func buildHeaderView() -> UIView {
        let headerComponent = viewModel.buildHeaderComponent()
        return headerComponent.render()
    }
    
    func buildFooterView() -> UIView {
        let footerComponent = viewModel.buildFooterComponent()
        return footerComponent.render()
    }
    
    func buildReceiptView() -> UIView? {
        let receiptComponent = viewModel.buildReceiptComponent()
        return receiptComponent?.render()
    }
    
    func buildBodyView() -> UIView? {
        let bodyComponent = viewModel.buildBodyComponent()
        return bodyComponent?.render()
    }
    
    func buildTopCustomView() -> UIView? {
        if let component = self.viewModel.buildTopCustomComponent(), let componentView = component.render(store: PXCheckoutStore.sharedInstance, theme: ThemeManager.shared.getTheme()) {
            return componentView
        }
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func buildBottomCustomView() -> UIView? {
        if let component = self.viewModel.buildBottomCustomComponent(), let componentView = component.render(store: PXCheckoutStore.sharedInstance, theme: ThemeManager.shared.getTheme()) {
            return componentView
        }
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

