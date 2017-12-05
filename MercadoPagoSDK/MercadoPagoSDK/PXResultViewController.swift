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
    var headerView = UIView()
    var fooView: UIView!

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
        PXLayout.equalizeWidth(view: headerView, to: contentView).isActive = true
        
        let receiptView = self.buildReceiptView()
        contentView.addSubview(receiptView)
        PXLayout.put(view: receiptView, onBottomOf: headerView).isActive = true
        PXLayout.equalizeWidth(view: receiptView, to: contentView).isActive = true

        //Add Foo
        fooView = buildFooterView()
        contentView.addSubview(fooView)
        PXLayout.equalizeWidth(view: fooView, to: contentView).isActive = true
        PXLayout.pinBottom(view: fooView, to: contentView).isActive = true
        PXLayout.centerHorizontally(view: fooView, to: contentView).isActive = true
        self.view.layoutIfNeeded()
        PXLayout.setHeight(owner: fooView, height: fooView.frame.height).isActive = true

        //Add Body
        let bodyView = self.buildBodyView()
        contentView.addSubview(bodyView)
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        PXLayout.equalizeWidth(view: bodyView, to: contentView).isActive = true
        PXLayout.put(view: bodyView, onBottomOf: receiptView).isActive = true
        PXLayout.put(view: bodyView, aboveOf: fooView).isActive = true

        self.view.layoutIfNeeded()
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.contentView.frame.height)
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
