//
//  PXResultViewController.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 20/10/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

class PXResultViewController: PXComponentContainerViewController {

    let viewModel: PXResultViewModel
    var headerView: UIView!
    var receiptView: UIView!
    var footerView: UIView!
    var bodyView: UIView!

    init(viewModel: PXResultViewModel, callback : @escaping ( _ status: PaymentResult.CongratsState) -> Void) {
        self.viewModel = viewModel
        self.viewModel.callback = callback
        super.init()
        self.scrollView.backgroundColor = viewModel.primaryResultColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func renderViews() {
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        //Add Header
        headerView = self.buildHeaderView()
        contentView.addSubview(headerView)
        PXLayout.pinTop(view: headerView, to: contentView).isActive = true
        PXLayout.matchWidth(ofView: headerView, toView: contentView).isActive = true

        //Add Receipt
        receiptView = self.buildReceiptView()
        contentView.addSubview(receiptView)
        receiptView.translatesAutoresizingMaskIntoConstraints = false
        PXLayout.put(view: receiptView, onBottomOf: headerView).isActive = true
        PXLayout.matchWidth(ofView: receiptView, toView: contentView).isActive = true

        //Add Footer
        footerView = self.buildFooterView()
        contentView.addSubview(footerView)
        PXLayout.matchWidth(ofView: footerView, toView: contentView).isActive = true
        PXLayout.pinBottom(view: footerView, to: contentView).isActive = true
        PXLayout.centerHorizontally(view: footerView, to: contentView).isActive = true
        self.view.layoutIfNeeded()
        PXLayout.setHeight(owner: footerView, height: footerView.frame.height).isActive = true

        //Add Body
        bodyView = self.buildBodyView()
        contentView.addSubview(bodyView)
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        PXLayout.matchWidth(ofView: bodyView, toView: contentView).isActive = true
        PXLayout.put(view: bodyView, onBottomOf: receiptView).isActive = true
        PXLayout.put(view: bodyView, aboveOf: footerView).isActive = true
        
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
    }
    
    func expandHeader() {
        PXLayout.matchHeight(ofView: self.contentView, toView: self.scrollView).isActive = true
        PXLayout.setHeight(owner: self.bodyView, height: 0.0).isActive = true
        PXLayout.setHeight(owner: self.receiptView, height: 0.0).isActive = true
    }
    
    func expandBody() {
        self.view.layoutIfNeeded()
        let footerHeight = self.footerView.frame.height
        let headerHeight = self.headerView.frame.height
        let restHeight = self.scrollView.frame.height - footerHeight - headerHeight
        PXLayout.setHeight(owner: bodyView, height: restHeight).isActive = true
    }

    func isEmptySpaceOnScreen() -> Bool {
        self.view.layoutIfNeeded()
        return self.contentView.frame.height < self.scrollView.frame.height
    }
    
    func shouldExpandHeader() -> Bool {
        self.view.layoutIfNeeded()
        return bodyView.frame.height == 0
    }
    
    func buildHeaderView() -> UIView {
        let headerProps = self.viewModel.getHeaderComponentProps()
        let headerComponent = PXHeaderComponent(props: headerProps)
        return headerComponent.render()
    }
    func buildFooterView() -> UIView {
        let footerProps = self.viewModel.getFooterComponentProps()
        let footerComponent = PXFooterComponent(props: footerProps)
        return footerComponent.render()
    }

    func buildReceiptView() -> UIView {
        let receiptProps = self.viewModel.getReceiptComponentProps()
        let receiptComponent = PXReceiptComponent(props: receiptProps)
        return receiptComponent.render()
    }
    func buildBodyView() -> UIView {
        let bodyProps = self.viewModel.getBodyComponentProps()
        let bodyComponent = PXBodyComponent(props: bodyProps)
        return bodyComponent.render()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController != nil && self.navigationController?.navigationBar != nil {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            ViewUtils.addStatusBar(self.view, color: viewModel.primaryResultColor())
        }
        renderViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
