//
//  WebViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 22/5/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class WebViewController: MercadoPagoUIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    init() {
        super.init(nibName: "WebViewController", bundle: MercadoPago.getBundle())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUrl(url : NSURL){
        let requestObj = NSURLRequest(URL: url);
        webView.loadRequest(requestObj);
    }
    

}
