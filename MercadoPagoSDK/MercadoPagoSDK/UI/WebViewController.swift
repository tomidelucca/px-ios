//
//  WebViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 22/5/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class WebViewController: MercadoPagoUIViewController, UIWebViewDelegate {

    var url: URL
    var name: String?
    var navBarTitle: String
    let webView: UIWebView
    let forceAddNavBar: Bool
    private var loadingVC: PXLoadingViewController

    init(url: URL, screenName: String, navigationBarTitle: String, forceAddNavBar: Bool = false) {
        self.url = url
        self.name = screenName
        self.navBarTitle = navigationBarTitle
        self.forceAddNavBar = forceAddNavBar
        self.loadingVC = PXLoadingViewController()
        self.webView = UIWebView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
    }

    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUrl(url)

        self.webView.delegate = self
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.backgroundColor = .white
        self.view.addSubview(webView)
        PXLayout.pinLeft(view: webView).isActive = true
        PXLayout.pinRight(view: webView).isActive = true
        PXLayout.pinBottom(view: webView).isActive = true

        if self.navigationController == nil, forceAddNavBar {
            let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: PXLayout.getSafeAreaTopInset(), width: PXLayout.getScreenWidth(), height: 44))
            self.view.addSubview(navBar);

            navBar.isTranslucent = true
            navBar.barTintColor = ThemeManager.shared.whiteColor()
            navBar.tintColor = ThemeManager.shared.navigationBar().tintColor
            navBar.backgroundColor = ThemeManager.shared.getMainColor()
            navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)

            let textAttributes = [NSAttributedString.Key.foregroundColor:ThemeManager.shared.navigationBar().tintColor]
            navBar.titleTextAttributes = textAttributes

            let navItem = UINavigationItem(title: navBarTitle);
            let closeImage = ResourceManager.shared.getImage("modal_close_button")?.ml_tintedImage(with: ThemeManager.shared.navigationBar().getTintColor())
            let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(close))
            navItem.leftBarButtonItem = closeButton;
            navBar.setItems([navItem], animated: false);
            PXLayout.put(view: webView, onBottomOf: navBar).isActive = true
        } else {
            PXLayout.pinTop(view: webView).isActive = true
        }

        self.view.backgroundColor = ThemeManager.shared.getMainColor()
        self.present(loadingVC, animated: false, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showNavBar()
        trackScreen()
    }

    override func getNavigationBarTitle() -> String {
        return navBarTitle
    }

    func loadUrl(_ url: URL) {
        let requestObj = URLRequest(url: url)
        webView.loadRequest(requestObj)
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loadingVC.dismiss(animated: false, completion: nil)
    }
}

// MARK: Tracking
extension WebViewController {
    func trackScreen() {
        var properties: [String: Any] = [:]
        properties["url"] = url
        trackScreen(path: TrackingPaths.Screens.getTermsAndCondiontionPath(), properties: properties)
    }
}
