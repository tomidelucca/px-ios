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
        MPLayout.pinTop(view: headerView, to: contentView).isActive = true
        MPLayout.equalizeWidth(view: headerView, to: contentView).isActive = true
        self.view.layoutIfNeeded()
        MPLayout.setHeight(owner: headerView, height: headerView.frame.height).isActive = true

        //Add Foo
        fooView = buildFooterView()
        contentView.addSubview(fooView)
        MPLayout.equalizeWidth(view: fooView, to: contentView).isActive = true
        MPLayout.pinBottom(view: fooView, to: contentView).isActive = true
        MPLayout.centerHorizontally(view: fooView, to: contentView).isActive = true
        self.view.layoutIfNeeded()
        MPLayout.setHeight(owner: fooView, height: fooView.frame.height).isActive = true

        //Add Body
        let bodyView = buildBodyView()
        contentView.addSubview(bodyView)
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        MPLayout.equalizeWidth(view: bodyView, to: contentView).isActive = true
        MPLayout.put(view: bodyView, onBottomOf: headerView).isActive = true
        MPLayout.put(view: bodyView, aboveOf: fooView).isActive = true
        self.view.layoutIfNeeded()

      /*
        let h = bodyView.frame.height + fooView.frame.height + headerView.frame.height
        if scrollView.frame.height > h {
            MPLayout.setHeight(owner: contentView, height:scrollView.frame.height ).isActive = true
        }else{
            MPLayout.setHeight(owner: contentView, height:h ).isActive = true
        }
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: bodyView.frame.height + fooView.frame.height + headerView.frame.height)
        self.view.layoutIfNeeded()
 */
    }

    func buildHeaderView() -> UIView {
        let dataHeader = self.viewModel.headerComponentData()
        let componentHeader = HeaderComponent(data: dataHeader)
        let rendererHeader = HeaderRenderer()
        return rendererHeader.render(header: componentHeader)
    }
    func buildFooterView() -> UIView {
        let dataFoo = self.viewModel.getFooterComponentData()
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
