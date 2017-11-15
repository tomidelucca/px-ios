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
    var callback: (PaymentResult.CongratsState) -> Void

    init(viewModel: PXResultViewModel, callback : @escaping ( _ status: PaymentResult.CongratsState) -> Void) {
        self.callback = callback
        self.viewModel = viewModel
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
        MPLayout.pinTop(view: headerView, to: contentView).isActive = true
        MPLayout.equalizeWidth(view: headerView, to: contentView).isActive = true

        //Add Foo
        fooView = buildFooterView()
        contentView.addSubview(fooView)
        MPLayout.equalizeWidth(view: fooView, to: contentView).isActive = true
        MPLayout.pinBottom(view: fooView, to: contentView).isActive = true
        MPLayout.centerHorizontally(view: fooView, to: contentView).isActive = true
        
        //Add Body
        let bodyView = buildBodyView()
        contentView.addSubview(bodyView)
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        MPLayout.equalizeWidth(view: bodyView, to: contentView).isActive = true
        MPLayout.put(view: bodyView, onBottomOf: headerView).isActive = true
        MPLayout.put(view: bodyView, aboveOf: fooView).isActive = true

        self.view.layoutIfNeeded()
    }

    func buildHeaderView() -> UIView {
        let dataHeader = self.viewModel.headerComponentData()
        let componentHeader = HeaderComponent(data: dataHeader)
        let rendererHeader = HeaderRenderer()
        return rendererHeader.render(header: componentHeader)
    }
    func buildFooterView() -> UIView {
        let action1 = FooterAction(label: "boton grande") {
            print("boton grande presionado")
        }
        
        let action2 = FooterAction(label: "boton link") {
            print("boton LINK presionado")
        }
        let dataFoo = FooterData(buttonAction: action1, linkAction: action2)
        let componentFoo = FooterComponent(data: dataFoo)
        let rendererFoo = FooterRenderer()
        return rendererFoo.render(footer: componentFoo)
    }
    func buildBodyView() -> UIView {
        let dataBody = BodyData(text: "Aca va el texto del body")
        let componentBody = BodyComponent(data: dataBody)
        let rendererBody = BodyRenderer()
        return rendererBody.render(body: componentBody)
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
